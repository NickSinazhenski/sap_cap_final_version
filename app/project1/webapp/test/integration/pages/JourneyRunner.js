sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"app/purchase/purchaseapp/project1/test/integration/pages/PurchaseRequestsList",
	"app/purchase/purchaseapp/project1/test/integration/pages/PurchaseRequestsObjectPage",
	"app/purchase/purchaseapp/project1/test/integration/pages/PurchaseRequestCurrencyObjectPage"
], function (JourneyRunner, PurchaseRequestsList, PurchaseRequestsObjectPage, PurchaseRequestCurrencyObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('app/purchase/purchaseapp/project1') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseRequestsList: PurchaseRequestsList,
			onThePurchaseRequestsObjectPage: PurchaseRequestsObjectPage,
			onThePurchaseRequestCurrencyObjectPage: PurchaseRequestCurrencyObjectPage
        },
        async: true
    });

    return runner;
});

