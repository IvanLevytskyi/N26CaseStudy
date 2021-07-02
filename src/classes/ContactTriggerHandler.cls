/**
 * Trigger handler class for apex trigger on Contact object
 */
public with sharing class ContactTriggerHandler {
    /**
     * @description before insert handler
     * @param newList - Trigger.new
     */
    public void onBeforeInsert(List<Contact> newList) {
        assignProduct(newList);
    }

    /**
     * @description before update handler
     * @param newList - Trigger.new
     * @param oldMap - Trigger.oldMap
     */
    public void onBeforeUpdate(List<Contact> newList, Map<Id, Contact> oldMap) {
        assignProduct(newList);
    }

    /**
     * @description populate Product_Lookup__c field on the contact record based on Product__c and Home_Country__c fields
     * @param newList - Trigger.new
     */
    private void assignProduct(List<Contact> newList) {
        for (Contact con : newList) {
            if (ProductSelector.PRODUCT_BY_PRODUCT_CODE.containsKey(con.Product__c + '-' + con.Home_Country__c)) {
                con.Product_Lookup__c = ProductSelector.PRODUCT_BY_PRODUCT_CODE.get(con.Product__c + '-' + con.Home_Country__c).Id;
            }
        }
    }
}