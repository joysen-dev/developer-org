trigger AccountTrigger on Account (before update, after update, before delete, after delete, before insert, after insert) {
    AccountTriggerHandler accountTriggerHandlerObj = new AccountTriggerHandler();
    TriggerDispatcher.run(accountTriggerHandlerObj);
}