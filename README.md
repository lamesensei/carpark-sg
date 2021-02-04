# CarparkSG 🚗 🏞️ 🇸🇬

CarparkSG is a API for retrieving the nearest HDB carpark information/availability via Latitude/Longitude.

## Usage

`GET` Returns carpark availability information in order based on distance.

```
http://localhost:4000/api/carparks/nearest?latitude=1.2653&longitude=103.8189&per_page=5&page=1
```

**Query Params**

| Name      | Type    | Description                    | Required |
| --------- | ------- | ------------------------------ | -------- |
| latitude  | float   | Latitude degrees eg. 1.2653    | Yes      |
| longitude | float   | Longitude degrees eg. 103.8189 | Yes      |
| per_page  | integer | Results per page               | Yes      |
| page      | integer | Page number                    | Yes      |

**Response (200)**

```json
{
  "data": [
    {
      "address": "BLK 42/43 TELOK BLANGAH RISE",
      "available_lots": 119,
      "latitude": 1.270612626227367,
      "longitude": 103.82353547243773,
      "total_lots": 262
    },
    {
      "address": "BLK 30/31 TELOK BLANGAH RISE",
      "available_lots": 124,
      "latitude": 1.2726440475687413,
      "longitude": 103.8207548525513,
      "total_lots": 179
    },
    {
      "address": "BLK 38/40 TELOK BLANGAH RISE",
      "available_lots": 109,
      "latitude": 1.2724063895047217,
      "longitude": 103.82320738795562,
      "total_lots": 203
    },
    {
      "address": "BLK 29/32 TELOK BLANGAH RISE",
      "available_lots": 25,
      "latitude": 1.2734514848822975,
      "longitude": 103.82139918679454,
      "total_lots": 44
    },
    {
      "address": "BLK 32/35 TELOK BLANGAH RISE",
      "available_lots": 42,
      "latitude": 1.2732889977607433,
      "longitude": 103.82223343925568,
      "total_lots": 129
    }
  ],
  "page_number": 1,
  "page_size": 5,
  "total_entries": 1628,
  "total_pages": 326
}
```

## Requirements

**System**

- [Elixir 1.9.4 / 1.11 (Docker Image)](https://elixir-lang.org/install.html)
- [Phoenix Framework 1.5.7](https://hexdocs.pm/phoenix/installation.html#elixir-1-6-or-later)
- [Postgres 12.5 with PostGIS](https://postgis.net/install/)
- [Docker 3.1.0](https://www.docker.com/products/docker-desktop)

**Docker Container**

- [bitwalker/alpine-elixir-phoenix](https://hub.docker.com/r/bitwalker/alpine-elixir-phoenix)
- [postgis/postgis:12-master](https://hub.docker.com/r/postgis/postgis)

## Installation

Via Docker (recommended)

```
docker-compose up --build
```

Locally - You will need a local instance Postgres 12.5 with PostGIS installed with `port 5432 / default postgres user` configured.

```
mix ecto.reset
mix phx.server
```

## Seeding Commands

Running the app via docker-compose will run the initial seeding tasks for Carpark Information and Carpark Availability.

### Reset Database

```
mix ecto.reset
```

### Seed Carpark Information

```
mix run priv/repo/seeds.exs
```

### Seed/Update Carpark Availability

```
mix update.avail
```

## TODO

- Code docmentation
- Seeding error handling

## Remarks

See [DEVELOPMENT.MD](development.md)

## License

Apache 2.0
