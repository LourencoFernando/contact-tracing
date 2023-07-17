public class CTPersonTriggerHandle {
    
    public static void beforeInsertHandle(List<Person__c> newPersons) {
        for (Person__c person : newPersons) {
            person.Health_Status__c = 'Green';
            person.Token__c = CTPersonController.getToken(person.Mobile__c);
        }
    }
    
    public static void beforeUpdateHandle(List<Person__c> newPersons, Map<Id, Person__c> oldPersons) {
        for (Person__c person : newPersons) {
            if (oldPersons.get(person.Id).Health_Status__c != person.Health_Status__c) {
                person.Status_Update_Date__c = Date.today();
            }
        }
    }
    
    public static void aftterUpdateHandle(List<Person__c> newPersons, Map<Id, Person__c> oldPersons) {
        Set<Id> statusChange = new Set<Id>();
        Set<Id> redStatus = new Set<Id>();
        for (Person__c person : newPersons) {
            if (oldPersons.get(person.Id).Health_Status__c != person.Health_Status__c) {
                statusChange.add(person.Id);
            }
            if (person.Health_Status__c == 'Red' && oldPersons.get(person.Id).Health_Status__c != 'Red') {
                redStatus.add(person.Id);
            }
        }
        
        Set<Id> alreadyProcessed = new Set<Id>();
        alreadyProcessed.addAll(redStatus);
        
        Set<Id> orangeStatus = new Set<Id>();
        Set<Id> yellowStatus = new Set<Id>();
        
        List<Person__c> personToUpdate = new List<Person__c>();
        
        // Add Cohabitants
        orangeStatus.addAll(CTPersonController.getCohabitants(redStatus, alreadyProcessed));
        // Add PrimaryContacts
        Set<Id> primaryContacts = CTPersonController.getPrimaryContacts(redStatus, alreadyProcessed);
        orangeStatus.addAll(primaryContacts);
        // Add Neighbours
        yellowStatus.addAll(CTPersonController.getNeighbours(redStatus, alreadyProcessed));
        // Add SecondaryContacts
        yellowStatus.addAll(CTPersonController.getSecondaryContacts(primaryContacts, alreadyProcessed));
        
        for (Id pId : orangeStatus) {
            personToUpdate.add(new Person__c(Id=pId, Health_Status__c='Orange'));
        }
        
        for (Id pId : yellowStatus) {
            personToUpdate.add(new Person__c(Id=pId, Health_Status__c='Yellow'));
        }
        
        if (personToUpdate.size() > 0) {
            update personToUpdate;
        }
        
        List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByPersonIds(statusChange);
        if (locationTraces != null && locationTraces.size() > 0) {
            Set<Id> locationIds = new Set<Id>();
            for (Location_Tracing__c trace : locationTraces) {
                locationIds.add(trace.Location__c);
            }
            
            CTLocationController.updateRedScore(locationIds);
        }
        
        
    }
    
}