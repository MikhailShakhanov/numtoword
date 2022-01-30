//import { xsltProcess, xmlParse } from 'xslt-processor'
/*const SaxonJS = require('saxon-js')

SaxonJS.transform({
    stylesheetFileName: "books.sef.json",
    sourceFileName: "books.xml",
    destination: "serialized"
}, "async")
    .then(output => {
        response.writeHead(200, { 'Content-Type': 'text/html' });
        response.write(output.principalResult);
        response.end();
    })*/

const saxon = require("saxon-js");
const env = saxon.getPlatform();

const sefFileName = 'books.sef.json';
const sourceFileName = 'books.xml';

const doc = env.parseXmlFromString(env.readFile("books.xsl"));
// hack: avoid error "Required cardinality of value of parameter $static-base-uri is exactly one; supplied value is empty"
doc._saxonBaseUri = sefFileName;

const sef = saxon.compile(doc);
//console.log(sef);

//now you can use `sef`:
/*const resultStringXML = saxon.transform({
    stylesheetInternal: sef,
    sourceText: env.readFile("books.xml")
});*/
saxon.transform({
    //stylesheetFileName: "books.sef.json",
    stylesheetInternal: sef,
    sourceFileName: sourceFileName,
    destination: "serialized"
}, "async")
    .then(output => {
        //response.writeHead(200, { 'Content-Type': 'text/html' });
        //response.write(output.principalResult);
        //response.end();
        //SaxonJS.XPath.evaluate("//test[@id='abc']", doc);
        //const js = saxon.serialize(output, { method: "json", indent: true });
        console.log(output.principalResult)
    })

//console.log(resultStringXML)
