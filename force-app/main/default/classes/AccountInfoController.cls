public with sharing class AccountInfoController {
    // public AccountInfoController() {

    // }

    @AuraEnabled
    public static Opportunity getStageFromOpportunity(Id recordId){
        Opportunity opp = [SELECT Name FROM Opportunity WHERE AccountId =: recordId];
        return opp;
    }

    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String accountId) {
        return [SELECT Id, Name, Email, Phone, Salary__c FROM Contact WHERE AccountId = :accountId];
    }

    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecords(String objectName, String columns) {
        String query = 'SELECT ' + columns + ' FROM ' + objectName;
        return Database.query(query);
    }

    @AuraEnabled
    public static List<String> getFieldLabel(String objectName, List<String> columns){

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(objectName);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();

        List<String> labels = new List<String>();
        
        for (String fieldName: fieldMap.keySet()) {
            if(columns.contains(fieldName.capitalize())){
                String lableName = fieldMap.get(fieldName).getDescribe().getLabel();
                labels.add(lableName);
            }
        }

        return labels;
    }
}





// List<String> str = new List<String> ();
// str.add('Name');
// str.add('Description');

// AccountInfoController.getFieldLabel('Account', str);