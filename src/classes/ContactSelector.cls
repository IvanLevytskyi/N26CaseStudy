public inherited sharing class ContactSelector {
    public static Id getContactIdByCaseId(Id caseId) {
        return [SELECT ContactId FROM Case WHERE Id =:caseId]?.ContactId;
    }

    public static Contact getContactInfoById(Id contactId) {
        return [SELECT Id, FirstName, LastName, Email, Phone, Product__c,
                Home_Country__c, Product_Lookup__c, External_Id__c FROM Contact WHERE Id = :contactId];
    }

    public static Contact getContactByExternalId(String externalId) {
        return [SELECT Id, FirstName, LastName, Email, Phone, Product__c,
                Home_Country__c, Product_Lookup__c, External_Id__c FROM Contact WHERE External_Id__c = :externalId];
    }
}