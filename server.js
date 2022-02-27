//curl http://localhost:2000/GenesysPlayBalance?amount=346333.56"&"currency=som"&"language=kg -UseBasicParsing
//http://localhost:2000/GenesysPlayBalance?amount=346333.56&currency=som&language=kg
//npm install forever -g
//forever start -l forever.log -a -o out.log -e err.log index.js
//forever stop index.js
const saxon = require('saxon-js');
const url = require('url');
const http = require('http');
const config = require('./config');
const { mapResponse } = require('./utils/utils');
const DEBUG = process.env.DEBUG || config.DEBUG;
const LANGUAGE = process.env.LANGUAGE || config.LANGUAGE;
const CURRENCY = process.env.CURRENCY || config.CURRENCY;

const server = new http.Server();

const env = saxon.getPlatform();

const sefFileName = 'amountTranslate.sef';

server.on('request', async (req, res) => {

  const errorHandler = (error) => {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ error: error.message }));
  }

  try {

    switch (req.method) {
      case 'GET':

        if (req.url === '/favicon.ico') {
          res.writeHead(200, { 'Content-Type': 'image/x-icon' });
          res.end();
          return;
        }

        const queryParams = url.parse(req.url, true).query;
        const pathname = url.parse(req.url, true).pathname;

        if (!queryParams.amount || !queryParams.currency || !queryParams.language || !pathname
          || !LANGUAGE.includes(queryParams.language)
          || !CURRENCY.includes(queryParams.currency)
          || !queryParams.amount.match(/^\d{1,9}([\.,]\d{0,2}){0,1}$/)
          || pathname !== '/GenesysPlayBalance') {
          res.writeHead(200, { "Content-Type": "application/json" });
          res.end(JSON.stringify({ error: 'Not Valid Params' }));
          return;
        }

        if (DEBUG) {
          console.log(`amount:${queryParams.amount} currency:${queryParams.currency} language:${queryParams.language}`);
        }

        const doc = env.parseXmlFromString(await env.readFile(`./xsl/amount_${queryParams.language}_${queryParams.currency}.xsl`));
        doc._saxonBaseUri = sefFileName;
        const sef = saxon.compile(doc);

        const sourceText = `
            <?xml version="1.0" encoding="UTF-8"?>
            <translate>
                <amount>${queryParams.amount}</amount>
                <currency>:${queryParams.currency}</currency>
                <language>:${queryParams.language}</language>
            </translate>`;
        saxon.transform({
          stylesheetInternal: sef,
          sourceText: sourceText,
          destination: "serialized"
        }, "async")
          .then(output => {
            res.writeHead(200, { "Content-Type": "application/json" });
            res.end(mapResponse(output.principalResult, queryParams.language));
            if (DEBUG) {
              console.log(output.principalResult);
            }
          })
          .catch(errorHandler);

        break;

      default:
        res.statusCode = 501;
        res.end('Not implemented');
    }
  } catch (e) {
    errorHandler(e);
  }
});

module.exports = server;

