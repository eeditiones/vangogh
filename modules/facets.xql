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


declare function local:print-table($node as element(), $dimension as xs:string, $values as xs:string*, $params as xs:string*,
    $all as xs:string?) {
    <table>
    {
        let $count := if ($all) then () else 10
        let $facets :=
            if (exists($values)) then
                ft:facets($node, $dimension, $count, $values)
            else
                ft:facets($node, $dimension, $count)
        return
            array:for-each(local:sort($facets), function($entry) {
                map:for-each($entry, function($label, $count) {
                    <tr>
                        <td>
                            <paper-checkbox class="facet" name="facet-{$dimension}" value="{$label}">
                                { if ($label = $params[1]) then attribute checked { "checked" } else () }
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
            }),
        if (empty($params)) then
            ()
        else
            <tr>
                <td colspan="2">
                {local:print-table($node, $dimension, ($values, head($params)), tail($params), $all)}
                </td>
            </tr>
    }
    </table>
};

declare function local:display($title as xs:string, $node as element(), $dimension as xs:string, $all as xs:string?) {
    <div>
        <h3>{$title}
            <paper-checkbox class="facet" name="all-{$dimension}">
                { if ($all) then attribute checked { "checked" } else () }
                Show all
            </paper-checkbox>
        </h3>
        {
            let $params := request:get-parameter("facet-" || $dimension, ())
            return
                local:print-table($node, $dimension, (), $params, $all)
        }
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
