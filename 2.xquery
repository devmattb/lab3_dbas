(:
  ASSIGNMENT 2:
  Generate the ratio between inland provinces
  (provinces not bordering any sea),
  to total number of provinces.
:)

let $test := distinct-values(
    let $db := doc("mondial.xml"),
    $numInland := number(count($db//province[ not(//located_at) ])),
    $numTotal := number(count($db//province))
    return number(count($db//province/city[located_at]/..)) 
)
return $test


  (:    number(count($db//province/city[not(located_at)]/..))    :)
