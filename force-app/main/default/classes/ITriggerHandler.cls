public interface ITriggerHandler {
    void beforeUpdate(List<sObject> newList, List<sObject> oldList);
}