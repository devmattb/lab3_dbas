(:

  ASSIGNMENT 9:

  Generate a table that contains the rivers Rhein, Nile and Amazonas,
  and the longest total length that the river systems feeding into each
  of them contain (including their own respective length).

  You must calculate the respective river systems of tributary rivers recursively.

:)

declare function local:tributary($curr as element(river), $base as xs:string, $length as xs:double) as element()*
{
        let $db := doc("mondial.xml")
        let $tributary := $db//river[to[@watertype="river"] and contains(to/@water, $curr/@id)]

        return(
        if(empty($tributary)) then
                 (
                 <river name="{$base}"> {$length} </river>
                 )
        else (
                for $first in $tributary
                let $newlength := $first/length/data()
                return
                        local:tributary($first, $base, ($length + $newlength) )
                )
        )

};



let $db := doc("mondial.xml")
let $nile := local:tributary($db//river[name/string() = 'Nile'], 'Nile', $db//river[name/string() = 'Nile']/length/data())
let $amazonas := local:tributary($db//river[name/string() = 'Amazonas'], 'Amazonas', $db//river[name/string() = 'Nile']/length/data())
let $rhein := local:tributary($db//river[name/string() = 'Rhein'], 'Rhein', $db//river[name/string() = 'Nile']/length/data())

return ($nile[data() = max($nile/data())], $rhein[data() = max($rhein/data())], $amazonas[data() = max($amazonas/data())])
