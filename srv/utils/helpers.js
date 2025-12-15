// helpers.js
const cds = require('@sap/cds');
const { SELECT } = cds.ql;

exports.ensureNew = (request, req) => {
  if (request.status !== 'NEW') req.error(400, 'Only NEW requests can be modified');
};

exports.validateRejectReason = (reason, req) => {
  if (!reason || reason.trim().length < 3)
    req.error(400, 'Reject reason must be at least 3 symbols');
};

exports.validateProductExists = (prod, req) => {
  if (!prod) req.error(400, 'ProductNotFound or invalid name');
};

exports.checkProductAllowed = async function (requestType, product) {
  const { Product, RequestTypeProducts } = cds.entities('app.model');

  const prod = await SELECT.one.from(Product).where({ product });
  if (!prod) {
    throw new Error(`Product '${product}' not found`);
  }

  const match = await SELECT.one.from(RequestTypeProducts).where({
    requestType_requestType: requestType,
    productGroup_productGroup: prod.productGroup_productGroup,
  });

  if (!match) {
    throw new Error(
      `Product '${product}' (group ${prod.productGroup_productGroup}) is not allowed for Request Type '${requestType}'.`,
    );
  }

  return prod;
};
