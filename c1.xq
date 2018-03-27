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

  declare function local:getDepth($depth as xs:decimal*, $maxDepth as xs:decimal*, $countries as xs:string*, $allowedCountryIds as xs:string*) as xs:string* {

    if ($depth = $maxDepth) then (
      (: We've reached the correct depth. Return the bordering countries to all $countries :)
      for $c in $countries
      return local:getBorderingCountries($c, $allowedCountryIds)
    ) else (
      (: We're not on the correct depth yet! We need to go deeper! :)
      (: Get the bordering countries for each country in out $countries list. :)
      for $c in $countries
      let $b := local:getBorderingCountries($c,$allowedCountryIds),
          (: Remove the list of bordering countries $b to this country $c from our $allowedCountries list, before proceeding. :)
          $updatedAllowedCountries := functx:value-except($allowedCountryIds, $b)
          (: Go to deeper. :)
      return local:getDepth( $depth+1, $maxDepth, $b, $updatedAllowedCountries)
    )

  };

  declare function local:reach($depth as xs:decimal*, $currentCountries as xs:string*, $allowedCountryIds as xs:string*) as element()*
  {
    (: Get all the bordering countries to the $currentCountries, that we haven't visted yet. :)
    let $reachable := distinct-values(local:getDepth(1,1, $currentCountries, $allowedCountryIds)),
        (: Remove the list of reachable countries from the $allowedCountryIds list, before proceeding to next recursive call. :)
        $updatedAllowedCountries := functx:value-except($allowedCountryIds, $reachable)

    return (

      if (empty($reachable)) then (
         (: There were no bordering countries to our $currentCountries list that we hadn't visited already. :)
      ) else (
        (:
            There were some bordering countries to our $currentCountries list that we hadn't visited yet!
            Make note of all the $reachable countries, the current $depth, and go deeper with local:reach().
        :)
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
