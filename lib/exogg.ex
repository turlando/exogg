defmodule ExOgg do
  def ogg_page_stream(path) do
    Stream.resource(
      fn -> File.open!(path) end,
      &Ogg.Page.resource/1,
      fn file -> File.close(file) end
    )
  end
end
