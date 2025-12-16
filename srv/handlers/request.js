const cds = require('@sap/cds');
const { SELECT, INSERT, DELETE } = cds.ql;
const { convert } = require('../utils/currencyApi');
const { checkProductAllowed } = require('../utils/helpers');

module.exports = {
  //  Рассчитываем сумму, валюту в USD, профиль
  async getProductInfo(requestType, product, userId) {
    const { ApprovalProfileSetting } = cds.entities('app.model');

    const prod = await checkProductAllowed(requestType, product);

    const amountBase = prod.price;
    const amountUSD = await convert(amountBase, prod.currency, 'USD');

    const profile = await SELECT.one.from(ApprovalProfileSetting).where({ requestType })
      .and`minAmount <= ${amountBase}`.and`maxAmount >= ${amountBase}`;

    return {
      requester_userName: userId,
      totalAmount: amountBase,
      currency: prod.currency,
      approvalProfile_approvalProfile: profile?.approvalProfile,
      _calcUSD: amountUSD,
    };
  },

  // Перезаписываем валюты
  async replaceCurrencytWithUsd(requestId, currency, amountBase, amountUSD) {
    const { PurchaseRequestCurrency } = cds.entities('app.model');
    await DELETE.from(PurchaseRequestCurrency).where({ parent_ID: requestId });
    await INSERT.into(PurchaseRequestCurrency).entries([
      { parent_ID: requestId, currency: 'USD', amount: amountUSD },
    ]);
  },

  //  Загружаем существующую запись
  async loadExistingRequest(id) {
    const { PurchaseRequest } = cds.entities('app.model');

    const existing = await SELECT.one.from(PurchaseRequest).where({ ID: id });
    if (!existing) {
      const err = new Error('Request not found');
      throw err;
    }
    return existing;
  },
};
