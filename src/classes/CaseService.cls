/**
 * Service class for functionality related to Case object
 */
public inherited sharing class CaseService {
    /**
     * @description get id of contact record related to specified case
     * @param caseId - Id of case record
     *
     * @return id of contact record or null
     */
    public static Id getContactIdByCaseId(Id caseId) {
        // ?. (safe operator) in case there is no a case with such Id
        return [SELECT Id, ContactId FROM Case WHERE Id = :caseId]?.ContactId;
    }

    /**
     * @description get contact information related to specified case
     * @param caseId - Id of case record
     *
     * @return contact record
     */
    public static Contact getContactInfoByCaseId(Id caseId) {
        Id contactId = getContactIdByCaseId(caseId);

        return contactId == null
                ? null
                : ContactSelector.getContactInfoById(contactId);
    }
}