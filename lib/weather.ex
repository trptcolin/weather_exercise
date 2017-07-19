defmodule Weather do
  def init(state \\ %{}) do
    :inets.start()
    {:ok, state}
  end

  def fetch_and_parse(code) do
    fetch_data(code) |> handle_response
  end

  def fetch_data(code) do
    ## gotcha #1: must use :httpc.request/4 because weather.gov now rejects traffic w/o a User-Agent
    #{:ok, {_, _headers, body}} = :httpc.request('http://w1.weather.gov/xml/current_obs/#{code}.xml')
    :httpc.request(:get,
                   {'http://w1.weather.gov/xml/current_obs/#{code}.xml',
                     [{'User-Agent', 'elixir-etudes'}]},
                     [],
                     [])
  end

  def handle_response({:ok, {{_version, 200, _message}, _headers, body}}) do
    ## gotcha #2: list_to_binary is an erlang core fn, need to use either :erlang.list_to_binary/1 or to_string/1
    #body_string = :erlang.list_to_binary(body)

    ## buuut: gotcha #3: regexes to parse XML? pffft, please...
    {doc, _} = :xmerl_scan.string(body)

    observation_time_rfc822 = get_node_data("observation_time_rfc822", doc)
    location = get_node_data("location", doc)
    weather = get_node_data("weather", doc)
    temperature_string = get_node_data("temperature_string", doc)

    {:ok, [location: location,
           observation_time_rfc822: observation_time_rfc822,
           weather: weather,
           temperature_string: temperature_string]}
  end


  defp get_node_data(node_name, doc) do
    :xmerl_xpath.string('//#{node_name}/text()', doc)  |> List.first |> extract_text_from_text_node
  end

  defp extract_text_from_text_node({_, _, _, _, text, :text}), do: text
end
