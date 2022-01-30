const saxon = require("saxon-js");
const url = require('url');
const http = require('http');
const path = require('path');

const server = new http.Server();

const env = saxon.getPlatform();

const sefFileName = 'amountTranslate.sef';
const sourceFileName = 'amount.xml';

const doc = env.parseXmlFromString(env.readFile("amount.xsl"));
doc._saxonBaseUri = sefFileName;
const sef = saxon.compile(doc);

server.on('request', (req, res) => {
    const reqUrl = new URL(req.url, `http://${req.headers.host}`);

    const pathname = reqUrl.pathname.slice(1);

    switch (req.method) {
        case 'GET':
            const queryParams = url.parse(req.url, true).query;
            console.log(`amount:${queryParams.amount} currency:${queryParams.currency}`);
            const sourceText = `
            <?xml version="1.0" encoding="UTF-8"?>
            <translate>
                <amount>${queryParams.amount}</amount>
                <currency>:${queryParams.currency}</currency>
            </translate>`;
            saxon.transform({
                stylesheetInternal: sef,
                //sourceFileName: sourceFileName,
                sourceText: sourceText,
                destination: "serialized"
            }, "async")
                .then(output => {
                    res.writeHead(200, { 'Content-Type': 'application/xhtml+xml; charset=utf-8' });
                    res.write(output.principalResult);
                    res.end();
                    console.log(output.principalResult)
                })

            break;

        default:
            res.statusCode = 501;
            res.end('Not implemented');
    }
});

server.listen(3000, () => {
    console.log('Server is listening on http://localhost:3000');
});

