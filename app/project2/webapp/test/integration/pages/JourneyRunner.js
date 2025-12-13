sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"app/purchase/approver/project2/test/integration/pages/ApproverRequestsList",
	"app/purchase/approver/project2/test/integration/pages/ApproverRequestsObjectPage",
	"app/purchase/approver/project2/test/integration/pages/PurchaseRequestCurrencyObjectPage"
], function (JourneyRunner, ApproverRequestsList, ApproverRequestsObjectPage, PurchaseRequestCurrencyObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('app/purchase/approver/project2') + '/test/flp.html#app-preview',
        pages: {
			onTheApproverRequestsList: ApproverRequestsList,
			onTheApproverRequestsObjectPage: ApproverRequestsObjectPage,
			onThePurchaseRequestCurrencyObjectPage: PurchaseRequestCurrencyObjectPage
        },
        async: true
    });

    return runner;
});

