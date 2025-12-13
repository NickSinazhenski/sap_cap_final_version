using app.model as db from '../db/schema.cds';

service PurchaseService {
 
  type RequestInfo : {
    ID                : UUID;
    requestType       : String;
    status            : String;
    totalAmount       : Decimal(15,2);
    currency          : String;
    convertedAmount   : Decimal(15,2);
    convertedCurrency : String;
    requester         : String;
  };

  type ProductInfo : {
    product      : String;
    productGroup : String;
    price        : Decimal(15,2);
    currency     : String;
    unitOfMesure : String;
  };

  type CurrencyInfo : {
    ID       : UUID;
    currency : String;
    amount   : Decimal(15,2);
  };

  type PageResult : {
    request     : RequestInfo;
    products    : many ProductInfo;
    currencies  : many CurrencyInfo;      
    canApprove  : Boolean;
    user        : String;
    requestType : String;
  };
  
  entity Product          as projection on db.Product;
  entity Users           as projection on db.Users;
  entity RequestType    as projection on db.RequestType;
  entity productGroup   as projection on db.ProductGroup;
  entity RequestTypeProducts as projection on db.RequestTypeProducts;
   @cds.redirection.target
   @odata.draft.enabled
  entity PurchaseRequests as projection on db.PurchaseRequest;
@requires: 'requester'
   entity RequesterRequests as select from PurchaseRequests{
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
  entity ApproverRequests as select from PurchaseRequests{
   ID,
    requestType,
    status,
    totalAmount,
    currency,
    requester,
    product
  
}
  where status = 'NEW';


  extend entity ApproverRequests with actions {

    @Common.SideEffects : {
      TargetEntities : ['ApproverRequests']
    }
    action Approve() returns Boolean;

    @Common.SideEffects : {
      TargetEntities : ['ApproverRequests']
    }
    action Reject(reason : String) returns Boolean;
  };



}