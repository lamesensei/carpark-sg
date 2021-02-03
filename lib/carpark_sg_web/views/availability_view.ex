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
    %{
      # car_park_no: availability.car_park_no,
      address: availability.information.address,
      latitude: availability.information.lat,
      longitude: availability.information.lon,
      available_lots: availability.available_lots,
      total_lots: availability.total_lots
      # distance: availability.distance
      # update_datetime: availability.update_datetime
    }
  end

  def render("paged.json", %{
        entries: entries,
        page_number: page_number,
        page_size: page_size,
        total_pages: total_pages,
        total_entries: total_entries
      }) do
    %{
      data: render_many(entries, AvailabilityView, "availability.json"),
      page_number: page_number,
      page_size: page_size,
      total_pages: total_pages,
      total_entries: total_entries
    }
  end
end
