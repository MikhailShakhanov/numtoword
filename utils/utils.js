module.exports.mapResponse = (amountTranslation, language) => {
  const trimedTranslation = amountTranslation.trim().replace(/\s+/g, ' ').toLowerCase();
  return JSON.stringify(trimedTranslation.split(' ')/*
      .map((item, index) => {
        return { [index]: item + '.wav' }
      })*/
  );
};
  /*
return {
  id: order.id,
  user: order.user,
  product: mapProduct(order.product),
  phone: order.phone,
  address: order.address,
};*/