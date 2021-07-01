trigger ContactTrigger on Contact (before insert, before update) {
    ContactTriggerHandler triggerHandler = new ContactTriggerHandler();
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            triggerHandler.onBeforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            triggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}