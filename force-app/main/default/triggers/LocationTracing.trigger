trigger LocationTracing on Location_Tracing__c (before insert, before Update) {

    Switch on Trigger.operationType {
        when BEFORE_INSERT {
            CTLocationTracingTriggerHandle.beforeUpdate(Trigger.new);
        }
    }
    
}