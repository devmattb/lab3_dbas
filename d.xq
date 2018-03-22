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

        <music>
        {
                (
                        for $s in $song
                        return
                                <song name="{$s/name}" nr="{$s/nr}">
                                        {

                                        element genre { $s/@genre/string() },
                                        element album { $s/@album/string()},
                                        element artist { $s/@artist/string()},
                                        element id { $s/@id/string()}
                                        }

                                </song>
                ),
                (
                        for $a in $artist
                        return
                                <artist name="{$a/data()}">
                                        {
                                                element id {$a/@id/string()},
                                                element isband {$a/@id/string()}
                                        }
                                </artist>
                ),
                (
                        for $al in $album
                        return
                                <album name="{$al/data()}">
                                        {
                                                element issued {$al/@issued/string()},
                                                element id {$al/@id/string()},
                                                element label {$al/@label/string()},
                                                element performers { if(empty($al/@performers) )then "value" else $al/@performers/string()}
                                        }
                                </album>
                )
        }
        </music>


return $newmusic
