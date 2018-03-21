(:
  ASSIGNMENT 8:

  Generate a table with the three (3) cities above 5,000,000
  inhabitants that form the largest triangle between them,
  measured as the total length of all three triangle legs,
  and that total length.

:)

(:

  SPHERICAL LAW OF COSINES:

  6371*math:acos(math:sin($city1/latitude*math:pi() div 180)*math:sin($city2/latitude*math:pi() div 180)+math:cos($city1/latitude*math:pi() div 180)*math:cos($city2/latitude*math:pi() div 180)*math:cos(($city2/longitude*math:pi() div 180)-($city1/longitude*math:pi() div 180)))
  +
  6371*math:acos(math:sin($city1/latitude*math:pi() div 180)*math:sin($lat3*math:pi() div 180)+math:cos($city1/latitude*math:pi() div 180)*math:cos($lat3*math:pi() div 180)*math:cos(($long3*math:pi() div 180)-($city1/longitude*math:pi() div 180)))
  +
  6371*math:acos(math:sin($lat3*math:pi() div 180)*math:sin($city2/latitude*math:pi() div 180)+math:cos($lat3*math:pi() div 180)*math:cos($city2/latitude*math:pi() div 180)*math:cos(($city2/longitude*math:pi() div 180)-($long3*math:pi() div 180)))

:)

let $db := doc("mondial.xml"),
    (: GRAB ALL CITIES THAT MATCH OUR SPECIFICATIONS :)
    $cities := $db//city[data(population[@year = "2011"]) >= 5000000 ],

    (: GENERATE ALL COMBINATIONS OF LENGTHS BETWEEN THE CHOSEN CITIES :)
    $triLegs :=
      for $city1 in $cities
      return (
        for $city2 in $cities
        where data($city1/name) < data($city2/name)
        return
          <triLeg city1="{$city1/name}" city2="{$city2/name}">
            {6371*2.0*2*
              math:asin(math:sqrt((math:pow(math:sin((3.14 div 180)*
              (($city1/latitude/data()-$city2/latitude/data()) div 2.0)),2))+
              (math:cos((3.14 div 180)*($city1/latitude/data()))*
              math:cos((3.14 div 180)*($city2/latitude/data()))*
              math:pow(math:sin((3.14 div 180)
              *(($city1/longitude/data()-$city2/longitude/data()) div 2.0)),2))))}
          </triLeg>
      ),

    (: GENERATE ALL COMBINATIONS OF TRIANGLES WITH OUR TRIANGLE LEGS :)
    $triangles :=
      for $l1 in $triLegs
      return (
        for $l2 in $triLegs
        return (
          for $l3 in $triLegs
          (: Remove duplicates and:)
          where $l1/@city1 < $l1/@city2 and $l1/@city1 < $l2/@city2 and $l1/@city2 < $l2/@city2
          and $l1/@city1 = $l2/@city1 and $l2/@city2 = $l3/@city1
          return
            <triangle city1="{$l1/@city1}" city2="{$l1/@city2}" city3="{$l3/@city1}">
                {
                  data($l1) + data($l2) + data($l3)
                }
            </triangle>
        )

      )

return $triangles[data() = max(data($triangles))]
