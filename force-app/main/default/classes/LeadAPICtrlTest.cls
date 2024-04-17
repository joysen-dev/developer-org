@isTest
public with sharing class LeadAPICtrlTest {

    @isTest
    static void testDoGet() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        LeadAPICtrl.doGet();

        // Add assertions for response status code and response body
        System.assertEquals(200, res.statusCode);
        // Add more assertions as needed for the response body
    }

    
    static void testDoPost(String strReq, String token) {
        // Create a sample request body
        String requestBody = strReq;

        RestRequest req = new RestRequest();
        req.requestURI = '/leadapi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);
        req.headers.put('token', token); 

        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        LeadAPICtrl.doPost();

        // Add assertions for response status code and response body
        // For example:
        // System.assertEquals(200, res.statusCode);
        // System.assertEquals('{"Id":null,"LastName":"TestLastName","Email":"test@example.com"}', res.responseBody.toString());
    }

    @isTest
    static void sendData(){
        testDoPost('{"Id":null, "LastName": null, "Email":"test@example.com"}', '1234');
        testDoPost('{"Id":00Q1x000008G0yKEAS, "LastName": "TestLastName", "Email":"test@example.com"}', '1122');
    }
}