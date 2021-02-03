# CarparkSG

## Todo

- Result pagination
- Error handling
  - lat/lon params
  - pagination params
  - error view
- Bulk insert/update for availability data instead of delete_all
- Code Documentation
- This README

## Dev Commands Reference

Context Creation

```
mix phx.gen.json Carparks Information carparks car_park_no:string:unique address:string x_coord:float y_coord:float car_park_type:string type_of_parking_system:string short_term_parking:string free_parking:string night_parking:string car_park_decks:integer gantry_height:float car_park_basement:string lat:float lon:float
```

Create avaibility model

```
mix phx.gen.json Carparks Availability carpark_availability carpark_info:array:map update_datetime:utc_datetime car_park_no:references:carparks:unique
```
