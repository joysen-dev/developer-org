public class ApexHourFlowSeris {

    @InvocableMethod (label = 'Delete Related Opportunity')
    public static void deleteOpportunity(List<String> ids){
        
        List<Opportunity> Opps = [SELECT Id FROM Opportunity WHERE AccountId =: ids AND StageName = 'Closed Won'];
        delete Opps;
        
        System.debug('Invocable Method Called');
        System.debug(Opps);

    }
}