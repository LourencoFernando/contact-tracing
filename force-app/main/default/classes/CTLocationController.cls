public class CTLocationController {
	
    public static List<Location__c> getRecentStatusChanges() {
        
        List<Location__c> locations = [SELECT Id, Name, Address__c, Pincode__c,
                                      Red_Score__c, Status_Update_Date__c, Status__c
                                      FROM Location__c
                                     ORDER BY Status_Update_Date__c DESC LIMIT 100];
        
        return locations;
    }
    
    public static List<Location__c> searchLocations(String searchTerm) {
        
        searchTerm = searchTerm + '%';
        
        List<Location__c> locations = [SELECT Id, Name, Address__c, Pincode__c,
                                      Red_Score__c, Status_Update_Date__c, Status__c
                                      FROM Location__c
                                       WHERE Name LIKE :searchTerm
                                       		OR Pincode__c LIKE :searchTerm
                                       		OR Address__c LIKE :searchTerm
                                     ORDER BY Status_Update_Date__c DESC NULLS LAST];
        
        return locations;
    }
    
    public static Location__c getLocccationById(String location) {
        
        List<Location__c> locations = [SELECT Id, Name, Address__c, Pincode__c,
                                      Red_Score__c, Status_Update_Date__c, Status__c
                                      FROM Location__c
                                       WHERE Id =: location];
        
        if (locations != null && locations.size() > 0) {
            return locations[0];
        }
        
        return null;
    }
    
    public static Map<String, Integer> getStatusCount() {
        Map<String, Integer> locationStatusInMap = new Map<String, Integer>();
        
        for (AggregateResult locationArray : [SELECT COUNT(Id) countL, Status__c
                                             FROM Location__c
                                            GROUP BY Status__c]) {
           	String statusLocation = String.valueOf(locationArray.get('Status__c'));
            Integer countLocation = Integer.valueOf(locationArray.get('countL'));
            locationStatusInMap.put(statusLocation, countLocation);
        }
        
        return locationStatusInMap;
    }
    
    public static void updateRedScore(Set<Id> locationIds) {
        List<Location__c> locationToUpdate = new List<Location__c>();
        AggregateResult[] redPPeoplePerLocation = [SELECT Location__c, COUNT(Id) total
                                                  FROM Location_Tracing__c
                                                  WHERE Person__r.Health_Status__c = 'Red'
                                                  AND Visit_Date__c = LAST_N_DAYS:10
                                                  AND Location__c IN :locationIds
                                                  GROUP BY Location__c];
        
        for (AggregateResult ar : redPPeoplePerLocation) {
            String locationId = String.valueOf(ar.get('Location__c'));
            Integer redScore = Integer.valueOf(ar.get('total'));
            String status = getStatus(redScore);
            locationToUpdate.add(new Location__c(Id=locationId, Red_Score__c=redScore, Status__c=status));
        }
        
        if (locationToUpdate != null && locationToUpdate.size() > 0) {
            update locationToUpdate;
        }
        
    }
    
    public static String getStatus(Integer redScore)  {
        if (redScore == 0) {
            return 'Green';
        } else if (redScore <= 5) {
            return 'Yellow';
        } else if (redScore  <= 10) {
            return 'Orange';
        } else {
            return 'Red';
        }
    }
    
    public static Map<String, Integer> getHealthStatusCountView() {
        AggregateResult[] healthCountMap = [SELECT Status__c, Count(Id) total FROM Location__c GROUP BY Status__c];
        
        if (healthCountMap != null && healthCountMap.size() > 0) {
            Map<String, Integer> result = new Map<String, Integer>();
            for (AggregateResult ar : healthCountMap) {
                result.put(String.valueOf(ar.get('Status__c')), Integer.valueOf(ar.get('total')));
            }
            return result;
        }
        return null;
    }
    
}