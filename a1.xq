(:
  ASSIGNMENT 1:

  Generate a list of all countries that do not have any islands.
:)

let $db := doc("mondial.xml"),
        $country := $db/mondial/country,
        $island:= string-join(distinct-values($db/mondial/island/@country/string()), " "),
        $res :=
        for $c in $country
        return
                if((contains($island, $c/@car_code)))
                then ()
                else
                $c

return $res/name
(: If there's no located_on attribute, then the country does not have any islands. :)
