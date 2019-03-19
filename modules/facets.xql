xquery version "3.1";

let $facets := session:get-attribute("apps.simple.facets")
where exists($facets)
return
    <table>
    {
        map:for-each($facets, function($label, $count) {
            <tr>
                <td>{$label}</td>
                <td>{$count}</td>
            </tr>
        })
    }
    </table>