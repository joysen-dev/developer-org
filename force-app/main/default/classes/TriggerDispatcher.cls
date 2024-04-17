public with sharing class TriggerDispatcher {
    public static void run(ITriggerHandler handler){
        if(Trigger.isBefore){
            if(Trigger.isUpdate){
                handler.beforeUpdate(Trigger.new, Trigger.old);
            }
            if(Trigger.isInsert){}
            if(Trigger.isDelete){}
        }
        if(Trigger.isAfter){
            if(Trigger.isUpdate){}
            if(Trigger.isInsert){}
            if(Trigger.isDelete){}
        }
    }
}