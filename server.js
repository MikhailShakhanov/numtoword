//curl http://localhost:3000/?amount=34657.56"&"currency=rub -UseBasicParsing
//npm install forever -g
//forever start -l forever.log -a -o out.log -e err.log app.js
//forever stop app.js
const saxon = require('saxon-js');
const url = require('url');
const http = require('http');
const path = require('path');

const server = new http.Server();

const env = saxon.getPlatform();

const sefFileName = 'amountTranslate.sef';

const doc = env.parseXmlFromString(env.readFile("amount.xsl"));
doc._saxonBaseUri = sefFileName;
const sef = saxon.compile(doc);

const splitResponse = (amountTranslation) => {
    const trimedTranslation = amountTranslation.trim().replace(/\s+/g, ' ');
    return JSON.stringify(trimedTranslation.split(' ')
        .map((item, index) => {
            return { [index]: item + '.wav' }
        })
    );
}

server.on('request', (req, res) => {

    switch (req.method) {
        case 'GET':

            if (req.url === '/favicon.ico') {
                res.writeHead(200, { 'Content-Type': 'image/x-icon' });
                res.end();
                return;
            }

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
                sourceText: sourceText,
                destination: "serialized"
            }, "async")
                .then(output => {
                    res.writeHead(200, { "Content-Type": "application/json" });
                    res.end(splitResponse(output.principalResult));
                    console.log(output.principalResult)
                })

            break;

        default:
            res.statusCode = 501;
            res.end('Not implemented');
    }
});

module.exports = server;

