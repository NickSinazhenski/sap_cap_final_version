const cds = require('@sap/cds');
const { SELECT } = cds.ql;

module.exports = async function readBefore(data, req) {
  const { Users, PurchaseRequestCurrency } = cds.entities('app.model');

  const rows = Array.isArray(data) ? data : [data];
  if (!rows.length) return;

  // валюта апрувера из Users.preferredCurrency
  const me = req.user?.id;

  const userRow = me
    ? await SELECT.one.from(Users).columns('preferredCurrency').where({ userName: me })
    : null;

  const targetCurrency = userRow?.preferredCurrency || 'USD';

  // берём rates только нужной валюты для всех запросов
  const ids = rows.map((r) => r.ID).filter(Boolean);

  if (!ids.length) return;

  const rateRows = await SELECT.from(PurchaseRequestCurrency)
    .columns('parent_ID as requestID', 'currency', 'amount')
    .where({
      parent_ID: { in: ids },
      currency: targetCurrency,
    });

  const byRequest = new Map(rateRows.map((r) => [r.requestID, r]));

  // проставляем виртуальные поля для UI
  for (const r of rows) {
    const match = byRequest.get(r.ID);
    r.approverCurrency = targetCurrency;
    r.approverAmount = match ? match.amount : null;
  }
};
