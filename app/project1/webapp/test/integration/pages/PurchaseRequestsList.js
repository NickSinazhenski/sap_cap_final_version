sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'app.purchase.purchaseapp.project1',
            componentId: 'PurchaseRequestsList',
            contextPath: '/PurchaseRequests'
        },
        CustomPageDefinitions
    );
});