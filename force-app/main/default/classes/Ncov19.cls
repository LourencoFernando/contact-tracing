public class Ncov19 {
	private Integer recoveredInArea = 0;
    public static Integer recoveredInCountry = 0;
    
    public Ncov19(Integer recoveredInArea) {
        if (recoveredInArea < 0) {
            this.recoveredInArea = 0;
        } else {
            this.recoveredInArea = recoveredInArea;
        	recoveredInCountry += recoveredInArea;
        }
        
    }
    
    public void treatPtient() {
        recoveredInArea++;
        recoveredInCountry++;
    }
    
    public Integer getTreated() {
        return recoveredInArea;
    }
}