(:

  ASSIGNMENT D:

  USING SONGS.XML:
  Write a query that inverts all the sub elements of the ​/music​ element
  so that their own sub elements becomeattributes and their attributes
  become sub elements. For those sub elements that lack subelements of
  their own, their data content should become an attribute with the name
  “value”.

:)



let $db := doc("songs.xml"),
$newdb :=
    element music {
        for $subelem in $db//music/*
        return
           element {(name($subelem))}
                    { (for $subsub in $subelem/* return attribute {name($subsub)} {$subsub/data()}),
                        (for $attr in $subelem/@* return element {name($attr)}{$attr/data()}) }
    }

return $newdb
