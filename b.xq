(:

  ASSIGNMENT B:

  Which countries are members of ​all​ the organizations
  whose names start with the word “International” and
  are headquartered in Europe?

  Steg 1: Ta fram all organixationer som heter international och har huvudkontor
  i europa.
  Steg 2: Ta fram organizationen och räkna upp alla memberländer
:)

let $db := doc("mondial.xml"),
$international := $db//organization[matches(name/string(), 'International')],
$eucont := $db//country[encompassed/@continent = 'europe'],
$ineurope :=
for $comp in $international
return $comp[$comp/@headq/data() = $eucont//city/@id/data()],
$countries := $db//country,
$orgwithmembers :=
for $c in $countries
return
        if
        (count(
        for $org in $ineurope
        return $org[contains(members[1]/@country/string(), $c/@car_code/string())]) = count($ineurope))
        then $c
        else
        ()
return $orgwithmembers/name/string()
