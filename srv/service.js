const cds = require("@sap/cds");
const { SELECT } = cds.ql;
const { ensureNew } = require("../srv/utils/helpers");
const logic = require("./handlers/requestLogic"); 
const approve = require("./handlers/approveLogic");

const { Users, UserRoles,  PurchaseRequestCurrency, PurchaseRequest, RequestTypeProducts} = cds.entities("app.model");

async function getUser(req) {
  const user = await SELECT.one.from(Users).where({ userName: req.user.id });
  if (!user) req.error(401, "UserNotFound");
  return user;
}

async function checkRole(userName, role) {
  const row = await SELECT.one.from(UserRoles).where({ user: userName });
  return row?.role === role;
}
module.exports = cds.service.impl(async function () {
  const { PurchaseRequests } = this.entities;


  // CREATE
  this.before("CREATE", PurchaseRequests, async (req) => {
    const requestType = req.data.requestType_requestType;
    const product = req.data.product_product;

    if (!requestType) return req.error(400, "Request Type is required");
    if (!product) return req.error(400, "Product is required");

    const enriched = await logic.enrichDataWithProductAndProfile(
      requestType,
      product,
      req.user.id
    );
   
    

    Object.assign(req.data, enriched);
    req.data.status = "NEW";
  });

  this.after("CREATE", PurchaseRequests, async (data, req) => {
    const row = Array.isArray(data) ? data[0] : data;

    await logic.writeCurrencyRows(
      row.ID,
      row.currency,
      row.totalAmount,
      req.data._calcUSD
    );

    return row;
  });

  
  // UPDATE
  this.before("UPDATE", PurchaseRequests, async (req) => {
    const id = req.data.ID;

    const existing = await logic.loadExistingRequest(id);
    ensureNew(existing, req);

    const requestType =
      req.data.requestType_requestType ?? existing.requestType_requestType;
    const product = req.data.product_product ?? existing.product_product;

    const enriched = await logic.enrichDataWithProductAndProfile(
      requestType,
      product,
      existing.requester_userName
    );
  

    Object.assign(req.data, enriched);
  });

  this.after("UPDATE", PurchaseRequests, async (data, req) => {
    const row = Array.isArray(data) ? data[0] : data;

    await logic.writeCurrencyRows(
      row.ID,
      row.currency,
      row.totalAmount,
      req.data._calcUSD
    );

    return row;
  });

  this.on("Approve", async req => {
  const id = req.params[0].ID;

  return approve.approve(
    { data: { id }, user: req.user, error: req.error.bind(req) },
    { checkRole }
  );
});

this.on("Reject", async req => {
  const id = req.params[0].ID;
  const { reason } = req.data;

  return approve.reject(
    { data: { id, reason }, user: req.user, error: req.error.bind(req) },
    { checkRole }
  );
});



 

});
