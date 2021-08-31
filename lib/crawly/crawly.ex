defmodule Crawly do

  @file_path "data.json"
  def fetch(url) do
    total = total_page(url)
    crawl_all(total,url)
  end

  def save_file(url) do
    total = total_page(url)
    list_item=crawl_all(total,url)
    json = %{
      "crawled_at" => DateTime.now!("Etc/UTC")|>DateTime.to_string()|>String.slice(0..-9),
      "total" => Enum.count(list_item),
      "items"=>list_item
    }
    content = inspect(json, pretty: true) |>String.replace("%","")|>String.replace("=>",":")
    File.write(@file_path,content)
    # File.open(@file_path,[:write, :delayed_write],fn file ->
    #   IO.write(content) end)
    # if File.exists?(@file_path) do
    #   :erlang.binary_to_term(File.read!(@file_path))
    # else
    #   File.write(@file_path, :erlang.term_to_binary(json))
    # end

  end


  def crawl_all(total_page, url) do
    total=(total_page)
    res =
    Enum.map(1..total, fn x ->
      {:ok, documents} =
          (url <> "#{x}")
          |> HTTPoison.get!()
          |> Map.get(:body)
          |> Floki.parse_document()
        items =
          documents
            |> Floki.find("div.col-xs-6")
            |> Enum.map(fn entry ->
              %{
                "title" => Floki.find(entry, "a.film-title") |> Floki.text(),
                "link" => Floki.find(entry, ".film-cover") |> Floki.attribute("href")|> Enum.at(0),
                "full_series" =>!(Floki.find(entry, "span.sub")|> Floki.text()|>String.contains?(["Tập"])),
                "thumnail" => Floki.find(entry, ".poster") |> Floki.attribute("style")|> Enum.at(0)|>String.slice(22..-2),
                "number_of_episode" => Floki.find(entry, "span.sub") |> Floki.text()|>String.split("/")|> List.first() |> String.split(~r"[^\d]", trim: true)|> Enum.at(0),
                "years" => Floki.find(entry, ".poster") |> Floki.attribute("style")|> Enum.at(0)|>String.slice(22..-2)|>String.slice(40..-1)|>String.split("/")|> List.first(1),
              }
            end)

        items
    end)

    res|>List.flatten()

  end
  def total_page(url) do
    {:ok, documents} = url
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Floki.parse_document()

    paging = documents
    |> Floki.find(".pagination a") |> Floki.attribute("href")
    |> Enum.map(fn x ->String.replace(x,"https://phephims.net/the-loai/phim-hoat-hinh?page=","")end)
    |> Enum.max_by(fn x -> String.length(x) end)
    paging |>String.to_integer()
  end
end
