(:
  ASIGNMENT 3:

  Generate a table of all the continents and
  the sum of the areas of all those lakes that
  contains least one island for each continent.
  If a lake is in a country that is situated on several continents,
  the appropriate share of the lake area should be counted
  for each of those continents.

:)

let $db := doc("mondial.xml"),
        $islandlakes := $db//island[@lake]/@lake,
        $lakes := $db//lake[@id = $islandlakes],
        $continents := $db//continent/@id,
        $res :=
        for $cont in $continents
        return
        <continent name="{$cont}">
                {

                        fn:sum (for $lake in $lakes
                        return ($db//country[$lake/located[1]/@country/data() = @car_code/data() and encompassed/@continent = $cont]/encompassed[@continent = $cont]/@percentage/number() div 100) * $lake/area/number()
                        )
                }
        </continent>
return $res
