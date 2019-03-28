xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace config="http://www.tei-c.org/tei-simple/config" at "config.xqm";

declare function local:print-table($dimension as xs:string, $facets as map(*)?) {
    if (exists($facets)) then
        <table>
        {
            let $params := request:get-parameter("facet-" || $dimension, ())
            return
                map:for-each($facets, function($label, $count) {
                    <tr>
                        <td>
                            <paper-checkbox class="facet" name="facet-{$dimension}" value="{$label}">
                                { if ($label = $params) then attribute checked { "checked" } else () }
                                {
                                    switch ($dimension)
                                        case "mentions" return
                                            id("P" || $label, doc($config:data-root || "/people.xml"))/tei:persName
                                        default return
                                            $label
                                }
                            </paper-checkbox>
                        </td>
                        <td>{$count}</td>
                    </tr>
                })
        }
        </table>
    else
        ()
};

<div>
{
    let $hits := session:get-attribute("apps.simple")
    where count($hits) > 0
    return (
        <div>
            <h3>Where</h3>
            { local:print-table("where", ft:facets($hits[1], "where", 20)) }
        </div>,
        <div>
            <h3>From</h3>
            { local:print-table("from", ft:facets($hits[1], "from", 20)) }
        </div>,
        <div>
            <h3>To</h3>
            { local:print-table("to", ft:facets($hits[1], "to", 20)) }
        </div>,
        <div>
            <h3>Mentioned</h3>
            { local:print-table("mentions", ft:facets($hits[1], "mentions", 20)) }
        </div>

    )
}
</div>
