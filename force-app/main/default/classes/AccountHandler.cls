public class AccountHandler {
    public static Account insertNewAccount(String nomeConta) {
        try {
            Account acct = new Account(Name=nomeConta);
        	insert acct;
            return acct;
        } catch (DmlException e) {
            System.debug('O erro foi: ' + e.getMessage());
            return null;
        }
    }
}