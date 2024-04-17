public with sharing class ContactRecordFormController {
    @AuraEnabled
    public static String sendContactRecordFormData(String data){
        
        Contact con = (Contact) JSON.deserialize(data, Contact.class);
        Database.insert(con, false);
        
        // System.debug('data--->' + con.Id);

        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm()+ '/' + con.Id;
        return baseUrl;
    }
}