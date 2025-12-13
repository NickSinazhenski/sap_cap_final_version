sap.ui.define([], function () {
  "use strict";

  console.log("🔥 ObjectPageExt LOADED");

  return {
    onAfterActionExecution: function (oEvent) {
      console.log(" onAfterActionExecution fired");

      const oParams = oEvent.getParameters?.();
      console.log("Action params", oParams);

      if (!oParams || !oParams.success) {
        return;
      }

      const sAction = oParams.actionName || "";

      if (sAction.includes("Approve") || sAction.includes("Reject")) {
        const oRouting = this.base.getExtensionAPI().getRouting();
        oRouting.navigateToRoute("ApproverRequestsList");
      }
    }
  };
});