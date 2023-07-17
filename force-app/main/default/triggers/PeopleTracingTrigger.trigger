trigger PeopleTracingTrigger on People_Tracing__c (before insert, after insert) {
	
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CTPeopleTracingTriggerHandle.beforeInsert(Trigger.new);
        }
    }
    
}