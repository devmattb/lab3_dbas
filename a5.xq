(:
  ASSIGNMENT 5:

  Generate the name of the organisation that is headquartered
  in Europe, has International inits name and has the largest
  number of European member countries.

:)

let $db := doc("mondial.xml"),
$international := $db//organization[matches(name/string(), 'International')],
$cities := $db//city,
$ineurope :=
for $comp in $international
return
        if($cities[@id = $comp/@headq and $db//country[@car_code = @country and encompassed/@continent = 'europe']])
        then $comp
        else
        ()
return $ineurope

(: :)
