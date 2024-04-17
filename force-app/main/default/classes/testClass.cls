public class testClass {
    public static void main(){
        List<Account> ids = [SELECT Id FROM Account];
        // List<Account> accs = [SELECT Id, Name, (SELECT Id, Name FROM Contacts) FROM Account WHERE Id IN: ids];
        System.debug(ids);
    }
}