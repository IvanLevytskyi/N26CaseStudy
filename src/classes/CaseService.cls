public inherited sharing class CaseService {
    // ?. in case there is no a case with such Id
    // TODO Lazy loading and caching
    public static Id getContactIdByCaseId(Id caseId) {
        return [SELECT Id, ContactId FROM Case WHERE Id = :caseId]?.ContactId;
    }

    public static Contact getContactInfoByCaseId(Id caseId) {
        Id contactId = getContactIdByCaseId(caseId);

        return contactId == null
                ? null
                : ContactSelector.getContactInfoById(contactId);
    }
}