sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'app.purchase.purchaseapp.project1',
            componentId: 'PurchaseRequestsObjectPage',
            contextPath: '/PurchaseRequests'
        },
        CustomPageDefinitions
    );
});