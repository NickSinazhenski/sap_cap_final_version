using app.model as db from '../db/schema.cds';

@requires: 'authenticated-user'
service PurchaseService {

  entity Product                as projection on db.Product;
  entity Users                  as projection on db.Users;
  entity RequestType             as projection on db.RequestType;
  entity ProductGroup            as projection on db.ProductGroup;
  entity RequestTypeProducts     as projection on db.RequestTypeProducts;
  entity PurchaseRequestCurrency as projection on db.PurchaseRequestCurrency;

  @cds.redirection.target
  @odata.draft.enabled
  entity PurchaseRequests as projection on db.PurchaseRequest;

  @requires: 'requester'
  entity RequesterRequests as select from PurchaseRequests {
    ID,
    requestType,
    status,
    totalAmount,
    currency,
    requester,
    createdAt,
    createdBy,
    product
  };

  @requires: 'approver'
  @odata.draft.enabled: false
  entity ApproverRequests as projection on db.PurchaseRequest {
    ID,
    requestType,
    status,
    totalAmount,
    currency,
    requester,
    product,

    virtual approverAmount   : Decimal(15,2),
    virtual approverCurrency : String(3)
  };

  extend entity ApproverRequests with actions {

    @Common.SideEffects: {
      TargetEntities: ['ApproverRequests']
    }
    action Approve() returns Boolean;

    @Common.SideEffects: {
      TargetEntities: ['ApproverRequests']
    }
    action Reject(
      reason : String
    ) returns Boolean;
  };

}