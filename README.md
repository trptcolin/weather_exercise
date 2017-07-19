# WeatherExercise

A starting point for learning about OTP in Elixir.

Exercise details found in [Chapter 12 of Études for Elixir](http://chimera.labs.oreilly.com/books/1234000001642/ch12.html)


## Usage

In an `iex -S mix` session, verify that the HTTP requesting / parsing is working as expected:

```elixir
iex(1)> Weather.init
{:ok, %{}}
iex(2)> Weather.fetch_and_parse("KAHN")
{:ok,
 [location: 'Athens, Athens Airport, GA',
  observation_time_rfc822: 'Wed, 19 Jul 2017 14:51:00 -0400',
  weather: 'Partly Cloudy', temperature_string: '93.0 F (33.9 C)']}
```

## Directions

1. Read and understand the intended API (using `GenServer`) for Étude 12-1 (see link above), and complete the rest, including setting up a supervisor to restart the server upon crashes.
2. Provide the wrapper API requested by Étude 12-2.
3. Pull the server and client apart, as directed by Étude 12-3.


