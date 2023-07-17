trigger leadTrigger on Lead (before insert, after insert, before update, after update) {
    
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            LeadTriggerHandle.beforeInsertHandle(Trigger.new);
        }
        
        when AFTER_INSERT {
            LeadTriggerHandle.afterInsertHandle(Trigger.new);
        }
        
        when BEFORE_UPDATE {
			LeadTriggerHandle.beforeUpdateHandle(Trigger.new, Trigger.oldMap);
        }
    }
	
}