trigger PersonTrigger on Person__c (before insert, before update, before delete, after insert, after update, after delete) {
	
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CTPersonTriggerHandle.beforeInsertHandle(Trigger.new);
        }
        
        when BEFORE_UPDATE {
            CTPersonTriggerHandle.beforeUpdateHandle(Trigger.new, Trigger.oldMap);
        }
        
        when AFTER_UPDATE {
            CTPersonTriggerHandle.aftterUpdateHandle(Trigger.new, Trigger.oldMap);
        }
    }
  
}