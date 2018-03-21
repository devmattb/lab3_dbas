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

      And sum it up for all continents.
  :)


  $continents := data($db//continent/@id),
  $res :=
    for $cont in $continents
    return
      <continent name="{$cont}">
          {
            (: Future Population :)
            (fn:sum (
              for $country in $db//country[data(encompassed/@continent) = $cont ]
              return
                data($country/population[@year = "2011"]) *
                math:pow(data((1+($country/population_growth) div 100)), 50)
            )
            div
            (: Current Population :)
            fn:sum (
              for $country in $db//country[data(encompassed/@continent) = $cont ]
              return
                data($country/population[@year = "2011"])
            ))
        }
      </continent>
return $res[data() = max(data($res)) or data() = min(data($res)) ]
