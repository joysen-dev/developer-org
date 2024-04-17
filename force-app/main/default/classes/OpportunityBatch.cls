public with sharing class OpportunityBatch implements Database.Batchable<SObject>,  Database.Stateful{
    public OpportunityBatch() {}

    public Integer recordCount = 0;

    public Database.QueryLocator start (Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id FROM Opportunity]);
    } 
    public void execute (Database.BatchableContext bc, List<Opportunity> opps){
        for (Opportunity opp : opps) {
            opp.LeadSource = 'Phone Inquiry';
        }
        update opps;

        recordCount += opps.size();
    }
    public void finish (Database.BatchableContext bc){
        System.debug('Total Number of Records : ' + recordCount);
    }
}