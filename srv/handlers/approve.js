const cds = require('@sap/cds');
const { validateRejectReason } = require('../utils/helpers');
const { PurchaseRequest } = cds.entities('app.model');

exports.approve = async (req) => {
  const { id } = req.data;

  return (await UPDATE(PurchaseRequest).set({ status: 'APPROVED' }).where({ ID: id })) === 1;
};

exports.reject = async (req) => {
  const { id, reason } = req.data;
  validateRejectReason(reason, req);

  return (
    (await UPDATE(PurchaseRequest)
      .set({ status: 'REJECTED', rejectReason: reason })
      .where({ ID: id }))
  );
};
