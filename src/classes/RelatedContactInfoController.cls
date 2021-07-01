public with sharing class RelatedContactInfoController {
    @AuraEnabled(Cacheable=true)
    public static Map<String, Object> getInitialData(Id caseId) {
        Map<String, Object> result = new Map<String, Object>();

        Id contactId = ContactSelector.getContactIdByCaseId(caseId);

        result.put('contactId', contactId);

        if (contactId != null) {
            Contact relatedContact = ContactSelector.getContactInfoById(contactId);
            result.put('descriptors', ProductDescriptor.getProductDescriptors());
            result.put('contact', relatedContact);
            result.put('productInfo', relatedContact.Product_Lookup__c != null
                    ? ProductSelector.getProductInfo(relatedContact.Product_Lookup__c)
                    : null);
        }

        return result;
    }
}