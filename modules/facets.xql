xquery version "3.1";

declare function local:print-table($facets as map(*)) {
    if (exists($facets)) then
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
    else
        ()
};

<div>
{
    let $facets := session:get-attribute("apps.simple.facets")
    where exists($facets)
    return (
        <div>
            <h3>From</h3>
            { local:print-table($facets?from) }
        </div>,
        <div>
            <h3>To</h3>
            { local:print-table($facets?to) }
        </div>,
        <div>
            <h3>Where</h3>
            { local:print-table($facets?where) }
        </div>
    )
}
</div>