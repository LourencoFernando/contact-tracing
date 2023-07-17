public class CTHealthHeaderController {
	
    @AuraEnabled
    public static Map<String, Integer> getPersonHealthStatusCount() {
        return CTPersonController.getHealthStatusCountView();
    }
    
    @AuraEnabled
    public static Map<String, Integer> getLocationHealthStatusCount() {
        return CTLocationController.getHealthStatusCountView();
    }
    
}