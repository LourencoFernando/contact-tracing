public class ContactTriggerHandle {
    
    public static void afterInsertHandle(List<Contact> newContacts) {
        
        Set<Id> accountIds = new Set<Id>();
        
        for (Contact con : newContacts) {
            if (String.isNotBlank(con.AccountId)) {
                accountIds.add(con.AccountId);
            }
        }
        
        AccountContactService.updateActiveContacts(accountIds);
        
    }
    
    public static void afterUpdateHandle(List<Contact> newContact, Map<Id, Contact> oldMapContacts) {
        Set<Id> accountIds = new Set<Id>();
        
        for (Contact con : newContact) {
            if (String.isNotBlank(con.AccountId) && oldMapContacts.get(con.Id).Active__c != con.Active__c) {
                accountIds.add(con.AccountId);
            }
            if (oldMapContacts.get(con.Id).AccountId != con.AccountId) {
                accountIds.add(con.AccountId);
                accountIds.add(oldMapContacts.get(con.Id).AccountId);
            }
        }
        
        AccountContactService.updateActiveContacts(accountIds);
        
    }
    
    public static void afterDeleteHandle(List<Contact> oldContacts) {
        Set<Id> accountIds = new Set<Id>();
        
        for (Contact con : oldContacts) {
            if (String.isNotBlank(con.AccountId)) {
                accountIds.add(con.AccountId);
            }
        }
        
        AccountContactService.updateActiveContacts(accountIds);
    }
     
    public static void afterUndeleteHandle(List<Contact> newContacts) {
        Set<Id> accountIds = new Set<Id>();
        
        for (Contact con : newContacts) {
            if (String.isNotBlank(con.AccountId)) {
                accountIds.add(con.AccountId);
            }
        }
        
        AccountContactService.updateActiveContacts(accountIds);
    }
    
}