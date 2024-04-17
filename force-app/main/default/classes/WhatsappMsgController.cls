public with sharing class WhatsappMsgController {

    @AuraEnabled
    public static Boolean getMsgFromLWC(String msg, String objId, String phnNumber){
        try {
            String phnNumAPIField = System.label.Whstsap_Mobile_API;
            String query = 'SELECT Id, '+ phnNumAPIField +' FROM Contact WHERE Id = \'' + objId + '\'';

            // System.debug('Query  : '+ query);
            List<Contact> con = Database.query(query);
            // System.debug('Message :  '+ msg);
            // System.debug('Mobile Phone :  '+ con[0].MobilePhone);
            // System.debug('Object Id :  '+ objId);
            Boolean gotError = sendWhatsappMsg(phnNumber, msg);
            return gotError;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Sending Message to What'sapp. 
    public static Boolean sendWhatsappMsg(String phnNumber, String msg){
        String endPointURL = 'https://graph.facebook.com/v17.0/151369331393247/messages';
        String accessToken ='EAAEC7umWpvsBOznNZAmj0m9UyWXK24uWbMHN42KE5RmJtAXeyYnIHTFp1BFjQaZCpQZBECTUdiesDZBf4f3IJ7sv9CgC3WV4bzYR4TQHBx9ZBhsEzVVIvRL2yIJZA8T66lbVD5VTNJ7OHdBvNVaCw2YZCZCSKpiSCt54TvMDcFG10xzA1bOyF24CV8xKxqZBrYeZCEc2DWfKGkLBTdV9N1wqEdccslIgPnz2M7';
        // Send Template
        // String body = '{"messaging_product": "whatsapp", "to": "'+phnNumber+'", "type": "template", "template": { "name": "hello_world", "language": { "code": "en_US" }}}';

        // Send Customize SMS
        String body = '{ "messaging_product": "whatsapp", "to": "8801988631912", "text": { "body": "' + msg + '" } }';


        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPointURL);
        request.setMethod('POST');
        request.setBody(body);
        request.setHeader('content-type', 'application/json' );
        request.setHeader('Authorization' ,'Bearer '+ accessToken );

        Http http = new Http();
        HTTPResponse response = http.send(request);

        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

        // If error found return true.
        Boolean gotError = jsonResponse.containsKey('error'); 

        // If Message Sent, Create Whatsapp Message record
        if (!gotError) {
            createWPSendMsgRecord(phnNumber, msg);
        }

        System.debug('Request Body : ' + body);
        System.debug('Response From API Call : ' + response.getBody());
        
        return gotError;
    }

    // Creating Whatsapp Outgoing Message Record 
    public static void createWPSendMsgRecord(String phnNumber, String msg){
        Whatsapp_Message__c WPMsg = new Whatsapp_Message__c();
        WPMsg.Outgoing__c = true;
        WPMsg.Phone_Number__c = phnNumber;
        WPMsg.message__c = msg;
        Database.SaveResult srList = Database.insert(WPMsg, false);
        if (srList.isSuccess()) {
            String result = 'Successfully inserted Whatsapp Message. Record ID: ' + srList.getId();
            System.debug(result);
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Whatsapp_Message__c> getWhatsappMessages(String recordId){
        try {
            Contact con = [SELECT Id, Name, MobilePhone FROM Contact WHERE Id = :recordId];
            List<Whatsapp_Message__c> messages = [SELECT Incoming__c, Outgoing__c, Message__c FROM Whatsapp_Message__c WHERE Phone_Number__c = :con.MobilePhone ORDER BY CreatedDate ASC];

            return messages;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Contact getContactNamePhone(String recordId){
        try {
            Contact con = [SELECT Id, MobilePhone FROM Contact WHERE Id = :recordId];
            
            return con;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}