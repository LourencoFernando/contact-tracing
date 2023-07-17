public class CTLocationTracingTriggerHandle {

    public static void beforeUpdate(List<Location_Tracing__c> newRecords) {
        List<Location_Tracing__c> duplicates = CTLocationTracingController.checkDuplicates(newRecords);
        
        for (Location_Tracing__c locTrace : duplicates) {
            locTrace.addError('Duplicate Location Trace found. Location: ' + locTrace.Location__c + ' With person: ' + locTrace.Person__c);
        }
    }
    
}