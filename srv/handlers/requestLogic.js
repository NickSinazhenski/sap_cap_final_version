const cds = require("@sap/cds");
const { SELECT, INSERT, DELETE } = cds.ql;
const { convert } = require("../utils/currencyApi");
const { validateProductExists, ensureNew } = require("../utils/helpers");

module.exports = {
  //  Проверка, что productGroup разрешён для RequestType 
  async checkProductAllowed(requestType, product) {
    const { Product, RequestTypeProducts } = cds.entities("app.model");

    const prod = await SELECT.one.from(Product).where({ product });
    validateProductExists(prod);

    const match = await SELECT.one.from(RequestTypeProducts).where({
      requestType_requestType: requestType,
      productGroup_productGroup: prod.productGroup_productGroup,
    });

    if (!match) {
      throw new Error(
        `Product '${product}' (group ${prod.productGroup_productGroup}) is not allowed for Request Type '${requestType}'.`
      );
    }

    return prod;
  },

  //  Рассчитываем сумму, валюту, USD, профиль 
  async enrichDataWithProductAndProfile(requestType, product, userId) {
    const { ApprovalProfileSetting } = cds.entities("app.model");

    const prod = await this.checkProductAllowed(requestType, product);

    const amountBase = prod.price;
    const amountUSD = await convert(amountBase, prod.currency, "USD");

    const profile = await SELECT.one
      .from(ApprovalProfileSetting)
      .where({ requestType }).and`minAmount <= ${amountBase}`
      .and`maxAmount >= ${amountBase}`;

    return {
      requester_userName: userId,
      totalAmount: amountBase,
      currency: prod.currency,
      approvalProfile_approvalProfile: profile?.approvalProfile ?? null,
      _calcUSD: amountUSD,
    };
  },

  // Перезаписываем валюты: USD 
  async writeCurrencyRows(requestId, currency, amountBase, amountUSD) {
    const { PurchaseRequestCurrency } = cds.entities("app.model");

    await DELETE.from(PurchaseRequestCurrency).where({ parent_ID: requestId });

    await INSERT.into(PurchaseRequestCurrency).entries([
      { parent_ID: requestId, currency: "USD", amount: amountUSD },
    ]);
  },

  //  Загружаем существующую запись 
  async loadExistingRequest(id) {
    const { PurchaseRequest } = cds.entities("app.model");

    const existing = await SELECT.one.from(PurchaseRequest).where({ ID: id });
    if (!existing) throw new Error("Request not found");
    return existing;
  },
};
