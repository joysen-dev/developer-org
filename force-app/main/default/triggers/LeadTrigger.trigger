trigger LeadTrigger on Lead (before insert, before update) {
    
    
    if(Trigger.isBefore && Trigger.isInsert){
        LeadTriggerController.parseJSONResponse(Trigger.new[0], Trigger.new[0]);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        LeadTriggerController.parseJSONResponse(Trigger.new[0], Trigger.old[0]);
    }
    
}