public with sharing class ContactTriggerHandler {
    public void onBeforeInsert(List<Contact> newList) {
        assignProduct(newList);
    }

    public void onBeforeUpdate(List<Contact> newList, Map<Id, Contact> oldMap) {
        assignProduct(newList);
    }

    private void assignProduct(List<Contact> newList) {
        for (Contact con : newList) {
            if (ProductSelector.PRODUCT_BY_PRODUCT_CODE.containsKey(con.Product__c + '-' + con.Home_Country__c)) {
                con.Product_Lookup__c = ProductSelector.PRODUCT_BY_PRODUCT_CODE.get(con.Product__c + '-' + con.Home_Country__c).Id;
            }
        }
    }
}