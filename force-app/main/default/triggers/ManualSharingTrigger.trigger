trigger ManualSharingTrigger on Student__c (before insert, before delete, before update, after insert, after delete, after update) {
    ManualSharingHandler.execute(trigger.old, trigger.new);
}