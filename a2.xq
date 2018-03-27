(:
  ASSIGNMENT 2:
  
  Generate the ratio between inland provinces
  (provinces not bordering any sea),
  to total number of provinces.
:)

let $db := doc("mondial.xml"),
$numInland := number(count($db//province[count(city/located_at[@watertype="sea"])=0])),
$numTotal := number(count($db//province))
return $numInland div $numTotal 

