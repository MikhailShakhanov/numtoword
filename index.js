const server = require('./server');
const config = require('./config');
const PORT = process.env.PORT || config.PORT;

server.listen(PORT, () => {
  console.log(`Server is listening on https://localhost:${PORT}`);
});
