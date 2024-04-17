public with sharing class AccountQueueableApex implements Queueable {

    public List<Account> accList;
    public Id parentId;

    public AccountQueueableApex(List<Account> accountList, Id id) {
        this.accList = accountList;
        this.parentId = id;
    }

    public void execute(QueueableContext qc){
        for(Account acc : accList)
            acc.ParentId = parentId;
        
        update accList;
    }


}