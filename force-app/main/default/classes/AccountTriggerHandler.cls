public with sharing class AccountTriggerHandler implements ITriggerHandler {
    public AccountTriggerHandler() {}

    public static void beforeUpdate(List<Account> newList, List<Account> oldList){
        if(newList[0].NumberOfContacts__c != oldList[0].NumberOfContacts__c){
            newList[0].NumberOfContacts__c = oldList[0].NumberOfContacts__c;
        }
        if(newList[0].AverageSalaryOfContacts__c != oldList[0].AverageSalaryOfContacts__c){
            newList[0].AverageSalaryOfContacts__c = oldList[0].AverageSalaryOfContacts__c;
        }
    }
}