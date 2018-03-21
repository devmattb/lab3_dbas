(:

  ASSIGNMENT 4:

  Generate a table with the two continents that will
  have the largest and the smallest population increase
  fifty years from now given current population and
  growth rates, and the future population to current
  population ratios for these two continents.

:)

  let $db := doc("mondial.xml"),
  (:

      Calculate each individual country's future population.

      Formula: current_pop * pop_growth^50

      And sum it up for all continents, which are:

      1. Africa
      2. America
      3. Asia
      4. Australia
      5. Europe

  :)

  (: AFRICA :)
  $fPopRatioAfrica :=
    (: Future Population :)
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "africa"]
      return
        data($country/population[@year = "2011"]) *
        math:pow(data($country/population_growth), 50)
    )
    div
    (: Current Population :)
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "africa"]
      return
        data($country/population[@year = "2011"])
    ),

  (: AMERICAS futurepop/currentpop :)
  $fPopRatioAmerica :=
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "america"]
      return
        data($country/population[@year = "2011"]) *
        math:pow(data($country/population_growth), 50)
    )
    div
    (: Current Population :)
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "america"]
      return
        data($country/population[@year = "2011"])
    ),

  (: ASIA :)
  $fPopRatioAsia :=
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "asia"]
      return
        data($country/population[@year = "2011"]) *
        math:pow(data($country/population_growth), 50)
    )
    div
    (: Current Population :)
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "asia"]
      return
        data($country/population[@year = "2011"])
    ),

  (: AUSTRALIA  :)
  $fPopRatioAustralia :=
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "australia"]
      return
        data($country/population[@year = "2011"]) *
        math:pow(data($country/population_growth), 50)
    )
    div
    (: Current Population :)
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "australia"]
      return
        data($country/population[@year = "2011"])
    ),

  (: EUROPE  :)
  $fPopRatioEurope :=
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "europe"]
      return
        data($country/population[@year = "2011"]) *
        math:pow(data($country/population_growth), 50)
    )
    div
    (: Current Population :)
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "europe"]
      return
        data($country/population[@year = "2011"])
    ),

(: Get the max/min values of the calculations above :)
$max :=
max(
  ($fPopRatioAfrica, $fPopRatioAmerica, $fPopRatioAsia,
  $fPopRatioAustralia, $fPopRatioEurope)
),

$min := min(
  ($fPopRatioAfrica, $fPopRatioAmerica, $fPopRatioAsia,
  $fPopRatioAustralia, $fPopRatioEurope)
)

return $max
