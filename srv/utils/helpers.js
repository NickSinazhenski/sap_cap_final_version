// helpers.js
const cds = require("@sap/cds");

exports.ensureNew = (request, req) => {
  if (request.status !== "NEW")
    req.error(400, "Only NEW requests can be modified");
};

exports.validateRejectReason = (reason, req) => {
  if (!reason || reason.trim().length < 3)
    req.error(400, "Reject reason must be at least 3 symbols");
};

exports.validateProductExists = (prod, req) => {
  if (!prod) req.error(400, "ProductNotFound or invalid name");
};

