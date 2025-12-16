const cds = require('@sap/cds');
const { SELECT } = cds.ql;
const { ensureNew } = require('../srv/utils/helpers');
const requestHandler = require('./handlers/request');
const approveHandler = require('./handlers/approve');
const userPreferencesHandler = require('./handlers/read');

const { PurchaseRequestCurrency, PurchaseRequest, RequestTypeProducts, ApproverRequests, Users } =
  cds.entities('app.model');

module.exports = cds.service.impl(async function () {
  const { PurchaseRequests } = this.entities;

  // CREATE for requester
  this.before('CREATE', PurchaseRequests, async (req) => {
    try {
      const requestType = req.data.requestType_requestType;
      const product = req.data.product_product;

      if (!requestType) req.error('Request Type is required');
      if (!product) req.error('Product is required');

      const enriched = await requestHandler.getProductInfo(requestType, product, req.user.id);

      Object.assign(req.data, enriched);
      req.data.status = 'NEW';
    } catch (err) {
      req.error(err.status || 500, err.message);
    }
  });

  this.after('CREATE', PurchaseRequests, async (data, req) => {
    const row = Array.isArray(data) ? data[0] : data;

    await requestHandler.replaceCurrencytWithUsd(
      row.ID,
      row.currency,
      row.totalAmount,
      req.data._calcUSD,
    );

    return row;
  });

  // UPDATE for requester
  this.before('UPDATE', PurchaseRequests, async (req) => {
    try {
      const id = req.data.ID;

      const existing = await requestHandler.loadExistingRequest(id);
      ensureNew(existing);

      const requestType = req.data.requestType_requestType ?? existing.requestType_requestType;
      const product = req.data.product_product ?? existing.product_product;

      const enriched = await requestHandler.getProductInfo(
        requestType,
        product,
        existing.requester_userName,
      );

      Object.assign(req.data, enriched);
    } catch (err) {
      req.error(err.status || 500, err.message);
    }
  });

  this.after('UPDATE', PurchaseRequests, async (data, req) => {
    const row = Array.isArray(data) ? data[0] : data;

    await requestHandler.replaceCurrencytWithUsd(
      row.ID,
      row.currency,
      row.totalAmount,
      req.data._calcUSD,
    );

    return row;
  });
  // Actions for approver
  const { ApproverRequests } = this.entities;
  this.on('Approve', ApproverRequests, async (req) => {
    const id = req.params[0].ID;

    return approveHandler.approve({
      data: { id },
      user: req.user,
      error: req.error.bind(req),
    });
  });

  this.on('Reject', ApproverRequests, async (req) => {
    const id = req.params[0].ID;
    const { reason } = req.data;

    return approveHandler.reject({
      data: { id, reason },
      user: req.user,
      error: req.error.bind(req),
    });
  });

  // READ for Approver
  this.after('READ', ApproverRequests, async (data, req) => {
    await userPreferencesHandler(data, req);
  });
});
