defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_colour
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def pick_colour(image) do
    %Identicon.Image{hex: [r, g, b | _tail]} = image
    Map.put(image, :colour, {r, g, b})
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(fn row -> mirror_row(row) end)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
    # Enum.map(chunked_grid, fn row -> mirror_row(row) end)

    # Enum.map(chunked_grid, fn row ->
    #   [first, second | _tail] = row
    #   row ++ [second, first]
    # end)
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn square ->
        rem(elem(square, 0), 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50
        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def draw_image(%Identicon.Image{colour: colour, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(colour)

    Enum.map(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  def mirror_row(row) do
    [first, second | _tail] = row

    row ++ [second, first]
  end

  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
