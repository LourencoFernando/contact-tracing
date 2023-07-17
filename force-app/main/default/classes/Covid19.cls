public class Covid19 {
    
    /*
		STATIC pode ser atribuido à CLASSES, MÉTODOSE VARIÁVEIS
		Tudo que for definido como STATIC pode ser acedido diretamente sem a necessidade
		de instaciar a classe, apenas colocamos o nome da classe e em seguida o nome do MÉTODO ou VARIÁVEL
	*/
	
    public Integer recoveredInArea = 0;
    public static Integer recoveredInCountry = 0;
    
    public void treatPatient() {
        recoveredInArea++;
        recoveredInCountry++;
    }
    
    // sataic method
    public static void printTreated() {
        System.debug('Recovered in country : '+recoveredInCountry);
    }
    
    static {
        
    }
}