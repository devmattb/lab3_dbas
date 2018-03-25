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
$album := $db//album,
$song := $db//song,
$artist := $db//artist,
$newmusic :=
            for $e in $db/music/element(*)
            return (
              for $attrib in $e/@*
              return (
                name($attrib), $attrib/string(), '&#xA;'
              )
            )



return $newmusic


(:

Turn all the sub-elements to attributes

{

  for $subElem in $e/*
  return concat(concat(node-name($e/*),"="), data($e/*))
}

:)
