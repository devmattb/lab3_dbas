(:
  ASSIGNMENT 1:
  Generate a list of all countries that do not have any islands.
:)

let $db := doc("mondial.xml")
(: If there's no located_on attribute, then the country does not have any islands. :)
return $db//country[ not(/located_on) ]/name
