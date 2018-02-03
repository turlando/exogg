defmodule Ogg.Page.Header do
  @header_size 27

  defstruct [
    :type,
    :granule_position,
    :stream_serial_number,
    :page_sequence_number,
    :page_checksum,
    :page_segments,
    :segment_table
  ]

  def resource(file) do
    with <<
      "OggS", 0,
      type::little-unsigned-integer-size(8),
      granule_position::little-signed-integer-size(64),
      stream_serial_number::little-unsigned-integer-size(32),
      page_sequence_number::little-unsigned-integer-size(32),
      page_checksum::little-unsigned-integer-size(32),
      page_segments::little-unsigned-integer-size(8)
    >> <- IO.binread(file, @header_size) do
      segment_table =
        IO.binread(file, page_segments)
        |> :binary.bin_to_list()

      header = %Ogg.Page.Header{
        type: type,
        granule_position: granule_position,
        stream_serial_number: stream_serial_number,
        page_sequence_number: page_sequence_number,
        page_checksum: page_checksum,
        page_segments: page_segments,
        segment_table: segment_table
      }
      {[header], file}
    else
      _ -> {:halt, file}
    end
  end
end

defmodule Ogg.Page do
  alias Ogg.Page.Header, as: Header

  defstruct [
    :header,
    :segments
  ]

  def resource(file) do
    header = Header.resource(file)

    case header do
      {:halt, _} -> {:halt, file}
      {[header], file} ->
        segments =
          for segment_size <- header.segment_table do
            IO.binread(file, segment_size)
          end

        page =
          %Ogg.Page{
            header: header,
            segments: segments
          }

        {[page], file}
    end
  end
end
