using PurchaseService as service from '../../srv/service';

/* Object Page: ApproverRequests                         */

annotate service.ApproverRequests with @(

  UI.HeaderInfo : {
    TypeName       : 'Purchase Request',
    TypeNamePlural : 'Purchase Requests',
    Title : {
      $Type : 'UI.DataField',
      Value : ID
    }
  },

  UI.Facets : [
    {
      $Type  : 'UI.ReferenceFacet',
      ID     : 'GeneralInfo',
      Label  : 'General Information',
      Target : '@UI.FieldGroup#General'
    }
  ]
);

/* Field Group: General                                  */

annotate service.ApproverRequests with @(

  UI.FieldGroup #General : {
    Data : [
      { $Type : 'UI.DataField', Label : 'Request Type', Value : requestType_requestType },
      { $Type : 'UI.DataField', Label : 'Requester',    Value : requester_userName },
      { $Type : 'UI.DataField', Label : 'Product',      Value : product_product },
      { $Type : 'UI.DataField', Label : 'Status',       Value : status },
      { $Type : 'UI.DataField', Label : 'Amount',       Value : approverAmount },
      { $Type : 'UI.DataField', Label : 'Currency',     Value : approverCurrency }
    ]
  }
);

/* List Report                                           */


annotate service.ApproverRequests with @(

  UI.LineItem : [
    { $Type : 'UI.DataField', Value : ID,                      Label : 'ID' },
    { $Type : 'UI.DataField', Value : requestType_requestType, Label : 'Request Type' },
    { $Type : 'UI.DataField', Value : requester_userName,      Label : 'Requester' },
    { $Type : 'UI.DataField', Value : status,                  Label : 'Status' },
    { $Type : 'UI.DataField', Value : approverAmount,          Label : 'Amount' },
    { $Type : 'UI.DataField', Value : approverCurrency,        Label : 'Currency' }
  ]
);

/* Actions (Object Page buttons)                          */

annotate service.ApproverRequests with @(

  UI.Identification : [

    {
      $Type        : 'UI.DataFieldForAction',
      Action       : 'PurchaseService.Approve',
      Label        : 'Approve',
      Determining  : true,
      Criticality : 3,
      @UI.Hidden : {
        $edmJson : {
          $Ne : [
            { $Path : 'status' },
            'NEW'
          ]
        }
      }
    },

    {
      $Type        : 'UI.DataFieldForAction',
      Action       : 'PurchaseService.Reject',
      Label        : 'Reject',
      Determining  : true,
      Criticality : 1,
      @UI.Hidden : {
        $edmJson : {
          $Ne : [
            { $Path : 'status' },
            'NEW'
          ]
        }
      }
    }
  ],

  UI.UpdateHidden : true,
  UI.DeleteHidden : true
);

/* Side Effects for Actions                              */

annotate service.ApproverRequests with actions {

  @Common.SideEffects : {
    TargetEntities : ['service.ApproverRequests'],
    TargetProperties : [
      'status',
      'approverAmount',
      'approverCurrency'
    ]
  }
  Approve;

  @Common.SideEffects : {
    TargetEntities : ['service.ApproverRequests'],
    TargetProperties : [
      'status',
      'approverAmount',
      'approverCurrency'
    ]
  }
  Reject;
};

/* Default Filter (Selection Variant)                    */

annotate service.ApproverRequests with @(

  UI.SelectionVariant : {
    SelectOptions : [
      {
        PropertyName : 'status',
        Ranges : [
          {
            Sign   : 'I',
            Option : 'EQ',
            Low    : 'NEW'
          }
        ]
      }
    ]
  }
);

/* Action Availability (Status-based)                    */

annotate service.ApproverRequests with actions {

  @Capabilities.OperationAvailable : {
    $edmJson : {
      $Eq : [
        { $Path : 'status' },
        'NEW'
      ]
    }
  }
  Approve;

  @Capabilities.OperationAvailable : {
    $edmJson : {
      $Eq : [
        { $Path : 'status' },
        'NEW'
      ]
    }
  }
  Reject;
};

