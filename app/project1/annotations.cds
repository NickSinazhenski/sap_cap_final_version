using PurchaseService as service from '../../srv/service';
annotate service.RequesterRequests with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : requestType_requestType,
                Label : 'Request Type',
            },
            {
                $Type : 'UI.DataField',
                Value : product_product,
                Label : 'Product',
            },
            {
                $Type : 'UI.DataField',
                Value : status,
                Label : 'Request Status',
            },
             {
        $Type : 'UI.DataField',
        Value : rejectReason,
        Label : 'RejectReason',
      }
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : ID,
            Label : 'ID',
        },
        {
            $Type : 'UI.DataField',
            Label : 'Request Status',
            Value : status,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Request Type',
            Value : requestType_requestType,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Price',
            Value : totalAmount,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Currency',
            Value : currency,
        },
    ],
    Communication.Contact #contact : {
        $Type : 'Communication.ContactType',
        fn : requestType_requestType,
    },
);

annotate service.RequesterRequests with {
  rejectReason @Common.FieldControl : 1;
};

annotate service.RequesterRequests with {
  status @Common.FieldControl : 1;
};

annotate service.RequesterRequests with {
    requestType @(
        Common.ValueList: {
            $Type: 'Common.ValueListType',
            CollectionPath: 'RequestType',
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: requestType_requestType,
                    ValueListProperty: 'requestType'
                }
            ]
        },
        Common.ValueListWithFixedValues : true,
    );
};


annotate service.RequesterRequests with {
    product @(
        Common.ValueList: {
        $Type: 'Common.ValueListType',
        CollectionPath: 'Product',
        Parameters: [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : product_product,
                ValueListProperty : 'product',
            },
            {
                $Type : 'Common.ValueListParameterInOut',
                ValueListProperty : 'productGroup_productGroup',
                LocalDataProperty : requestType_requestType,
            },
        ]
    },
        Common.ValueListWithFixedValues : true,
    );
};

