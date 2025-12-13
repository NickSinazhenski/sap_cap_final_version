using PurchaseService as service from '../../srv/service';
annotate service.ApproverRequests with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'Request Type',
                Value : requestType_requestType,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Requester',
                Value : requester_userName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Product',
                Value : product_product,
            },
            {
                $Type : 'UI.DataField',
                Value : rates.amount,
                Label : 'Price',
            },
            {
                $Type : 'UI.DataField',
                Value : rates.currency,
                Label : 'Currency'
            },
            {
                $Type : 'UI.DataField',
                Value : status,
                Label : 'status',
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        }
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : ID,
            Label : 'ID',
        },
        {
            $Type : 'UI.DataField',
            Label : 'Request Type',
            Value : requestType_requestType,
        },
        {
            $Type : 'UI.DataField',
            Value : rates.amount,
            Label : 'Price',
        },
        {
            $Type : 'UI.DataField',
            Value : rates.currency,
            Label : 'Currency',
        },
        {
            $Type : 'UI.DataField',
            Label : 'Requester',
            Value : requester_userName
        }
    ],
    UI.Identification : [
       {
        $Type : 'UI.DataFieldForAction',
        Action : 'PurchaseService.Approve',
        Label : 'Approve',
        RequiresContext : true,
        Determining : true,
        Criticality : #Positive,
        @UI.Confirmation : {
            Title : 'Approve request',
            Text  : 'Are you sure you want to APPROVE this request?'
        },
    },
    {
        $Type : 'UI.DataFieldForAction',
        Action : 'PurchaseService.Reject',
        Label : 'Reject',
        RequiresContext : true,
        Determining : true,
        Criticality : #Negative,
        @UI.Confirmation : {
            Title : 'Reject request',
            Text  : 'Are you sure you want to REJECT this request?'
        },
    }
    ],
);

annotate service.ApproverRequests with {
    requestType @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'RequestType',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : requestType_requestType,
                ValueListProperty : 'requestType',
            },
        ],
    }
};

annotate service.ApproverRequests with {
    requester @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Users',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : requester_userName,
                ValueListProperty : 'userName',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'preferredCurrency',
            },
        ],
    }
};
annotate service.ApproverRequests with actions {
  
  @Capabilities.OperationAvailable : {
    $edmJson : {
      $Eq : [ { $Path : 'status' }, '!NEW' ]
    }
  }
  Approve;

  @Capabilities.OperationAvailable : {
    $edmJson : {
      $Eq : [ { $Path : 'status' }, '!NEW' ]
    }
  }
  Reject;
};

annotate service.ApproverRequests with actions {
  @Common.SideEffects : {
    TargetEntities : ['service.ApproverRequests.status']
  }
  Approve;

  @Common.SideEffects : {
    TargetEntities : ['service.ApproverRequests.status']
  }
  Reject;
};


annotate service.ApproverRequests with {
    product @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Product',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : product_product,
                ValueListProperty : 'product',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'productGroup_productGroup',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'price',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'currency',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'unitOfMesure',
            }
        ]
    }
};

