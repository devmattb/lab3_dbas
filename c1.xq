(:

  ASSIGNMENT C1:

  Background:
  Consider land border crossings. Starting in Sweden, you can
  reach Norway and Finland with one border crossing. Russia with
  two. A whole host of countries with 3, and so on. This assumes,
  of course, that you are never allowed to double back over a
  border you’ve crossed already.

  Assignment:
  Generate a list of all the countries that are reachable by land
  border crossing from Sweden under the above conditions, by showing:

  1) The countries that you can reach at each new border crossing
   and
  2) The crossing number for each such group of countries.

  GAMMAL: De ville ha svaret i form av XML taggar!
:)
declare namespace functx = "http://www.functx.com";
(: Function that checks if a value exists in a sequence :)
declare function functx:is-value-in-sequence
  ( $value as xs:anyAtomicType? ,
    $seq as xs:anyAtomicType* )  as xs:boolean {

   $value = $seq
 };

declare function local:reach($current as xs:string, $visited as xs:string*)
{
  (: If we haven't visited this country yet :)
  return (
    if ( functx:is-value-in-sequence($current,$visited) ) then (

    (: Get all the bordering countries of the current country :)
    let $db := doc("mondial.xml")
    let $borderingCountries := $db//country[@car_code = $current]/border/@country

    (: Make a recursive call for all such countries :)
    for $c in $borderingCountries
    let $borderBorderingCountries := $db//country[@car_code = $c]/border/@country
    return (
      for $cc in $borderBorderingCountries
      (: Call reach for this country's bordering countries ($cc), and Append this country ($c) to our visited sequence ("flat-list") :)
      return local:reach($cc, insert-before($visited, count($visited), $c))
    )

    )
    (: We have visited this country already. :)
    else (
      return (: $visited <-- Exit function and return latest values. :)
    )
  )
};

let $res := local:reach("S", "")
return $res
