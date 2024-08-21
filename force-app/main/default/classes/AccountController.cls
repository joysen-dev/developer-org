public with sharing class AccountController {


    @AuraEnabled(cacheable=true)
    public static List<Contact> wireDemo(String recordId){
        try {
            List<Contact> cons = [SELECT Name, Phone, Email FROM Contact WHERE AccountId =: recordId];
            if (cons.size() > 0) {
                return cons;
            }
            return cons;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @InvocableMethod(label='Get Contact' description='' category='Custom Apex')
    public static List<List<Contact>> getContactsRelatedToAccount(List<String> ids){
        
        // String id = '0055i00000B4lqdAAB';
        List<Contact> contacts = new List<Contact>();

        List<Account> accounts = [SELECT Id, Name FROM Account WHERE OwnerId = :ids[0]] ;
        
        for(Account account : accounts){
            List<Contact> consRelatedToAcc = [SELECT Name, Email, AccountId, AccountName__c FROM Contact WHERE AccountId = :account.Id];
            contacts.addAll(consRelatedToAcc);
        }

        return new List<List<Contact>>{contacts};

    }
}