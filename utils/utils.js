const prompts = require('./prompts');
module.exports.mapResponse = (amountTranslation, language) => {
  try {
    const trimedTranslation = amountTranslation.trim().replace(/\s+/g, ' ').toLowerCase().split(' ');
    return JSON.stringify(trimedTranslation.map((item) => prompts[language][item]));
  } catch (e) {
    return JSON.stringify({ error: e.message })
  }
};