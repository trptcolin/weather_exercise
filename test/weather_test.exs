defmodule WeatherTest do
  use ExUnit.Case
  doctest Weather

  require IEx

  describe "handle_response" do
    test "parses a successful response" do
      ok_headers = []
      {:ok, ok_body} = File.read("test/fixtures/success_body.xml")
      success_response =
        {:ok,
          {{'HTTP/1.1', 200, 'OK'},
            ok_headers,
            to_charlist(ok_body)}}

      assert {:ok,
              [location: 'San Jose, San Jose International Airport, CA',
               observation_time_rfc822: 'Fri, 14 Jul 2017 13:53:00 -0700',
               weather: 'Partly Cloudy',
               temperature_string: '82.0 F (27.8 C)']} ==
             Weather.handle_response(success_response)
    end

    test "fails hard on 404 errors" do
      not_found_headers = []
      {:ok, not_found_body} = File.read("test/fixtures/failure_body.xml")
      not_found_response =
        {:ok,
          {{'HTTP/1.1', 404, 'Not Found'},
            not_found_headers,
            not_found_body}}

      assert_raise FunctionClauseError, fn ->
        Weather.handle_response(not_found_response)
      end
    end
  end
end
