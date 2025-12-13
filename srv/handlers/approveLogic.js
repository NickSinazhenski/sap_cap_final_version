const cds = require("@sap/cds");

const { validateRejectReason} = require("../utils/helpers");

const { PurchaseRequest } = cds.entities("app.model");

exports.approve = async (req, { checkRole }) => {
  const { id } = req.data;

  if (!(await checkRole(req.user.id,'approver')))
    req.error(403,"Access denied, approver only");

  return (await UPDATE(PurchaseRequest)
    .set({ status:"APPROVED" })
    .where({ID:id})) === 1;
};

exports.reject = async (req, { checkRole }) => {
  const { id, reason } = req.data;
  validateRejectReason(reason, req);
  if (!(await checkRole(req.user.id,'approver')))
    return req.error(403,"Only approver can REJECT");

  return (await UPDATE(PurchaseRequest)
    .set({ status:"REJECTED", rejectReason:reason })
    .where({ID:id})) === 1;
};