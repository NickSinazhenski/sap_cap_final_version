using PurchaseService as service from '../../srv/service';

/* List Report                                           */
annotate service.PurchaseRequests with @(

  UI.LineItem : [
    {
      $Type  : 'UI.DataField',
      Value  : ID,
      Label  : 'ID'
    },
    {
      $Type  : 'UI.DataField',
      Value  : status,
      Label  : 'Status'
    },
    {
      $Type  : 'UI.DataField',
      Value  : requestType_requestType,
      Label  : 'Request Type'
    },
    {
      $Type  : 'UI.DataField',
      Value  : totalAmount,
      Label  : 'Price'
    },
    {
      $Type  : 'UI.DataField',
      Value  : currency,
      Label  : 'Currency'
    }
  ],

  UI.SelectionPresentationVariant #tableView : {
    $Type : 'UI.SelectionPresentationVariantType',
    PresentationVariant : {
      $Type : 'UI.PresentationVariantType',
      Visualizations : [
        '@UI.LineItem'
      ]
    },
    SelectionVariant : {
      $Type : 'UI.SelectionVariantType',
      SelectOptions : [ ]
    },
    Text : 'Table View'
  },

  UI.LineItem #tableView : [ ],

  UI.SelectionPresentationVariant #tableView1 : {
    $Type : 'UI.SelectionPresentationVariantType',
    PresentationVariant : {
      $Type : 'UI.PresentationVariantType',
      Visualizations : [
        '@UI.LineItem#tableView'
      ]
    },
    SelectionVariant : {
      $Type : 'UI.SelectionVariantType',
      SelectOptions : [ ]
    },
    Text : 'Table View 1'
  },

  UI.Facets : [
    {
      $Type  : 'UI.ReferenceFacet',
      ID     : 'request',
      Label  : 'request',
      Target : '@UI.FieldGroup#request'
    }
  ],

  UI.FieldGroup #request : {
    $Type : 'UI.FieldGroupType',
    Data : [
      {
        $Type  : 'UI.DataField',
        Value  : requestType_requestType,
        Label  : 'Request Type'
      },
      {
        $Type  : 'UI.DataField',
        Value  : product_product,
        Label  : 'Product'
      },
      {
        $Type  : 'UI.DataField',
        Value  : rejectReason,
        Label  : 'Reject Reason'
      },
      {
        $Type  : 'UI.DataField',
        Value  : status,
        Label  : 'Status'
      }
    ]
  }
);

/* Value Help: Request Type                              */

annotate service.PurchaseRequests with {
  requestType @(

    Common.ValueList : {
      $Type           : 'Common.ValueListType',
      CollectionPath  : 'RequestType',
      Parameters : [
        {
          $Type              : 'Common.ValueListParameterInOut',
          LocalDataProperty  : requestType_requestType,
          ValueListProperty  : 'requestType'
        }
      ]
    },

    Common.ValueListWithFixedValues : true
  );
};

/* Value Help: Product                                   */

annotate service.PurchaseRequests with {
  product @(

    Common.ValueList : {
      $Type          : 'Common.ValueListType',
      CollectionPath : 'Product',
      Parameters : [
        {
          $Type              : 'Common.ValueListParameterInOut',
          LocalDataProperty  : product_product,
          ValueListProperty  : 'product'
        },
        {
          $Type              : 'Common.ValueListParameterInOut',
          LocalDataProperty  : requestType_requestType,
          ValueListProperty  : 'productGroup_productGroup'
        }
      ]
    },

    Common.ValueListWithFixedValues : true
  );
};
annotate service.PurchaseRequests with {
  product @Common.Label : 'Product (select Request Type first)';
};
annotate service.PurchaseRequests with {
  requestType @Common.FieldControl : #Mandatory;
};

/* Field Control                                         */


annotate service.PurchaseRequests with {
  status        @Common.FieldControl : #ReadOnly;
  rejectReason  @Common.FieldControl : #ReadOnly;
};

/* Update Restrictions                                   */

annotate service.PurchaseRequests with @(

  UI.UpdateHidden : {
    $edmJson : {
      $Ne : [
        { $Path : 'status' },
        'NEW'
      ]
    }
  }
);

annotate service.PurchaseRequests with @(

  UI.DeleteHidden : {
    $edmJson : {
      $Ne : [
        { $Path : 'status' },
        'NEW'
      ]
    }
  }
);
annotate service.PurchaseRequests with @(

  UI.UpdateHidden : {
    $edmJson : {
      $Ne : [
        { $Path : 'status' },
        'NEW'
      ]
    }
  }
);

annotate service.PurchaseRequests with {
  rejectReason @(
    UI.Hidden : {
      $edmJson : {
        $Eq : [
          { $Path : 'status' },
          'NEW'
        ]
      }
    },
    UI.DataField : {
      Label : 'Reject Reason'
    }
  );
};
annotate service.PurchaseRequests with @(
  UI.SelectionFields : [
    status
  ]
);
annotate service.PurchaseRequests with {
  status      @Common.Label : 'Status';
};
annotate service.PurchaseRequests with {
  status @(

    Common.ValueList : {
      $Type          : 'Common.ValueListType',
      CollectionPath : 'RequestStatusVH',
      Parameters : [
        {
          $Type             : 'Common.ValueListParameterInOut',
          LocalDataProperty : status,
          ValueListProperty : 'status'
        }
      ]
    },

    Common.ValueListWithFixedValues : true
  );
};

