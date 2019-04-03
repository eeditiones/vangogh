xquery version "3.1";

module namespace idx="http://www.existsolutions.com/vangogh/index";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace vg="http://www.vangoghletters.org/ns/";

declare function idx:get-metadata($root as element(), $field as xs:string) {
    switch ($field)
        case "title" return
            let $header := $root/tei:teiHeader
            return
                head((
                    $header//tei:msDesc/tei:head, $header//tei:titleStmt/tei:title[@type = 'main'],
                    $header//tei:titleStmt/tei:title
                ))
        case "from" return
            $root//tei:sourceDesc/vg:letDesc/vg:letHeading/tei:author
        case "to" return
            $root//tei:sourceDesc/vg:letDesc/vg:letHeading/vg:addressee
        case "place" return
            $root//tei:sourceDesc/vg:letDesc/vg:letHeading/vg:placeLet
        case "language" return
            ($root/@xml:lang/string(), $root/tei:teiHeader/@xml:lang/string(), "en")[1]
        case "date" return (
            $root/tei:teiHeader/tei:fileDesc/tei:editionStmt/tei:edition/tei:date,
            $root/tei:teiHeader/tei:publicationStmt/tei:date
        )[1]
        default return
            ()
};