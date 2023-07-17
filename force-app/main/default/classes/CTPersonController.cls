public class CTPersonController {
	    
    public static String getToken(String mobile) {
        
        Blob phoneNumber = Blob.valueOf(mobile);
		Blob hash = Crypto.generateDigest('MD5', phoneNumber);
        String token = EncodingUtil.base64Encode(hash);
        
        return token;
    }
    
    public static List<Person__c> getRecentHealthChanges() {
        
        List<Person__c> peoples = [SELECT Id, Name, Health_Status__c, Mobile__c,
                                   Status_Update_Date__c, Token__c
                                   FROM Person__c
                                  ORDER BY Status_Update_Date__c DESC LIMIT 100];
        
        return peoples;
    }
    
    public static List<Person__c> searchPeople(String searchTerm) {
        
        searchTerm = searchTerm + '%';
        
        List<Person__c> peoples = [SELECT Id, Name, Health_Status__c, Mobile__c,
                                   Status_Update_Date__c, Token__c
                                   FROM Person__c
                                   WHERE Name LIKE :searchTerm 
                                   		OR Mobile__c LIKE :searchTerm
                                   		OR Token__c LIKE :searchTerm
                                  ORDER BY Status_Update_Date__c DESC NULLS LAST];
        
        return peoples;
    }
    
    public static Person__c getPersonById(String personId) {
        
        List<Person__c> people = [SELECT Id, Name, Health_Status__c, Mobile__c,
                                   Status_Update_Date__c, Token__c
                                   FROM Person__c
                                   WHERE Id =: personId];
        
        if (people != null && people.size() > 0) {
            return people[0];
        }
        
        return null;
    }
    
    public static Map<String, Integer> getHealthStatusCount() {
        
        Map<String, Integer> personInMap = new Map<String, Integer>();
        
        for (AggregateResult person : [SELECT COUNT(Id) countPeople, Health_Status__c FROM Person__c GROUP BY Health_Status__c]) {
            personInMap.put(String.valueOf(person.get('Health_Status__c')), Integer.valueOf(person.get('countPeople')));
        }
        
        return personInMap;
    }
    
    public static Set<Id> getCohabitants(Set<Id> personsIds, Set<Id> alreadyProcessed) {
        List<String> healthStatuses = new List<String>{'Green', 'Yellow'};
       	List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c
                                                FROM People_Tracing__c
                                                WHERE (Person_1__c IN :personsIds OR Person_2__c IN :personsIds)
                                                AND Contact_Type__c = 'Cohabitant'
                                               AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses)];
        
        Set<Id> cohabitants = new Set<Id>();
        for (People_Tracing__c peopleTracing : peopleTraces) {
            if (!alreadyProcessed.contains(peopleTracing.Person_1__c)) {
                cohabitants.add(peopleTracing.Person_1__c);
                alreadyProcessed.add(peopleTracing.Person_1__c);
            }
            if (!alreadyProcessed.contains(peopleTracing.Person_2__c)) {
                cohabitants.add(peopleTracing.Person_2__c);
                alreadyProcessed.add(peopleTracing.Person_2__c);
            }
        }
        
        return cohabitants;
    }
    
    public static Set<Id> getNeighbours(Set<Id> personsIds, Set<Id> alreadyProcessed) {
       	List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c
                                                FROM People_Tracing__c
                                                WHERE (Person_1__c IN :personsIds OR Person_2__c IN :personsIds)
                                                AND Contact_Type__c = 'Neighbour'
                                               AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')];
        
        Set<Id> neighbours = new Set<Id>();
        for (People_Tracing__c peopleTracing : peopleTraces) {
            if (!alreadyProcessed.contains(peopleTracing.Person_1__c)) {
                neighbours.add(peopleTracing.Person_1__c);
                alreadyProcessed.add(peopleTracing.Person_1__c);
            }
            if (!alreadyProcessed.contains(peopleTracing.Person_2__c)) {
                neighbours.add(peopleTracing.Person_2__c);
                alreadyProcessed.add(peopleTracing.Person_2__c);
            }
        }
        
        return neighbours;
    }
    
    public static Set<Id> getPrimaryContacts(Set<Id> personsIds, Set<Id> alreadyProcessed) {
        List<String> healthStatuses = new List<String>{'Green', 'Yellow'};
       	List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c
                                                FROM People_Tracing__c
                                                WHERE (Person_1__c IN :personsIds OR Person_2__c IN :personsIds)
                                                AND Contact_Type__c = 'Other'
                                                AND Contact_Date__c = LAST_N_DAYS:10
                                               AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses)];
        
        Set<Id> primaryContacts = new Set<Id>();
        for (People_Tracing__c peopleTracing : peopleTraces) {
            if (!alreadyProcessed.contains(peopleTracing.Person_1__c)) {
                primaryContacts.add(peopleTracing.Person_1__c);
                alreadyProcessed.add(peopleTracing.Person_1__c);
            }
            if (!alreadyProcessed.contains(peopleTracing.Person_2__c)) {
                primaryContacts.add(peopleTracing.Person_2__c);
                alreadyProcessed.add(peopleTracing.Person_2__c);
            }
        }
        
        return primaryContacts;
    }
    
    public static Set<Id> getSecondaryContacts(Set<Id> primaryContactsIds, Set<Id> alreadyProcessed) {
       	List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c
                                                FROM People_Tracing__c
                                                WHERE (Person_1__c IN :primaryContactsIds OR Person_2__c IN :primaryContactsIds)
                                                AND Contact_Type__c = 'Other'
                                                AND Contact_Date__c = LAST_N_DAYS:10
                                               AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')];
        
        Set<Id> secondaryContacts = new Set<Id>();
        for (People_Tracing__c peopleTracing : peopleTraces) {
            if (!alreadyProcessed.contains(peopleTracing.Person_1__c)) {
                secondaryContacts.add(peopleTracing.Person_1__c);
                alreadyProcessed.add(peopleTracing.Person_1__c);
            }
            if (!alreadyProcessed.contains(peopleTracing.Person_2__c)) {
                secondaryContacts.add(peopleTracing.Person_2__c);
                alreadyProcessed.add(peopleTracing.Person_2__c);
            }
        }
        
        return secondaryContacts;
    }
    
    public static Map<String, Integer> getHealthStatusCountView() {
        AggregateResult[] healthCountMap = [SELECT Health_Status__c, Count(Id) total FROM Person__c GROUP BY Health_Status__c];
        
        if (healthCountMap != null && healthCountMap.size() > 0) {
            Map<String, Integer> result = new Map<String, Integer>();
            for (AggregateResult ar : healthCountMap) {
                result.put(String.valueOf(ar.get('Health_Status__c')), Integer.valueOf(ar.get('total')));
            }
            return result;
        }
        return null;
    }
    
}