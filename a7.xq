(:

  ASSIGNMENT 7:

  Generate a table of countries and the ratio between
  their latest reported and earliest reported population
  figures, rounded to one decimal point, for those
  countries where this ratiois above 10, that is to say
  those that have grown at least 10-fold between earliest
  and latest population count.

:)

let $db := doc("mondial.xml"),
$country := $db//country,
$earlypops :=
for $c in $country
return
        <country name="{$c/name/string()}">
                {$c/population[@year = min($c/population/@year)]/data()}
        </country>,
$latepops :=
for $c in $country
return
        <country lname="{$c/@name/string()}">
                {$c/population[@year = max($c/population/@year)]/data()}
        </country>,
$popratio :=
for $curr in $earlypops
return
        <country name="{$curr/@name/string()}">
                {(
                        $latepops[@lname/string() = $curr/@name/string()]/data() div $curr/data()
                )}
        </country>
return $popratio[data() >= 10]
