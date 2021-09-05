defmodule Exercise2Data do
  # import Ecto.Query
  alias Exercise2.Repo
  alias Exercise2.Categorys
  alias Exercise2.Films

  def insert_category(data) do
    category_to_insert = [
      %{name: "Phim Âu"},
      %{name: "Phim Á"}
    ]

    Repo.insert_all(Categorys, category_to_insert)

    # caterogy=%CategorySchema{name: "Phim Hoat hinh"}
    # Repo.insert(caterogy)

    # category_to_insert=
    # [
    #   %{name: "Phim Việt Nam",inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(),:second), updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(),:second)},
    #   %{name: "Phim Hành động",inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(),:second),updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(),:second)}
    # ]
  end

  @spec insert_film(any) :: none
  def insert_film(data) do
    # data = [
    #   %{
    #     full_series: false,
    #     link: "https://phephims.net/phim/van-gioi-tien-tung-7207",
    #     number_of_episode: 198,
    #     thumnail: "https://i0.wp.com/img.media3s.xyz/image/2019/04/van-gioi-tien-tung.jpg",
    #     title: "Vạn Giới Tiên Tung",
    #     year: 2019
    #   },
    #   %{
    #     full_series: true,
    #     link: "https://phephims.net/phim/nhung-thien-than-sa-nga-4l0-7121",
    #     number_of_episode: 12,
    #     thumnail: "https://i0.wp.com/img.media3s.xyz/image/2019/04/nhung-thien-than-sa-nga.jpg",
    #     title: "Những Thiên Thần Sa Ngã",
    #     year: 2019
    # },
    # %{
    #     full_series: true,
    #     link: "https://phephims.net/phim/biet-doi-giai-cuu-rong-8411",
    #     number_of_episode: 14,
    #     thumnail: "https://i0.wp.com/img.media3s.xyz/image/2020/01/biet-doi-giai-cuu-rong.jpg",
    #     title: "Biệt Đội Giải Cứu Rồng",
    #     year: 2020
    # }
    # ]

    # case lst do
    #   ""-> 0
    #   _ ->String.to_integer(lst)
    # end
    #raise data
    Repo.insert_all(Films,data)

    # end
    # Repo.insert_all(Films,data)
  end
end
