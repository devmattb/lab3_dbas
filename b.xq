(:

  ASSIGNMENT B:

  Which countries are members of ​all​ the organizations
  whose names start with the word “International” and
  are headquartered in Europe?

  Steg 1: Ta fram all organixationer som heter international och har huvudkontor
  i europa.
  Steg 2: Ta fram organizationen och räkna upp alla memberländer
:)
(: Import Functions :)
declare namespace functx = "http://www.functx.com";

(: Used to check if a country's Id exists in our $allowedCountryIds list. :)
declare function functx:is-value-in-sequence
  ( $value as xs:anyAtomicType? ,
    $seq as xs:anyAtomicType* )  as xs:boolean {

   $value = $seq
 } ;

let $db := doc("mondial.xml"),
$international := $db//organization[matches(name/string(), 'International')],
$eucont := $db//country[encompassed/@continent = 'europe'],
$ineurope :=
(:find all the international companies with their headquarter in europe:)
for $comp in $international
return $comp[$comp/@headq/data() = $eucont//city/@id/data()],
$countries := $db//country,
$orgwithmembers :=
(:loop over all countries in the world and then check how many of the 17 organizations they are a member of
We count the organizations they are a member of in the inner loop and then check if that number is equal to
the number of 'international' organizations in europe:)
for $c in $countries
return
        if
        (count(
        for $org in $ineurope
        return $org[functx:is-value-in-sequence($c/@car_code/string(),members/@country/string())]) = count($ineurope))
        then $c
        else
        ()
return $orgwithmembers/name/string()
