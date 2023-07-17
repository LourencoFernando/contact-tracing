public class LeadTriggerHandle {
    public static Boolean alreadyExecuted = false;
    
    public static void beforeInsertHandle(List<Lead> newRecords) {
        for (Lead leadRecord : newRecords) {
            if (String.isBlank(leadRecord.LeadSource)) {
                leadRecord.LeadSource = 'Other';
            }
            
            if (String.isBlank(leadRecord.Industry)) {
                leadRecord.addError('The industry field cannot be blank');
            }
        }
    }
    
    public static void afterInsertHandle(List<Lead> newRecords) {
        
        List<Task> leadTasks = new List<Task>();
        for (Lead leadRecord : newRecords) {
            Task leadTask = new Task(Subject='Follow up on Lead Status', WhoId=leadRecord.Id);
            leadTasks.add(leadTask);
        }
        insert leadTasks;
        
        // Inserting another lead record
        // This will call the Trigger recursively
        if (LeadTriggerHandle.alreadyExecuted == false) {
            LeadTriggerHandle.alreadyExecuted = true;
            Lead anotherLead = new Lead(LastName='Another test Lead', Status='Open - Not Contacted', Company='Salesforce', Industry='Agriculture');
        	insert anotherLead;
        }
        
    }
    
    public static void beforeUpdateHandle(List<Lead> newRecords, Map<Id, Lead> oldRecords) {
        for (Lead leadRecord : newRecords) {
            if (String.isBlank(leadRecord.LeadSource)) {
                leadRecord.LeadSource = 'Other';
            }
            
            if ((leadRecord.Status == 'Closed - Converted' || leadRecord.Status == 'Closed - Not Converted') && oldRecords.get(leadRecord.Id).Status == 'Working - Contacted') {
                leadRecord.Status.addError('You cannot directly close an open lead record');
            }
        }
    }
    
}