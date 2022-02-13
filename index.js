const server = require('./server');
const config = require('./config');

server.listen(config.PORT, () => {
  console.log(`Server is listening on http://localhost:${config.PORT}`);
});
