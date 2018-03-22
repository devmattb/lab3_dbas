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


  <crossing car_code="S" crossing_num="">
    <crossing car_code="N" crossing_num="">
      ...
    </crossing>
    <crossing car_code="FN" crossing_num="">
      ...
    </crossing>
  </crossing>
:)
declare function local:reach($current as xs:string, $allCountries as element(country)*)
{
      (: Get all the bordering countries of the current country :)
      let $db := doc("mondial.xml"),
          (: Remove the $current element from our "allCountries" element list:)
          $newAllCountries := $allCountries[@car_code != $current],
          (: Create a list of all the bordering countries, where they still exist in our $newAllCountries :)
          $currentBorderingCountries := $db/mondial[country = $allCountries]/country[@car_code = $current]/border/@country

      (: Make a recursive call for all such countries :)
      for $c in $currentBorderingCountries
      return (
        <crossing name="{$c}">
          {
            local:reach($c, $newAllCountries)
          }
        </crossing>
      )


};
let $db := doc("mondial.xml"),
    $allCountries := $db//country,
    $res := local:reach("S", $allCountries)
return
    $res
