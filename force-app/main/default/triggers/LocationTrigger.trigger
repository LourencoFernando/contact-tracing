trigger LocationTrigger on Location__c (before insert, after insert, before update, after update) {

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CTLocationTriggerHandle.beforeInsert(Trigger.new);
        }
        
        when BEFORE_UPDATE {
            CTLocationTriggerHandle.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        when AFTER_UPDATE {
            CTLocationTriggerHandle.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }    
}