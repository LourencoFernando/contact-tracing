@IsTest
private class AccountManagerTest {
	
    @isTest
    static void testGetAccountById() {
        Account a = new Account(Name='TestAccount');
        insert a;
        Contact c = new Contact(AccountId=a.Id, FirstName='Test', LastName='Test');
        insert c;
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://resourceful-badger-6xd6l7-dev-ed.my.salesforce.com/services/apexrest/Accounts/'+a.Id+'/contacts/';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account thisAccount = AccountManager.getAccount();
        // Verify results
        System.assert(thisAccount != null);
        System.assertEquals('TestAccount', thisAccount.Name, 'A conta esperada não goi retornada');
        
    }
    
}