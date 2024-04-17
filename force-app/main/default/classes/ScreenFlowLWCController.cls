public with sharing class ScreenFlowLWCController {
    // public ScreenFlowLWCController() {
    // }

    @AuraEnabled
    public static String getDataFormLWC(String data){
        Opportunity opp = (Opportunity) JSON.deserialize(data, Opportunity.class);

        insert opp;
        
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm()+ '/' + opp.Id;
        return baseUrl;
    }
}