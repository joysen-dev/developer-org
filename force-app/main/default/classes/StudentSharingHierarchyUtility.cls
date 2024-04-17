public with sharing class StudentSharingHierarchyUtility {
    public StudentSharingHierarchyUtility() {
    }
    
    public static void giveAccessOnCreate(Student__c[] oldStu, Student__c[] newStu) {
        Integer level = 1;
        List<String> parentStudentsOwnerId = new List<String>();
        List<Student__c> immediateParent = StudentSharingHierarchyUtility.ImmeDiateParent(newStu[0].Student__c);
        Student__Share manualSharing = new Student__Share();
        List<Student__Share> manualSharings = new List<Student__Share>();
        
        if(!parentStudentsOwnerId.contains(immediateParent[0].OwnerId) || newStu[0].OwnerId != immediateParent[0].OwnerId){
            manualSharings.add(new Student__Share(ParentId = newStu[0].Id, AccessLevel = 'Edit', RowCause = 'Manual', UserOrGroupId = immediateParent[0].OwnerId));
            parentStudentsOwnerId.add(immediateParent[0].OwnerId);
        }
        
        while (immediateParent[0].Student__c != NULL && level <= 12 && immediateParent.size() > 0) {
            level++;
            immediateParent = StudentSharingHierarchyUtility.ImmeDiateParent(immediateParent[0].Student__c);
            
            if(!parentStudentsOwnerId.contains(immediateParent[0].OwnerId) || newStu[0].OwnerId != immediateParent[0].OwnerId){
                manualSharings.add(new Student__Share(ParentId = newStu[0].Id, AccessLevel = 'Edit', RowCause = 'Manual', UserOrGroupId = immediateParent[0].OwnerId));
                parentStudentsOwnerId.add(immediateParent[0].OwnerId);
            }
        }
        Database.SaveResult[] manualSharingsInsertResult = Database.insert(manualSharings, false);
        System.debug('manualSharings : ' + JSON.serializePretty(manualSharings));
        System.debug('Insertion Restult : ' + JSON.serializePretty(manualSharingsInsertResult));
    }
    
    public static void giveAccessOnUpdate(Student__c[] oldStu, Student__c[] newStu){
        Student__Share[] manualSharings = [select Id, AccessLevel, RowCause from Student__Share WHERE ParentId = :newStu[0].Id AND RowCause = 'Manual'];
        Database.DeleteResult[] manualSharingsDeletetResult = Database.delete(manualSharings, false);
        giveAccessOnCreate(oldStu, newStu);
    }

    public static void giveAccessOnDelete(Student__c[] oldStu){
        Student__c immediateParent = StudentSharingHierarchyUtility.ImmeDiateParent(oldStu[0].Student__c)[0];
        List<Student__c> immediateChilds = [SELECT Id, Name, Student__c, OwnerId FROM Student__c WHERE Student__c = :oldStu[0].Id];
        List<Student__c> updateChilds = new List<Student__c>();
        
        for(Student__c immediateChild : immediateChilds){
            immediateChild.Student__c = immediateParent.Id;
            updateChilds.add(immediateChild);
		}
        Database.update(updateChilds, true);

        StudentSharingHierarchyUtility.BST(oldStu, oldStu);
    }

    // Binary Search tree --> For all the childs of triggred element
    public static void BST(Student__c[] oldStu, Student__c[] newStu){
        List<String> stack = new List<String>();
        List<Student__c> currentStudent = new List<Student__c>();
        stack.add(newStu[0].Id);
        while(stack.size() > 0){
            if(stack == NULL) return;
            Integer currentIndex = stack.size() - 1;
            currentStudent = getDetails(stack[currentIndex]);
            StudentSharingHierarchyUtility.giveAccessOnUpdate(currentStudent, currentStudent);
            
            if(ImmeDiateChild(stack[currentIndex]) != NULL)
                stack.addAll(ImmeDiateChild(stack[currentIndex]));
            
            stack.remove(currentIndex);
        }
    }

    public static List<Student__c> ImmeDiateParent(String parentId){
        return [SELECT Id, Name, Student__c, OwnerId FROM Student__c WHERE Id = :parentId];
    }
    public static List<Student__c> getDetails(String Id){
        return [SELECT Id, Name, Student__c, OwnerId FROM Student__c WHERE Id = :Id];
    }
    public static List<String> ImmeDiateChild(String Id){
        List<Student__c> students = [SELECT Id FROM Student__c WHERE Student__c = :Id];
        List<String> studentIds = new List<String>();
        for(Student__c student : students)
            studentIds.add(student.Id);
        return studentIds;
    }    
}