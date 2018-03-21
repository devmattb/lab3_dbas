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

let $db := doc("mondial.xml"),
    $borderingSweden := $db//country[@car_code = "S"]/border/@country

(: Declare a function with two paramaters. Queue ($q) and Result ($res) :)
declare function myFncs:reachable (
  $q as element(country)*,
  $res as element(country)*
) as element(country)
{
  (: The statements of the recursive function :)
  if (empty($q)) then (
    (: A country is not reachable from itself :)
    tail($res)
  ) else (
    let
      $current := head($q),
      $tail := tail($q),
      $others := $current/border/
      return
        myFncs:reachable(
          ($tail, $borderingSweden/),
          ()
        )

  )

};

for $carCodes in $borderingSweden
return myFncs:reachable($carCodes,())
