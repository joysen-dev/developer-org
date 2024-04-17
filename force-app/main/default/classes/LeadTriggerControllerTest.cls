@isTest
public class LeadTriggerControllerTest {
    @isTest
    static void testParseJSONResponse() {
        // Create a test Lead
        Lead testLead = new Lead(
            City = 'TestCity',
            Street = 'TestStreet',
            State = 'TestState',
            Country = 'TestCountry',
            LastName = 'TestLastName',
            Company = 'TestCompany'
        );
        Lead testLead2 = new Lead(
            City = 'TestCity2',
            Street = 'TestStreet2',
            State = 'TestState2',
            Country = 'TestCountry2',
            LastName = 'TestLastName',
            Company = 'TestCompany'
        );

        insert testLead;
        insert testLead2;
        update testLead;

        // Call the parseJSONResponse method
        Test.startTest();
        LeadTriggerController.parseJSONResponse(testLead, testLead2);
        Test.stopTest();

        // Add assertions based on the expected behavior
        // For example, check if the lead's latitude and longitude are updated
        testLead = [SELECT Latitude, Longitude FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(null, testLead.Latitude);
        System.assertEquals(null, testLead.Longitude);
    }
    
    @isTest
    static void testGetCoordinate() {
        // Set up test data
        Lead testLead = new Lead(
            City = 'TestCity',
            Street = 'TestStreet',
            State = 'TestState',
            Country = 'TestCountry',
            LastName = 'TestLastName',
            Company = 'TestCompany'
        );
        insert testLead;

        // Set up the mock callout environment
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        LeadTriggerController.getCordinate('TestCity, TestStreet, TestState, TestCountry|' + testLead.Id);
        Test.stopTest();
    }

   

    @isTest
    static void testLeadLocations() {
        Test.startTest();
        String leadLocations = LeadTriggerController.leadLocations();
        Test.stopTest();
    }
}