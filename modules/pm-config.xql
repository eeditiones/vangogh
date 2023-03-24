
xquery version "3.1";

module namespace pm-config="http://www.tei-c.org/tei-simple/pm-config";

import module namespace pm-vangogh-web="http://www.tei-c.org/pm/models/vangogh/web/module" at "../transform/vangogh-web-module.xql";
import module namespace pm-vangogh-print="http://www.tei-c.org/pm/models/vangogh/fo/module" at "../transform/vangogh-print-module.xql";
import module namespace pm-vangogh-latex="http://www.tei-c.org/pm/models/vangogh/latex/module" at "../transform/vangogh-latex-module.xql";
import module namespace pm-vangogh-epub="http://www.tei-c.org/pm/models/vangogh/epub/module" at "../transform/vangogh-epub-module.xql";
import module namespace pm-docx-tei="http://www.tei-c.org/pm/models/docx/tei/module" at "../transform/docx-tei-module.xql";

declare variable $pm-config:web-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "vangogh.odd" return pm-vangogh-web:transform($xml, $parameters)
    default return pm-vangogh-web:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:print-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "vangogh.odd" return pm-vangogh-print:transform($xml, $parameters)
    default return pm-vangogh-print:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:latex-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "vangogh.odd" return pm-vangogh-latex:transform($xml, $parameters)
    default return pm-vangogh-latex:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:epub-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "vangogh.odd" return pm-vangogh-epub:transform($xml, $parameters)
    default return pm-vangogh-epub:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:tei-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "docx.odd" return pm-docx-tei:transform($xml, $parameters)
    default return error(QName("http://www.tei-c.org/tei-simple/pm-config", "error"), "No default ODD found for output mode tei")
            
    
};
            
    