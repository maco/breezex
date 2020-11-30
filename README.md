# Breezex

Client wrapping the [API](https://app.breezechms.com/api) for the [Breeze church management system](https://breezechms.com)

## Installation

The package can be installed by adding `breezex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:breezex, "~> 0.1.0"}
  ]
end
```

Docs can be found at [https://hexdocs.pm/breezex](https://hexdocs.pm/breezex).

There are some helper functions in here for common sets of arguments to the Breeze API. Things are also a little rearranged versus Breeze's own documentation. For instance, all event check-in functionality is in the CheckIn module.
