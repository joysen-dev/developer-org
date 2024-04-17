public with sharing class LeadTriggerController {
    public static void parseJSONResponse(Lead newLd, Lead oldLd) {  
        String data;
        if((newLd.City != oldLd.City || newLd.Street != oldLd.Street || newLd.State != oldLd.State || newLd.Country != oldLd.Country)){
            if(newLd.City != null)     data = newLd.City  + ', ';
            if(newLd.Street != null)   data += newLd.Street + ', ';
            if(newLd.State != null)    data += newLd.State + ', ';
            if(newLd.Country != null)  data += newLd.Country;
    
            data += '|' + (String) newLd.Id;
            if(!Test.isRunningTest()){
                getCordinate(data);
            }
        }
    }


    @future(callout=true)
    public static void getCordinate(String data) {
        String address = data.split('\\|')[0]; // Use '\\' to escape the '|'
        String leadId = data.split('\\|')[1]; 
        
        String key = 'AIzaSyB9scaefwD9ApL3vHJX3LbK6pwAHIEST50'; 
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.urlEncode(address, 'UTF-8') + '&key=' + key;
        request.setEndPoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = httpProtocol.send(request);

        if (response.getStatusCode() == 200) {
            // Parse the JSON response to extract coordinates
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            if (jsonResponse.containsKey('results') && jsonResponse.get('results') instanceof List<Object>) {
                List<Object> results = (List<Object>) jsonResponse.get('results');
                if (!results.isEmpty()) {
                    Map<String, Object> geometry = (Map<String, Object>) ((Map<String, Object>) results[0]).get('geometry');
                    Map<String, Object> location = (Map<String, Object>) geometry.get('location');
                    Decimal latitude = (Decimal) location.get('lat');
                    Decimal longitude = (Decimal) location.get('lng');

                    System.debug(latitude);
                    System.debug(longitude);

                    Lead updateLead = [SELECT Id, Latitude, Longitude FROM Lead WHERE Id =:leadId];
                    updateLead.Latitude = latitude;
                    updateLead.Longitude = longitude;

                    update updateLead;


                } else {
                    System.debug('No results found.');
                }
            }
        } else {
            System.debug('HTTP request failed with status code: ' + response.getStatusCode());
        }
    }

    @AuraEnabled(cacheable=true)
    public static string leadLocations(){
        try {
            List<Lead> data = [SELECT Id, City, Country, PostalCode, State, Street, Name FROM Lead WHERE Show_On_Map__c = true];

            return JSON.Serializepretty(data);
        } catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }


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
    public static List<Lead> getLeadListViewDataApex( String listViewId) {

        List<ListView_Query__c> listViewDetails = [SELECT Id, ListView_Query_Script__c, Name FROM ListView_Query__c WHERE ListView_Id__c  = :listViewId];
        List<Lead> leads = new List<Lead>();
        
        if(!listViewDetails.isEmpty()){
            String listViewScript = listViewDetails[0].ListView_Query_Script__c;
            String[] substrings = listViewScript.split('WHERE');
            
            // System.debug('List View Script : ' + listViewScript);

            // Based On List View
            String Querystr = 'SELECT Id, City, Country, PostalCode, State, Street, Name, Latitude, Longitude FROM Lead WHERE '+ substrings[1];
            // System.debug('Query String : ' + Querystr);
            
            leads = Database.query(Querystr);
            // System.debug('Leads : ' + leads);
        }
        return leads;
    }
    
    public class listViewWrapper{
        String label;
        String value;
        boolean selected;
    }
}