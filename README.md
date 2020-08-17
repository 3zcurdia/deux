# Deux

Status monitor for external services:
  - Redis: track specific keys values
  - Ping: track status or body responses

## Installation

The package can be installed by adding `deux` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:deux, "~> 0.1.0"}
  ]
end
```
## Setup

Deux uses `exredis` to monitor redis services, you will need to configure it with

```
config :exredis,
  reconnect: :no_reconnect,
  max_queue: :infinity
```

if your application already have `exredis` you don't need to change your configuration

## Usage

### Add Redis

To monitor redis you need to add with

```
  redis_source = Deux.Redis.add(name: "localhost", url: "redis://127.0.0.1:6379", filters: [%{filter: "flag:*"}])
```

### Add Ping

To monitor ping you need to add with

```
  ping_source = Deux.Ping.add(name: "localhost", request: [method: :get, url: "http://127.0.0.1:3000"], mode: :body)
```

### Load sources

To load all sources reports

```
  {:ok, sources} = Deux.list_sources()
```

You also can fetch an specific source with a given id

```
  {:ok, source} = Deux.get_source("213243546576")
```

## Load on boot with config

You can also set your monitors to through the config

```
config :deux,
  redis: [
    %{
      name: "localhost flags",
      url: "redis://127.0.0.1:6379",
      filters: [%{filter: "flag:*"}]
    },
    %{
      name: "Another source",
      url: "redis://services.example.com:6379",
      filters: [%{regex: ~r/category_.*/}]
    }
  ],
  ping: [
    %{
      name: "Example pingdown",
      request: [
        method: :get,
        url: "https://example.com/",
      ],
      mode: :status
    },
    %{
      name: "Config endpoint",
      request: [
        method: :get,
        url: "https://example.com/api/v2/config",
      ],
      mode: :body
    }
  ]
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/deux](https://hexdocs.pm/deux).
