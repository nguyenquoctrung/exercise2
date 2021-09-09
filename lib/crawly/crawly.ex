defmodule Crawly do
  def fetch(url) do
    total = total_page(url) + 1
    crawl(total, url)
  end

  def fetch_all(url) do
    total = total_page(url) + 1
    crawl_all(total, url)
  end

  def fetch_number(url, number) do
    number = String.to_integer(number)
    crawl_all(number, url)
  end

  @spec save_file(binary) :: :ok | {:error, atom}
  def save_file(url) do
    total = total_page(url) + 1
    list_item = crawl_all(total, url)

    json = %{
      "crawled_at" => DateTime.now!("Etc/UTC") |> DateTime.to_string() |> String.slice(0..-9),
      "total" => Enum.count(list_item),
      "items" => list_item
    }

    # content = inspect(json, pretty: true) |>String.replace("%","")|>String.replace("=>",":")
    content = Jason.encode!(json)

    file_name =
      DateTime.now!("Etc/UTC")
      |> DateTime.to_string()
      |> String.slice(8..-9)
      |> String.replace(" ", "_")
      |> String.replace(":", "_")

    res =
      case File.write("file_" <> file_name <> "_data.json", content) do
        :ok ->
          "file_" <> file_name <> "_data.json"
        _ ->
          nil
        # {:error, reason} -> false
      end

    res
  end

  def crawl(total_page, url) do
    total = total_page
    res =
      Enum.map(1..total, fn x ->
        Process.sleep(random_latency())

        {:ok, documents} =
          (String.replace(url, ".html", "") <> "/trang-#{x}.html")
          |> HTTPoison.get!()
          |> Map.get(:body)
          |> Floki.parse_document()

        documents
        |> Floki.find("div.hayghelist")
        |> Enum.map(fn item ->
          %{
            title: Floki.find(item, ".title .name") |> Floki.text(),
            link: Floki.find(item, ".hayghelist a") |> Floki.attribute("href") |> Enum.at(0),
            full_series:
              !(Floki.find(item, "lable.current-status")
                |> Floki.text()
                |> String.contains?(["Tập"])),
            thumnail:
              Floki.find(item, "img")
              |> Floki.attribute("src")
              |> Enum.at(0),
            number_of_episode:
              check_number(
                Floki.find(item, "lable.current-status")
                |> Floki.text()
                |> String.split("/")
                |> List.first()
                |> String.split(~r"[^\d]", trim: true)
                |> Enum.at(0)
              )
          }
        end)
      end)

    res |> List.flatten()
  end

  def crawl_all(total_page, url) do
    total = total_page

    res =
      Enum.map(1..total, fn x ->
        Process.sleep(random_latency())

        {:ok, documents} =
          (String.replace(url, ".html", "") <> "/trang-#{x}.html")
          |> HTTPoison.get!()
          |> Map.get(:body)
          |> Floki.parse_document()

        documents
        |> Floki.find("div.hayghelist")
        |> Enum.map(fn item ->
          %{
            title: Floki.find(item, ".title .name") |> Floki.text(),
            link: Floki.find(item, ".hayghelist a") |> Floki.attribute("href") |> Enum.at(0),
            full_series:
              !(Floki.find(item, "lable.current-status")
                |> Floki.text()
                |> String.contains?(["Tập"])),
            thumnail:
              Floki.find(item, "img")
              |> Floki.attribute("src")
              |> Enum.at(0),
            number_of_episode:
              check_number(
                Floki.find(item, "lable.current-status")
                |> Floki.text()
                |> String.split("/")
                |> List.first()
                |> String.split(~r"[^\d]", trim: true)
                |> Enum.at(0)
              )
            # ,
            # # years:
            #   Floki.find(item, ".poster")
            #   |> Floki.attribute("style")
            #   |> Enum.at(0)
            #   |> String.slice(22..-2)
            #   |> String.slice(40..-1)
            #   |> String.split("/")
            #   |> List.first(1)
            #   |> String.to_integer()
          }
          |> Map.merge(
            crawl_detail(
              Floki.find(item, ".hayghelist a")
              |> Floki.attribute("href")
              |> Enum.at(0)
            )
          )
        end)
      end)

    res |> List.flatten()
  end

  def crawl_detail(url) do
    Process.sleep(random_latency())

    {:ok, documents} =
      url
      |> HTTPoison.get!()
      |> Map.get(:body)
      |> Floki.parse_document()

    film_infor = documents |> Floki.find(".meta-data")

    %{
      directors:
        more_infor(film_infor, "Đạo diễn:")
        |> Enum.drop_while(fn x -> is_nil(x) end)
        |> Enum.at(0)
        |> check_nil(),
      actors:
        more_infor(film_infor, "Diễn viên:")
        |> Enum.drop_while(fn x -> is_nil(x) end)
        |> Enum.at(0)
        |> check_nil(),
      country:
        more_infor(film_infor, "Quốc gia:")
        |> Enum.drop_while(fn x -> is_nil(x) end)
        |> Enum.at(0)
        |> check_nil(),
      release_year:
        more_infor(film_infor, "Năm SX:")
        |> Enum.drop_while(fn x -> is_nil(x) end)
        |> Enum.at(0)
        |> check_nil()
    }
  end

  defp check_number(data) do
    case data do
      nil -> 0
      _ -> String.to_integer(data)
    end
  end

  defp check_nil(string) do
    if is_nil(string) do
      "Đang cập nhật"
    else
      string
    end
  end

  def total_page(url) do
    {:ok, documents} =
      url
      |> HTTPoison.get!()
      |> Map.get(:body)
      |> Floki.parse_document()

    page = documents |> Floki.find(".pagination a") |> Floki.attribute("href")

    if page == [] do
      0
    else
      documents
      |> Floki.find(".pagination a")
      |> Floki.attribute("href")
      |> Enum.map(fn x -> String.replace(x, ~r/[^\d]/, "") end)
      |> Enum.map(&String.to_integer/1)
      |> Enum.max()
    end
  end

  def more_infor(data, value) do
    Enum.map(1..7, fn x ->
      list_data =
        data
        |> Floki.find("li:nth-of-type(#{x})")
        |> Floki.text()

      case value do
        "Đạo diễn:" ->
          if String.contains?(list_data, value) == true do
            String.replace(list_data, value, "") |> String.trim()
          end

        "Diễn viên:" ->
          if String.contains?(list_data, value) == true do
            String.replace(list_data, value, "") |> String.trim()
          end

        "Năm SX:" ->
          if String.contains?(list_data, value) == true do
            years =
              list_data
              |> String.split("|")
              |> List.last()
              |> String.split(~r"[^\d]", trim: true)

            years |> Enum.at(0)
          end

        "Quốc gia:" ->
          if String.contains?(list_data, value) == true do
            String.replace(list_data, value, "") |> String.trim()
          end
      end
    end)
  end

  defp random_latency do
    Enum.random(500..1000)
  end
end
