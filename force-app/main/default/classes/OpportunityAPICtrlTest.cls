@isTest
public with sharing class OpportunityAPICtrlTest {

    @isTest
    static void testDoGet() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        OpportunityAPICtrl.doGet();

        // Add assertions for response status code and response body
        System.assertEquals(200, res.statusCode);
        // Add more assertions as needed for the response body
    }

    
    static void testDoPost(String strReq, String token) {
        // Create a sample request body
        String requestBody = strReq;

        RestRequest req = new RestRequest();
        req.requestURI = '/opportunityapi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);
        req.headers.put('token', token);  // Replace with a valid token

        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        OpportunityAPICtrl.doPost();
    }
    @isTest
    static void sendData(){
        testDoPost('{"Name":"Test Opportunity"}', '1234');
        testDoPost('{"Name":"Test Opportunity"}', '1122');
        testDoPost('{\r\n\"Name\": \"New Test Name\",\r\n\"StageName\": \"Autopilot 2\",\r\n\"LastName\": \"Dummy\",\r\n\"CloseDate\": \"2023-6-10\",\r\n\"FirstName\": \"Dummy Test\",\r\n\"Salutation\": \"Mrs.\",\r\n\"MiddleName\": \"\'\",\r\n\"Suffix\": \"\'\",\r\n\"Title\": \"Demo\",\r\n\"Company\": \"Twinforce Solutions\",\r\n\"Street\": \"Demo\",\r\n\"City\": \"Boston\",\r\n\"State\": \"MA\",\r\n\"PostalCode\": \"1111\",\r\n\"Country\": \"United States\",\r\n\"Address\": {\r\n\"city\": \"Boston\",\r\n\"country\": \"United States\",\r\n\"geocodeAccuracy\": null,\r\n\"latitude\": null,\r\n\"longitude\": null,\r\n\"postalCode\": \"1111\",\r\n\"state\": \"MA\",\r\n\"street\": \"Demo\"\r\n},\r\n\"courses\":[\r\n    {\r\n        \"Product__c\": \"SommerBooster\",\r\n        \"Price__c\": 69,\r\n        \"City__c\": \"Berlin 4\",\r\n        \"State__c\": \"Brandenburg 1\",\r\n        \"Start_Date__c\": \"2023-10-16 \",\r\n        \"End_Date__c\": \"2023-10-26\"\r\n    },\r\n    {\r\n        \"Product__c\": \"Abi Intensivkurs   I\",\r\n        \"Price__c\": 109,\r\n        \"City__c\": \"Berlin\",\r\n        \"State__c\": \"Brandenburg\",\r\n        \"Start_Date__c\": \"2023-10-26\",\r\n        \"End_Date__c\": \"2023-10-26\"\r\n    },\r\n    {\r\n        \"Product__c\": \"New Course\",\r\n        \"Price__c\": 109,\r\n        \"City__c\": \"Berlin\",\r\n        \"State__c\": \"Brandenburg\",\r\n        \"Start_Date__c\": \"2023-10-26\",\r\n        \"End_Date__c\": \"2023-10-26\"\r\n    }\r\n],\r\n\"Phone\": \"01988888888\",\r\n\"MobilePhone\": \"01988888888\",\r\n\"Email\": \"Test1@gmail.com\",\r\n\"Website\": \"Demo@gmail.com\",\r\n\"Description\": null,\r\n\"LeadSource\": \"Advertisement\",\r\n\"Status\": \"New Lead\",\r\n\"Industry\": \"Agriculture\",\r\n\"Rating\": \"Hot\",\r\n\"AnnualRevenue\": null,\r\n\"NumberOfEmployees\": 12,\r\n\"Calendly__CalendlyCreated__c\": false,\r\n\"Abiturjahrgang__c\": \"2024/2025\",\r\n\"Class__c\": \"12\",\r\n\"Client_Type__c\": \"Elternteil / Erziehungsberechtigter\",\r\n\"Name_of_The_Child__c\": \"12\",\r\n\"Further_Information__c\": \"Further Information\",\r\n\"Letzte_Note_Punkt__c\": 125,\r\n\"Werbung_zugestimmt__c\": null,\r\n\"Zielnote__c\": null\r\n}', '1234');
    }
}