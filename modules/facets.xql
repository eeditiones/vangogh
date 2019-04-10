xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace config="http://www.tei-c.org/tei-simple/config" at "config.xqm";

declare function local:sort($facets as map(*)?) {
    array {
        if (exists($facets)) then
            for $key in map:keys($facets)
            let $value := map:get($facets, $key)
            order by $key ascending
            return
                map { $key: $value }
        else
            ()
    }
};


declare function local:print-table($dimension as xs:string, $facets as array(*)) {
    <table>
    {
        let $params := request:get-parameter("facet-" || $dimension, ())
        return
            array:for-each($facets, function($entry) {
                map:for-each($entry, function($label, $count) {
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
            })
    }
    </table>
};

declare function local:display($title as xs:string, $node as element(), $dimension as xs:string, $all as xs:string?) {
    let $facets :=
        if ($all) then
            ft:facets($node, $dimension)
        else
            ft:facets($node, $dimension, 10)
    return
        <div>
            <h3>{$title}
                <paper-checkbox class="facet" name="all-{$dimension}">
                    { if ($all) then attribute checked { "checked" } else () }
                    Show all
                </paper-checkbox>
            </h3>
            {local:print-table($dimension, local:sort($facets))}
        </div>
};


<div>
{
    let $placeShowAll := request:get-parameter("all-place", ())
    let $fromShowAll := request:get-parameter("all-from", ())
    let $toShowAll := request:get-parameter("all-to", ())
    let $mentionsShowAll := request:get-parameter("all-mentions", ())
    let $hits := session:get-attribute("apps.simple")
    where count($hits) > 0
    return (
        local:display("Place", $hits[1], "place", $placeShowAll),
        local:display("From", $hits[1], "from", $fromShowAll),
        local:display("To", $hits[1], "to", $toShowAll),
        local:display("Date", $hits[1], "date", ()),
        local:display("Mentions", $hits[1], "mentions", $mentionsShowAll)
    )
}
</div>
