defmodule CarparkSgWeb.InformationView do
  use CarparkSgWeb, :view
  alias CarparkSgWeb.InformationView

  def render("index.json", %{carparks: carparks}) do
    %{data: render_many(carparks, InformationView, "information.json")}
  end

  def render("show.json", %{information: information}) do
    %{data: render_one(information, InformationView, "information.json")}
  end

  def render("information.json", %{information: information}) do
    %{
      id: information.id,
      car_park_no: information.car_park_no,
      address: information.address,
      x_coord: information.x_coord,
      y_coord: information.y_coord,
      car_park_type: information.car_park_type,
      type_of_parking_system: information.type_of_parking_system,
      short_term_parking: information.short_term_parking,
      free_parking: information.free_parking,
      night_parking: information.night_parking,
      car_park_decks: information.car_park_decks,
      gantry_height: information.gantry_height,
      car_park_basement: information.car_park_basement,
      lat: information.lat,
      lon: information.lon,
      geom: information.geom
      # availbility_id: information.availability.car_park_no
    }
  end
end
