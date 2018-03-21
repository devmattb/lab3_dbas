(:
  ASSIGNMENT 1:

  Generate a list of all countries that do not have any islands.
:)

let $db := doc("mondial.xml"),
        $c := $db/mondial/country,
        $island:= distinct-values($db/mondial/island/@country),
        $res := $c[not(exists(@car_code = $island ))]
return $res
(: If there's no located_on attribute, then the country does not have any islands. :)
