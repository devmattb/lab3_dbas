(:
  ASSIGNMENT 1:
  Generate a list of all countries that do not have any islands.
:)

let $db := doc("mondial.xml")
return $db//country[ //geolake/country ne /name ]/name
