(:

  ASSIGNMENT C2:

  Background:
  Consider land border crossings. Starting in Sweden, you can
  reach Norway and Finland with one border crossing. Russia with
  two. A whole host of countries with 3, and so on. This assumes,
  of course, that you are never allowed to double back over a
  border you’ve crossed already.

  Assignment:
  Generate a list of countries that have the highest
  number of possible bordercrossings to some other country, and
  show which countries those most distant countries are for each
  such starting country.

  "most distant" := at the longest reach of crossing depth.

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
  declare function local:getBorderingCountries($countries as xs:string*, $allowedCountryIds as xs:string*) as xs:string* {
    let $db := doc("mondial.xml")

    for $c in $countries
    return (
      let $borderingCountryIds := $db//country[@car_code = $c]/border/@country
      (:  Loop through all bordering countries $c, and make sure that they are allowed. :)
      for $cc in $borderingCountryIds
      where functx:is-value-in-sequence($cc, $allowedCountryIds)
      return $cc (: Return all allowed (non-visited) bordering countries :)
    )

  };

  (: BFS Search :)
  declare function local:reach($depth as xs:decimal*, $currentCountries as xs:string*, $allowedCountryIds as xs:string*) as element()*
  {
    (: Get all the bordering countries to the $currentCountries, that we haven't visted yet. :)
    let $reachable := distinct-values(local:getBorderingCountries($currentCountries, $allowedCountryIds)),
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
          <posCrossings num="{count($reachable)}"></posCrossings>
          {local:reach($depth+1, $reachable, $updatedAllowedCountries)}
        </crossing>
      )

    )

  };

  let $db := doc("mondial.xml"),
      $countryCrossings :=
        (:
           For each country, do the same calculation as in the previous assignment,
           since we want the most distant border countries to a country.
        :)
        for $c in $db//country
        let $carCode := $c/@car_code,
            $allowedCountryIds := $db//country[ @car_code != $carCode ]/@car_code
        return (
          <country name="{$carCode}">
            {local:reach(1, $carCode, $allowedCountryIds)}
          </country>
        )

  (:  For each of the countries with the max number of crossings... :)
  for $c in $countryCrossings
  (: Return only those crossings within max-crossing-countries that have the max crossing depth. :)
  return (
    if ($c//crossing/@depth/data() = max($countryCrossings//crossing/@depth)) then (
    <country name="{$c/@name/data()}">
      {$c//crossing[@depth/data() = max($countryCrossings//crossing/@depth)]}
    </country>
    ) else (


    )
  )
