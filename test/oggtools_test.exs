defmodule OggToolsTest do
  use ExUnit.Case
  doctest OggTools

  @path "test/resources/2ch_q6.ogg"

  test "read first page" do
    stream = OggTools.ogg_page_stream(@path)
    page = stream |> Enum.take(1)

    assert page == [
      %Ogg.Page{
        header: %Ogg.Page.Header{
          granule_position: 0,
          page_checksum: 283251598,
          page_segments: 1,
          page_sequence_number: 0,
          segment_table: [30],
          stream_serial_number: 195003078,
          type: 2
        },
        segments: [
          <<1, 118, 111, 114, 98, 105, 115, 0,
            0, 0, 0, 2, 68, 172, 0, 0, 0, 0, 0,
            0, 0, 238, 2, 0, 0, 0, 0, 0, 184, 1>>
        ]
      }
    ]
  end

  test "read second page header" do
    stream = OggTools.ogg_page_stream(@path)
    [page] = stream |> Enum.drop(1) |> Enum.take(1)
    header = page.header

    assert header == %Ogg.Page.Header{
      granule_position: 0,
      page_checksum: 604460919,
      page_segments: 21,
      page_sequence_number: 1,
      segment_table: [255, 255, 255, 255, 255, 6, 255, 255,
                      255, 255, 255, 255, 255, 255, 255, 255,
                      255, 255, 255, 255, 113],
      stream_serial_number: 195003078,
      type: 0
    }
  end
end
