//curl http://localhost:2000/?amount=34657.56"&"currency=rub -UseBasicParsing
//http://localhost:2000/?amount=34657.56&currency=rub&language=ru
//npm install forever -g
//forever start -l forever.log -a -o out.log -e err.log index.js
//forever stop index.js
const saxon = require('saxon-js');
const url = require('url');
const http = require('http');
const config = require('./config');
const DEBUG = config.DEBUG;
const LANGUAGE = config.LANGUAGE;
const CURRENCY = config.CURRENCY;

const server = new http.Server();

const env = saxon.getPlatform();

const sefFileName = 'amountTranslate.sef';

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

      const doc = env.parseXmlFromString(env.readFile(`amount_${queryParams.language}_${queryParams.currency}.xsl`));
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
          res.end(splitResponse(output.principalResult));
          if (DEBUG) {
            console.log(output.principalResult);
          }
        })

      break;

    default:
      res.statusCode = 501;
      res.end('Not implemented');
  }
});

module.exports = server;

