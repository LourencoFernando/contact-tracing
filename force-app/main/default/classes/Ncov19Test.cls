@isTest
public class Ncov19Test {
	
    @isTest
    public static void treatPtientTest() {
        Ncov19 castelo = new Ncov19(10);
        
        Integer treated = castelo.getTreated();
        System.assertEquals(10, treated,'Treated count does not Match');
        
        Ncov19 iNova = new Ncov19(123);
        treated = iNova.getTreated();
        System.assertEquals(123, treated,'Treated count does not Match');
        System.assertEquals(133, Ncov19.recoveredInCountry,'Treated count does not Match');
        
        
        castelo.treatPtient();
        treated = castelo.getTreated();
        System.Assert(treated == 11, 'Treated count does not Match');
        System.Assert(Ncov19.recoveredInCountry == 134, 'Treated count does not Match');
        
    }
    
     @isTest
    public static void treatPtientTestNegative() {
        Ncov19 castelo = new Ncov19(-10);
        
        Integer treated = castelo.getTreated();
        System.assertEquals(0, treated,'Treated count does not Match');
    }
}