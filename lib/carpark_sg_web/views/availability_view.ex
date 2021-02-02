defmodule CarparkSgWeb.AvailabilityView do
  use CarparkSgWeb, :view
  alias CarparkSgWeb.AvailabilityView

  def render("index.json", %{carpark_availability: carpark_availability}) do
    %{data: render_many(carpark_availability, AvailabilityView, "availability.json")}
  end

  def render("show.json", %{availability: availability}) do
    %{data: render_one(availability, AvailabilityView, "availability.json")}
  end

  def render("availability.json", %{availability: availability}) do
    %{id: availability.id,
      carpark_info: availability.carpark_info,
      update_datetime: availability.update_datetime}
  end
end
