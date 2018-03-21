(:
  ASSIGNMENT 6:

  Generate a table of city names and related airport names
  for all the cities that have at least 100,000 inhabitants,
  are situated in America and where the airport is elevated
  above 500 m.

:)

let $db := doc("mondial.xml"),

    (:
      Grab all city ids where:
      1) The country's encompassed continent = "america"
      2) The city's @country = country's @car_code
      3) The city's population >= 100 000
    :)
    $citiesInAmerica :=
      data($db//city[data(population[@year = "2011"]) >= 100000 and @country = $db//country[ data(encompassed/@continent) = "america"]/@car_code]/@id),
    (:
      Grab all airports where:
      1) The city code is in $citiesInAmerica
      2) The elevation > 500
    :)
    $airports := $db//airport[@city=$citiesInAmerica and data(elevation) >500 ]

return $airports


(:

  If we want to format it ourselves...

  <city name="{$city}">
    <population>{$population}</population>
    <airport name="{$airport}">
      <elevation>{$elevation}</elevation>
    </airport>
  </city>

:)
