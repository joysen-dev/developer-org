public class leadConversion {
    @InvocableMethod
    public static List<String> sendEnvelope(List<Requests> request) {
        Lead mylead = request[0].leadRecord;
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(mylead.Id);
        System.debug('ID of record inserted is: '+mylead.id);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.ownerId = UserInfo.getUserId();
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        system.debug(lcr.isSuccess());
        
        return new List<String>{lcr.getOpportunityId()};
    }

    public class Requests {
        @InvocableVariable(label='Lead Record' description='Lead Record')
        public Lead leadRecord;
      }
}