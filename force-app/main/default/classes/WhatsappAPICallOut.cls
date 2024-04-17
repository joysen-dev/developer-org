@RestResource(urlMapping='/whatsapp/*')
global class WhatsappAPICallOut {
    
    // Whatsapp Webhook Request for TOKEN Verification
    @HttpGet
    global static void doGet(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        // System.debug(req.requestBody);

        // res.statusCode = 200;
        // res.responseBody = Blob.valueOf('Hello World');
        if (req.params.get('hub.verify_token') == 'WHATSAPPTOKEN'){
            res.responseBody = Blob.valueOf(req.params.get('hub.challenge'));
        }
    }

    
    // Whatsapp Webhook Request. For Incoming Whatsapp Message
    @HttpPost
    global static void doPost(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String reqBody = req.requestBody.toString();
        
        String[] data = parseResponse(reqBody);
        String result = createWPReceiveMsgRecord(data[0], data[1]);

        res.statusCode = 200;
        res.responseBody = Blob.valueOf(JSON.serializePretty(result));
    }

    // Parsing Display Phone Number and Test SMS Form Response
    // returning 2 element's of array. First one Phone Number, Second is Text Message
    public static List<String> parseResponse(String reqBody){
        List<String> result = new List<String>();

        Map<String, Object> parsedPayload = (Map<String, Object>) JSON.deserializeUntyped(reqBody); 
        List<Object> entryList = (List<Object>) parsedPayload.get('entry');
        if (entryList != null && !entryList.isEmpty()) {
            Map<String, Object> entry = (Map<String, Object>) entryList[0]; 
            List<Object> changesList = (List<Object>) entry.get('changes');
            if (changesList != null && !changesList.isEmpty()) {
                Map<String, Object> change = (Map<String, Object>) changesList[0];  
                Map<String, Object> value = (Map<String, Object>) change.get('value');  
                Map<String, Object> metadata = (Map<String, Object>) value.get('metadata');
                String phoneNumber = (String) metadata.get('display_phone_number'); // Needed
                result.add(phoneNumber);
                
                List<Object> messagesList = (List<Object>) value.get('messages');
                if (messagesList != null && !messagesList.isEmpty()) {
                    Map<String, Object> message = (Map<String, Object>) messagesList[0];    
                    Map<String, Object> text = (Map<String, Object>) message.get('text');   
                    String textBody = (String) text.get('body'); // Needed
                    result.add(textBody);
                }
            }
        }

        return result;
    }

    // Creating Whatsapp Incoimg Message Record 
    public static String createWPReceiveMsgRecord(String phnNumber, String msg){
        string result = '';
        Whatsapp_Message__c WPMsg = new Whatsapp_Message__c();
        WPMsg.Incoming__c = true;
        WPMsg.Phone_Number__c = phnNumber;
        WPMsg.message__c = msg;
        Database.SaveResult srList = Database.insert(WPMsg, false);
        if (srList.isSuccess()) {
            result = 'Successfully inserted Whatsapp Message. Record ID: ' + srList.getId();
            // System.debug(result);
        }
        return result;
    }

}