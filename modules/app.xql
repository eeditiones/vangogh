xquery version "3.1";

(:
 : Module for app-specific template functions
 :
 : Add your own templating functions here, e.g. if you want to extend the template used for showing
 : the browsing view.
 :)
module namespace app="teipublisher.com/app";

import module namespace templates="http://exist-db.org/xquery/html-templating";
import module namespace config="http://www.tei-c.org/tei-simple/config" at "config.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare
    %templates:wrap
function app:foo($node as node(), $model as map(*)) {
    <p>Dummy templating function.</p>
};

declare
    %templates:wrap    
    %templates:default("key","")
function app:load-person($node as node(), $model as map(*), $key as xs:string) {
    let $log := util:log("info", "app:load-person $key:" || $key)
    let $person := doc($config:data-root || "/people.xml")//tei:person[@xml:id = xmldb:decode($key)]
    let $person-name := string-join($person/tei:persName//text(), " ")
    let $log := util:log("info", "app:load-person $person: " || $person-name)
    
    return 
        map {
                "title": $person-name,
                "key":$key,
                "note":$person/tei:note/text()
        }    
};

declare %templates:wrap 
        %templates:default("type", "place") 
function app:person-mentions($node as node(), $model as map(*), $type as xs:string) {
    let $key := $model?key
    let $log := util:log("info", "app:mentions: $key: " || $key )
    let $person := doc($config:data-root || "/person/person.xml")//tei:person[@xml:id = $key]
    let $keyvalue := substring-after($key, "P")
    let $matches := collection($config:data-root)//tei:TEI[(.//tei:rs[@type='pers']/@key) = $keyvalue]
    let $log := util:log("info", "app:mentions $matches: " || count($matches))
    return
        <div>
            <h3>Mentions:</h3>
            <div class="mentions">{
                if(count($matches) > 0)
                then (                    
                    <ul>{
                         for $doc in $matches
                            let $doc-name := util:document-name($doc)
                            let $log := util:log("info", "app:ref-list: name: " || $doc-name)
                            let $title := $doc//tei:titleStmt/tei:title/text()
                            let $log := util:log("info", "app:ref-list: $title: " || $title)
                            return
                                if($title)
                                then (
                                    <li>
                                        <a href="../{$doc-name}">
                                            {$title}
                                        </a>
                                    </li>
                                ) else ()
                    }</ul>
                ) else()
            }</div>
        </div>
};