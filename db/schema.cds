namespace app.model;

entity RequestType {
  key requestType : String;
}

entity ProductGroup {
  key productGroup : String;
}

entity Product {
  key product       : String;
      productGroup  : Association to ProductGroup;
      price         : Decimal(15,2);
      currency      : String(3);
      unitOfMesure  : String(10);
}

entity RequestTypeProducts {
  key requestType  : Association to RequestType;
  key productGroup : Association to ProductGroup;
}

entity Users {
  key userName          : String;
      preferredCurrency : String(3);
}

entity UserRoles {
  key user : Association to Users;
  key role : String;
}

entity ApprovalProfileSetting {
  key approvalProfile : String;
      requestType     : String;
      role            : String;
      minAmount       : Decimal(15,2);
      maxAmount       : Decimal(15,2);
}



@odata.draft.enabled
entity PurchaseRequest  {
      key ID            : UUID;
      requestType       : Association to RequestType;
      requester         : Association to Users;
      approvalProfile   : Association to ApprovalProfileSetting;

      status            : String default 'NEW';
      rejectReason      : String;

      totalAmount       : Decimal(15,2);
      currency          : String(3);
      product          : Association to Product;

      rates : Composition of many PurchaseRequestCurrency
              on rates.parent = $self;   
      
}

entity PurchaseRequestCurrency { 
    key  parent : Association to PurchaseRequest;
    key  currency : String(3);
      amount   : Decimal(15,2);
}

entity RequestStatusVH {
  key status : String;
}
