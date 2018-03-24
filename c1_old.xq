(:

  ASSIGNMENT C1:

  Backgorund:
  Consider land border crossings. Starting in Sweden, you can
  reach Norway and Finland with one border crossing. Russia with
  two. A whole host of countries with 3, and so on. This assumes,
  of course, that you are never allowed to double back over a
  border you’ve crossed already.

  Assignment:
  Generate a list of all the countries that are reachable by land
  border crossing from Sweden under the above conditions, by showing:

  1) The countries that you can reach at each new border crossing
   and
  2) The crossing number for each such group of countries.

:)
declare function local:reach($queue as element(country)*, $visited as element(country)*, $numCrossings as xs:integer*)
{
      (: Get all the bordering countries of the current country :)
      let $db := doc("mondial.xml"),
          (: Our current visiting country :)
          $current := head($queue),

          (:
              Create a list of all the bordering countries that still exist in our $allowedCountries
          :)

          (: All bordering COUNTRY CODES :)
          $borderCountryCodes := $db//country[ @car_code = $current/@car_code ]/border/@country,

           (: All bordering COUNTRIES that are in our $allowedCountries list. :)
          $okBorderCountries := $db/mondial[not(country = $visited)]/country[ @car_code = $borderCountryCodes ],

          $newQueue := (tail($queue),$okBorderCountries)  (: oldQueue + newBorderingCountries :)

          return (
            if ( count($newQueue) = 0 ) then (

            ) else (
                  <crossing name="{$current/@car_code}" numCrossings="{head($numCrossings)}">
                    {
                      local:reach (
                         $newQueue,
                         ($visited, $current),
                         tail($numCrossings)
                      )
                    }
                  </crossing>
             )
          )



};
let $db := doc("mondial.xml"),
    $allCountries := $db//country,
    $sweden := $db//country[@car_code = "S"],
    $res := local:reach(($sweden), (), (0))
return
    $res


    (:


    return (
      if ( empty($queue)) then (

      ) else (

            <crossing name="{$current/@car_code}" numCrossings="{head($numCrossings)}">
              {
                local:reach(
                   $newQueue,
                   $allowedCountries,
                   tail($numCrossings)
                )
              }
            </crossing>
       )
    )


    :)
