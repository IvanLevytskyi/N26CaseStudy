/**
 * Selector class for Contact SObject
 */
public inherited sharing class ContactSelector {
    /**
     * @description get id of contact record by id of related case
     * @param caseId - Id of case record
     *
     * @return Id of contact record
     */
    public static Id getContactIdByCaseId(Id caseId) {
        return [SELECT ContactId FROM Case WHERE Id =:caseId]?.ContactId;
    }

    /**
     * @description get contact information by record id
     * @param contactId - Id of contact record
     *
     * @return contact record
     */
    public static Contact getContactInfoById(Id contactId) {
        return [SELECT Id, FirstName, LastName, Email, Phone, Product__c,
                Home_Country__c, Product_Lookup__c, External_Id__c FROM Contact WHERE Id = :contactId];
    }

    /**
     * @description get contact information by external id
     * @param externalId - external id of contact record
     *
     * @return contact record
     */
    public static Contact getContactByExternalId(String externalId) {
        return [SELECT Id, FirstName, LastName, Email, Phone, Product__c,
                Home_Country__c, Product_Lookup__c, External_Id__c FROM Contact WHERE External_Id__c = :externalId];
    }
}