defmodule CategoryData do
  #import Ecto.Query
  alias Exercise2.Repo
  alias Exercise2.Categorys


  def insert_category() do

    category_to_insert=
    [
      %{name: "Phim Âu"},
      %{name: "Phim Á"}
    ]

    Repo.insert_all(Categorys,category_to_insert)

    # caterogy=%CategorySchema{name: "Phim Hoat hinh"}
    #Repo.insert(caterogy)


     # category_to_insert=
    # [
    #   %{name: "Phim Việt Nam",inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(),:second), updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(),:second)},
    #   %{name: "Phim Hành động",inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(),:second),updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(),:second)}
    # ]
  end
end
