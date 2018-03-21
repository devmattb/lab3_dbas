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
    <continent name="Africa"> {
    (: Future Population :)
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "africa" or data(encompassed/@continent) = "Africa" ]
      return
        data($country/population[@year = "2011"]) *
        math:pow(data((1+($country/population_growth) div 100)), 50)
    )
    div
    (: Current Population :)
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "africa" or data(encompassed/@continent) = "Africa"]
      return
        data($country/population[@year = "2011"])
    )
    }
  </continent>,

  (: AMERICAS futurepop/currentpop :)
  $fPopRatioAmerica :=
  <continent name="Africa"> {
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "america" or data(encompassed/@continent) = "America"]
      return
        data($country/population[@year = "2011"]) *
        math:pow((1+(data($country/population_growth) div 100)), 50)
    )
    div
    (: Current Population :)
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "america" or data(encompassed/@continent) = "America"]
      return
        data($country/population[@year = "2011"])
    )
  }
</continent>,

  (: ASIA :)
  $fPopRatioAsia :=
  <continent name="Africa"> {
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "asia" or data(encompassed/@continent) = "Asia"]
      return
        data($country/population[@year = "2011"]) *
        math:pow((1+(data($country/population_growth) div 100)), 50)
    )
    div
    (: Current Population :)
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "asia" or data(encompassed/@continent) = "Asia"]
      return
        data($country/population[@year = "2011"])
    )
  }
</continent>,

  (: AUSTRALIA  :)
  $fPopRatioAustralia :=
  <continent name="Africa"> {
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "australia" or data(encompassed/@continent) = "Australia"]
      return
        data($country/population[@year = "2011"]) *
        math:pow((1+(data($country/population_growth) div 100)), 50)
    )
    div
    (: Current Population :)
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "australia" or data(encompassed/@continent) = "Australia"]
      return
        data($country/population[@year = "2011"])
    )
  }
</continent>,

  (: EUROPE  :)
  $fPopRatioEurope :=
  <continent name="Africa"> {
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "europe" or data(encompassed/@continent) = "Europe"]
      return
        data($country/population[@year = "2011"]) *
        math:pow((1+(data($country/population_growth) div 100)), 50)
    )
    div
    (: Current Population :)
    fn:sum (
      for $country in $db//country[data(encompassed/@continent) = "europe" or data(encompassed/@continent) = "Europe"]
      return
        data($country/population[@year = "2011"])
    )
  }
</continent>,

(: Get the max/min values of the calculations above :)
$max :=
max(
  (data($fPopRatioAfrica), data($fPopRatioAmerica), data($fPopRatioAsia),
  data($fPopRatioAustralia), data($fPopRatioEurope))
),

$min := min(
  (data($fPopRatioAfrica), data($fPopRatioAmerica), data($fPopRatioAsia),
  data($fPopRatioAustralia), data($fPopRatioEurope))
)

return ($max, $min)
