(:
  ASSIGNMENT 1:

  Generate a list of all countries that do not have any islands.
:)

let $db := doc("mondial.xml"),
        $c := $db//country,
        $island:= distinct-values($db//island/@country),
        $res := $c[not(@car_code = $island)]/data(name)
return $res
(: If there's no located_on attribute, then the country does not have any islands. :)
