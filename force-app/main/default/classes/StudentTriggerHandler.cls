public with sharing class StudentTriggerHandler {
    // public StudentTriggerHandler() {}
    public static void updateJoiningDate(List<Student__c> studentList){
        // Student__c stu = studentList[0];
        for(Student__c stu : studentList){
            stu.Joining_Date__c = System.today();
        }
    }

    // public static void createContact(List<Student__c> studentList){
    //     Contact con = new Contact();
    //     con.LastName = studentList[0].name;
    //     insert con;
    //     System.debug(con);
    // }

    @AuraEnabled(cacheable=true)
    public static List<Student__c> getStudentHierarchy(String stuId){
        try {
            return [SELECT Id, Name, Roll__c, Email__c, Subject__c, Student__c FROM Student__c WHERE Student__c = :stuId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static Student__c getCurrecntStudent(String stuId){
        try {
            return [SELECT Id, Name, Roll__c, Email__c, Subject__c FROM Student__c WHERE Student__c =:stuId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}