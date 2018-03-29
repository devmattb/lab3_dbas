(:
  ASSIGNMENT 5:

  Generate the name of the organisation that is headquartered
  in Europe, has International in its name and has the largest
  number of European member countries.

:)

let $db := doc("mondial.xml"),
$international := $db//organization[matches(name/string(), 'International')],
$eucont := $db//country[encompassed/@continent = 'europe'],
$ineurope :=
for $comp in $international
return $comp[$comp/@headq/data() = $eucont//city/@id/data()],
$res :=
for $org in $ineurope
return
<organization name="{$org/name/string()}">
        {count(
                for $c in $eucont
                return $org[contains(members[1]/@country/string(), $c/@car_code/string())]
        ) }
</organization>

return $res[data() = max($res/data())]
