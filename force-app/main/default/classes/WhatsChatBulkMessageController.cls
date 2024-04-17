public with sharing class WhatsChatBulkMessageController {

    @AuraEnabled(cacheable=true)
    public static string getLeadListViews(){
        try {
            List<listViewWrapper> allLeadListView = new List<listViewWrapper>();
            for(ListView_Query__c lq : [Select Id, ListView_Id__c, Name From ListView_Query__c ORDER BY Name ASC]){
                listViewWrapper wc = new listViewWrapper();
                wc.label = lq.Name;
                wc.value = lq.ListView_Id__c;
                wc.selected = false;
                allLeadListView.add(wc);
            }
            return JSON.serialize(allLeadListView);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<Contact> recordsBasedOnListView(String listViewId) {

        List<ListView_Query__c> listViewDetails = [SELECT Id, ListView_Query_Script__c, Name FROM ListView_Query__c WHERE ListView_Id__c  = :listViewId];
        List<Contact> cons = new List<Contact>();

            
            if(!listViewDetails.isEmpty()){
    
                String listViewScript = (String) listViewDetails[0].ListView_Query_Script__c;
                System.debug('listViewScript = ' + listViewScript);
    
                String[] substrings = listViewScript.split('WHERE');

                System.debug('substrings = ' + substrings.size());
    
    
    
                // substrings.size() == 1 -> Query Doesn't have 'WHERE' Condition
                // substrings.size() == 2 -> Query have 'WHERE' Condition
                
                if(substrings.size() == 1){
                    cons = Database.query(listViewDetails[0].ListView_Query_Script__c);
                }else{
                    String Querystr = 'SELECT Id, Name, MobilePhone, Email, Title, LeadSource FROM Contact WHERE  '+ substrings[1];
                    cons = Database.query(Querystr);
                }
                
                System.debug(JSON.Serializepretty(cons));
            }
    
            return cons;
    }

    public class listViewWrapper{
        String label;
        String value;
        boolean selected;
    }
}