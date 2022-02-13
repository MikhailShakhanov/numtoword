module.exports = {
  PORT: (process.env.NODE_ENV === 'HEROKU') ? 80 : 2000,
};
