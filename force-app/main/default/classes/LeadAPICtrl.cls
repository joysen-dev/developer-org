@RestResource(urlMapping='/leadapi/*')
global class LeadAPICtrl {
 
    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.statusCode = 200;
        res.responseBody = Blob.valueOf('[get => gets]');
    }

    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String errorMsg;
        Integer statusCode;

        String reqBody = req.requestBody.toString();
        String authenticationToken = System.Label.token;
        Map<String, String> headerMap = new Map<String, String>();
        List<String> emails = new List<String>();

        for(String key : req.headers.keySet()){
            headerMap.put(String.valueOf(key).toLowerCase(), req.headers.get(key));
        }

        if(headerMap.get('token') == authenticationToken){
            try {
                Lead ld = (Lead) JSON.deserialize(reqBody, Lead.class);
                List<Lead> leads = new List<Lead>();

                if(ld.Id == null)
                    leads = [SELECT email FROM Lead];
                else
                    leads = [SELECT email FROM Lead WHERE Id != :ld.Id];
                

                for(Lead lead : leads)
                    emails.add(lead.email);


                if(ld.Id == null){
                    // Insert
                    if(!emails.contains(ld.Email)){
                        if(ld.LastName == NULL || ld.LastName == ''){
                            ld.LastName = 'Last Name';
                        }
                        
                         Database.SaveResult insertResult = Database.Insert(ld, true);

                        if(insertResult.isSuccess()){   statusCode = 200;  errorMsg = JSON.serializePretty(ld);  }
                    }
                    else{
                        errorMsg = JSON.serializePretty(ld.email + ', email already exits');
                        statusCode = 400;
                    }
                    
                }else{
                    // Update
                    if(!emails.contains(ld.Email)){
                        Database.SaveResult updateResults = Database.Update(ld, true);  statusCode = 200;   errorMsg = JSON.serializePretty(ld);                            
                    }
                    else{
                        errorMsg = JSON.serializePretty(ld.email + ', email already exits');    statusCode = 400;
                    }
                }
                
                
            } catch (Exception err) {
                
                errorMsg = JSON.serializePretty(err.getMessage());
                statusCode = 400;
            }
        }else{
            errorMsg = JSON.serializePretty('Token mismatch. Please enater a valid token');
            statusCode = 400;
        }
 
        res.statusCode = statusCode;
        res.responseBody = Blob.valueOf(errorMsg);
        
    }

}