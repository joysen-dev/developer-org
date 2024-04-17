@isTest
public class LeadConversionTest {
    @isTest
    public static void StartTest(){
        Lead lead = new Lead(firstName ='Dummy', lastName ='Test', Company='Company Placeholder');
		insert lead;
        leadConversion.Requests req = new leadConversion.Requests();
        req.leadRecord = lead;
        
        
        leadConversion.sendEnvelope(new List<leadConversion.Requests>{req});
    }
}