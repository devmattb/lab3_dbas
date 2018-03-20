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

$allFuturePopSums := (

  (: AFRICA :)
  fn:sum (
    for $country in $db//country[data(encompassed/@continent) = "africa"]
    return
      data($country/population[@year = "2011"]) *
      math:pow(data($country/population_growth), 50)
  ),

  (: AMERICA :)
  fn:sum (
    for $country in $db//country[data(encompassed/@continent) = "america"]
    return
      data($country/population[@year = "2011"]) *
      math:pow(data($country/population_growth), 50)
  ),

  (: ASIA :)
  fn:sum (
    for $country in $db//country[data(encompassed/@continent) = "asia"]
    return
      data($country/population[@year = "2011"]) *
      math:pow(data($country/population_growth), 50)
  ),

  (: AUSTRALIA  :)
  fn:sum (
    for $country in $db//country[data(encompassed/@continent) = "australia"]
    return
      data($country/population[@year = "2011"]) *
      math:pow(data($country/population_growth), 50)
  ),

  (: EUROPE  :)
  fn:sum (
    for $country in $db//country[data(encompassed/@continent) = "europe"]
    return
      data($country/population[@year = "2011"]) *
      math:pow(data($country/population_growth), 50)
  )
),
(: Get the max/min values of the calculations above :)
$maxRes := max($allFuturePopSums),
$minRes := min($allFuturePopSums)

return $allFuturePopSums
