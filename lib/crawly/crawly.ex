defmodule Crawly do

  @file_path "data.json"
  def fetch(url) do

    #url=url <> "?page="

    url= case  String.contains?(url, "?") do
      true ->url<> "&page="
      _ -> url <> "?page="
    end
    total = total_page(url)+1
    crawl_all(total,url)
  end

  @spec save_file(binary) :: :ok | {:error, atom}
  def save_file(url) do
    url= case  String.contains?(url, "?") do
      true ->url<> "&page="
      _ -> url <> "?page="
    end
    total = total_page(url)+1
    list_item=crawl_all(total,url)
    json = %{
      "crawled_at" => DateTime.now!("Etc/UTC")|>DateTime.to_string()|>String.slice(0..-9),
      "total" => Enum.count(list_item),
      "items"=>list_item
    }

    #content = inspect(json, pretty: true) |>String.replace("%","")|>String.replace("=>",":")
    content=Jason.encode!(json)


    case File.write(@file_path,content) do
      :ok ->
        true
      #{:error, reason} -> false
        _ -> false
    end
  end


  def crawl_all(total_page, url) do
    total=total_page
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
            |> Enum.map(fn item ->
              %{
                "title" => Floki.find(item, "a.film-title") |> Floki.text(),
                "link" => Floki.find(item, ".film-cover") |> Floki.attribute("href")|> Enum.at(0),
                "full_series" =>!(Floki.find(item, "span.sub")|> Floki.text()|>String.contains?(["Tập"])),
                "thumnail" => Floki.find(item, ".poster") |> Floki.attribute("style")|> Enum.at(0)|>String.slice(22..-2),
                "number_of_episode" => Floki.find(item, "span.sub") |> Floki.text()|>String.split("/")|> List.first() |> String.split(~r"[^\d]", trim: true)|> Enum.at(0),
                "years" => Floki.find(item, ".poster") |> Floki.attribute("style")|> Enum.at(0)|>String.slice(22..-2)|>String.slice(40..-1)|>String.split("/")|> List.first(1),
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

    page=documents
    |> Floki.find(".pagination a") |> Floki.attribute("href")


    if page ==[] do
      paging=0
    else
      paging = documents
      |> Floki.find(".pagination a") |> Floki.attribute("href")
      |> Enum.map(fn x ->String.replace(x,url,"")end)

      |> Enum.map(&String.to_integer/1)
      |> Enum.max()
    end
  end
end
