(:

  ASSIGNMENT C1:

  Backgorund:
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

:)

  (: Import Functions :)
  declare namespace functx = "http://www.functx.com";

  (: Used to check if a country's Id exists in our $allowedCountryIds list. :)
  declare function functx:is-value-in-sequence
    ( $value as xs:anyAtomicType? ,
      $seq as xs:anyAtomicType* )  as xs:boolean {

     $value = $seq
   } ;

  (: Used to remove country Ids from our $allowedCountryIds list. :)
  declare function functx:value-except
   ( $arg1 as xs:anyAtomicType* ,
     $arg2 as xs:anyAtomicType* )  as xs:anyAtomicType* {

   distinct-values($arg1[not(.=$arg2)])
  };

  (: Our Local Functions :)

  (: Fetches all allowed (not-visited) bordering country Id's connected to a given country $id :)
  declare function local:getBorderingCountries( $id as xs:string*, $allowedCountryIds as xs:string*) as xs:string* {
    let $db := doc("mondial.xml"),
        $borderingCountryIds := $db//country[@car_code = $id]/border/@country
    (:  Loop through all bordering countries $c, and make sure that they are allowed. :)
    for $c in $borderingCountryIds
    where functx:is-value-in-sequence($c, $allowedCountryIds)
    return $c (: Return all allowed (non-visited) bordering countries :)

  };

  declare function local:getDepth($depth as xs:decimal*, $maxdepth as xs:decimal*, $countries as xs:string*, $allowedCountryIds as xs:string*) as xs:string* {

    if ($depth = $maxdepth) then (
      (: We've reached the deepest depth. Return all country Id's we can reach from this point. :)
      for $c in $countries
      return local:getBorderingCountries($c, $allowedCountryIds)
    ) else (
      (: We haven't reached maximum depth just yet. :)
      (: Get the bordering countries for each country in out $countries list. :)
      for $c in $countries
      let $b := local:getBorderingCountries($c,$allowedCountryIds),
          (: Remove the list of bordering countries $b to this country $c from our $allowedCountries list, before proceeding. :)
          $updatedAllowedCountries := functx:value-except($allowedCountryIds, $b)
          (: Go to deeper. :)
          return local:getDepth( $depth+1, $maxdepth, $b, $updatedAllowedCountries)
    )

  };

  declare function local:reach($depth as xs:decimal*, $currentCountries as xs:string*, $allowedCountryIds as xs:string*) as element()*
  {
    let $reachable := local:getDepth(1,$depth, $currentCountries, $allowedCountryIds),
        (: Remove the list of reachable countries from the allowedCountries list, before proceeding. :)
        $updatedAllowedCountries := functx:value-except($allowedCountryIds, $reachable)

    return (

      if (empty($reachable)) then (
         (: Do nothing. No reachable countries left. :)
      ) else (
        (: There are still some reachable countries to display. Go deeper. :)
        <crossing depth="{$depth}" reaches="{$reachable}">
          {local:reach($depth+1, $reachable, $updatedAllowedCountries)}
        </crossing>
      )

    )

  };

  let $db := doc("mondial.xml"),
      (: Every country is allowed except Sweden when we start. :)
      $allowedCountryIds := $db//country[@car_code != "S"]/@car_code
  (: Start recursive call :)
  return local:reach(1, ("S"), $allowedCountryIds)
