trigger StudentTrigger on Student__c (before insert, after insert) {
    if(trigger.isBefore){
        StudentTriggerHandler.updateJoiningDate(trigger.new);
    }
    // if(trigger.isAfter){
    //     StudentTriggerHandler.createContact(trigger.new);
    // }
}