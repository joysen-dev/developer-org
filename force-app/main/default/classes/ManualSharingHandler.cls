public with sharing class ManualSharingHandler {
    //Part A: An Interface
    interface HandleTrigger{
        void handle(Student__c[] oldStu, Student__c[] newStu);
    }

    //Part B: A Dispatch Table
    static Type[] vTable = new Type[]{
        BeforeInsert.class,
        AfterInsert.class,
        BeforeUpdate.class,
        AfterUpdate.class,
        BeforeDelete.class,
        AfterDelete.class,
        DoNothing.class
    };


    public static Boolean systemUpdate = false;
    public static void execute(Student__c[] oldStu, Student__c[] newStu) {
        if (!systemUpdate) {
            ((HandleTrigger)(vTable[(Trigger.isBefore ? 0 : 1) + (Trigger.isInsert ? 0 : Trigger.isUpdate ? 2 : Trigger.isDelete ? 4 : 6)].newInstance())).handle(oldStu, newStu);
        }
    }
    
    class AfterInsert implements HandleTrigger{
        public void handle(Student__c[] oldStu, Student__c[] newStu){
            StudentSharingHierarchyUtility.giveAccessOnCreate(oldStu, newStu);
        }
    }
    
    class AfterUpdate implements HandleTrigger{
        public void handle(Student__c[] oldStu, Student__c[] newStu){
            // if(oldStu[0].Student__c != newStu[0].Student__c){
               	// StudentSharingHierarchyUtility.giveAccessOnUpdate(oldStu, newStu);
                StudentSharingHierarchyUtility.BST(oldStu, newStu);
            // }
        }
    }
    
    class BeforeDelete implements HandleTrigger{
        public void handle(Student__c[] oldStu, Student__c[] newStu){
             StudentSharingHierarchyUtility.giveAccessOnDelete(oldStu);
        }
    }

    class BeforeInsert implements HandleTrigger{
        public void handle(Student__c[] oldStu, Student__c[] newStu){
            //
        }
    }

    class BeforeUpdate implements HandleTrigger{
        public void handle(Student__c[] oldStu, Student__c[] newStu){
            
        }
    }
    
    class AfterDelete implements HandleTrigger{
        public void handle(Student__c[] oldStu, Student__c[] newStu){
            // 
        }
    }
    
    class DoNothing implements HandleTrigger{
        public void handle(Student__c[] oldStu, Student__c[] newStu){
            //
        }
    }
    
}