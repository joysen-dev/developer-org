@RestResource(urlMapping='/opportunityapi/*')
global class OpportunityAPICtrl {

    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String outstring = JSON.serialize(new Map<String, String> {'get'=>'gets'});
    
        res.statusCode = 200;
        res.responseBody = Blob.valueOf(outstring);
    }

    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String errorMsg; Integer statusCode;
        Account account = new Account();
        Contact contact = new Contact();

        String reqBody = req.requestBody.toString();
        
        String authenticationToken = System.Label.token;
        Map<String, String> headerMap = new Map<String, String>();

        for(String key : req.headers.keySet()){
            headerMap.put(String.valueOf(key).toLowerCase(), req.headers.get(key));
        }

        if(headerMap.get('token') == authenticationToken){
            try {
                Opportunity opp = (Opportunity) JSON.deserialize(reqBody, Opportunity.class);
                
                if(opp.Id == null){
                    // Check child name is in the Contact Or Not
                    List<Contact> con = [SELECT Id, Name, AccountId FROM Contact WHERE Name = :opp.Name_of_The_Child__c LIMIT 1]; 
                    
                    // Bind the Opportunity with existing Contact
                    if(con.size() > 0){
                        opp.AccountId = con[0].AccountId; opp.ContactId = con[0].Id;
                    }else{
                    // Bind If found in Account
                        List<Account> acc = [SELECT Id, Name FROM Account WHERE Name = :opp.Name_of_The_Child__c LIMIT 1]; // Can be or than one
                        if(acc.size() > 0){
                            List<Contact> conRelatedToAcc = [SELECT Id, Name FROM Contact WHERE AccountId  = :acc[0].Id LIMIT 1]; // Can be or than one
                            opp.AccountId = acc[0].Id; opp.ContactId = conRelatedToAcc[0].Id;
                        }else{
                            // If not found anywhere create account and contact

                            contact = (Contact) JSON.deserialize(reqBody, Contact.class);
                            if(contact.LastName == NULL) contact.LastName = 'Last Name';
                            Database.Insert(contact, false);
                            account = (Account) JSON.deserialize(reqBody, Account.class);
                            Database.Insert(account, false);
                            
                            contact.AccountId = account.Id;
                            opp.AccountId = account.Id;
                            opp.ContactId = contact.Id;
                        }
                    }
                    Database.SaveResult insertResult = Database.Insert(opp, true);
                    
                    
                    //Create Related list of Prodcut As Course 
                    List<String> coursesFromReq = parseCourses(reqBody);
                    List<Course__c> Courses = new List<Course__c>();
                    
                    
                    for (String courseFormReq : coursesFromReq) {
                        String[] courseValues = courseFormReq.split('::');
                        Course__c Course = new Course__c();
                        List<Product2> prodcuts = [SELECT Id, Name FROM Product2 WHERE Name = :courseValues[0] LIMIT 1];
                        
                        Course.Price__c = Integer.valueOf(courseValues[1]);
                        Course.City__c = courseValues[2];
                        Course.State__c = courseValues[3];
                        Course.Start_Date__c = Date.valueOf(courseValues[4]);
                        Course.End_Date__c = Date.valueOf(courseValues[5]);
                        Course.Opportunity__c = opp.Id;

                        if(prodcuts.size() > 0){
                            Course.Name = prodcuts[0].Name;
                            Course.Product__c = prodcuts[0].Id;
                        }else{
                            Product2 Product = new Product2();
                            Product.IsActive = true;
                            Product.Name = courseValues[0];
                            Database.Insert(Product, false);
                            Course.Name = courseValues[0];
                            Course.Product__c = Product.Id;
                        }
                        Courses.add(Course);
                    }

                    Database.Insert(Courses, true);
                if(insertResult.isSuccess()){ statusCode = 200;   errorMsg = JSON.serializePretty(opp); }
                }else{
                    // Update
                    Database.SaveResult updateResults = Database.Update(opp, true);   statusCode = 200;   errorMsg = JSON.serializePretty(opp);            
                    
                    statusCode = 200;   errorMsg = JSON.serializePretty(opp);
                }
            } catch (Exception err) {
                errorMsg = JSON.serializePretty(err.getMessage());
                statusCode = 400;
            }
        }else{
            errorMsg = JSON.serializePretty('Token mismatch. Please enter a valid token');
            statusCode = 400;
        }
        res.statusCode = statusCode;
        res.responseBody = Blob.valueOf(errorMsg);
    }


    public static List<String> parseCourses(String reqBody){
        JSONParser parser = JSON.createParser(reqBody);
        String temp = '';
        List<String> tempList = new List<String>();
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY ) {
                while (parser.nextToken() != null) {
                    temp = '';
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    	parser.nextToken();
                        //temp = temp + parser.getText() + ': ';
                        parser.nextToken();
                        // temp = parser.getText();
                        temp = temp + '' + parser.getText();
                    
                        parser.nextToken();
                        //temp = temp + parser.getText() + ': ';
                        parser.nextToken();
                        temp = temp + '::' + parser.getText();
                        parser.nextToken();
                        //temp = temp + parser.getText() + ': ';
                        parser.nextToken();
                        temp = temp + '::' + parser.getText();
                        parser.nextToken();
                        //temp = temp + parser.getText() + ': ';
                        parser.nextToken();
                        temp = temp + '::' + parser.getText();
                        parser.nextToken();
                        //temp = temp + parser.getText() + ': ';
                        parser.nextToken();
                        temp = temp + '::' + parser.getText();
                        parser.nextToken();
                        //temp = temp + parser.getText() + ': ';
                        parser.nextToken();
                        temp = temp + '::' + parser.getText();
                        tempList.add(temp);
                        System.debug(JSON.serializePretty(temp));
                        // parser.skipChildren();
                    }
                }
            }
        }
        return tempList;
    }
    
    

}