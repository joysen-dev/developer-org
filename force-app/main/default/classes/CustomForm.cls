public with sharing class CustomForm {

    @AuraEnabled
    public static string createLead(string fName, string lName, string company){

            Lead newLead = new Lead();
            newLead.FirstName = fName;
            newLead.LastName = lName;
            newLead.Company = company;

            // insert newLead;

            Database.SaveResult insertResult = Database.Insert(newLead, true);

            if(insertResult.isSuccess()){   
                return newLead.Id;
            }
            return 'Failed';

    }
}