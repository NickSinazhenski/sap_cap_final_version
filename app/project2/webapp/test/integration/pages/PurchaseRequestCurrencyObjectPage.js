sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'app.purchase.approver.project2',
            componentId: 'PurchaseRequestCurrencyObjectPage',
            contextPath: '/ApproverRequests/rates'
        },
        CustomPageDefinitions
    );
});