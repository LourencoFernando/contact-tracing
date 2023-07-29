({
	updateStatus : function(component) {
		const recordId = component.get("v.recordId")
        
        const action = component.get("c.updateHealthStatus")
        action.setParams({
            personId: recordId
        })
        
		action.setCallback(this, function (response) {
            const state = response.getState()
            
            if (state === "SUCCESS") {
                this.showMyToast("Success", "Person Health Status Updated", "success")
            }
        })
        $A.enqueueAction(action)        
	},
    
    showMyToast : function(title, message, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
       title,
       message,
       type
    });
    toastEvent.fire();
}
})