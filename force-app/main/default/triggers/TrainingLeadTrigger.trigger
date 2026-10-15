trigger TrainingLeadTrigger on Lead (before insert, before update) {
    TrainingLeadTriggerHandler.handle(Trigger.new, Trigger.oldMap, Trigger.isInsert);
}