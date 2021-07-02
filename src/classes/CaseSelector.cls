/**
 * Selector class for Case SObject
 */
public inherited sharing class CaseSelector {
    // enum of Case Types: Open, Closed, All
    public enum CASE_TYPE {
        Open, Closed, All
    }

    /**
     * @description get case info by record id
     * @param caseId - Id of case record
     *
     * @return case record with specified Id
     */
    public static Case getCaseInfo(Id caseId) {
        return [SELECT Id, Subject FROM Case WHERE Id = :caseId];
    }

    /**
     * @description get number of all cases related to specified contact record
     * @param contactId - Id of contact record
     *
     * @return number of cases
     */
    public static Integer getNumberOfAllCasesByContactId(Id contactId) {
        return [SELECT COUNT() FROM Case WHERE ContactId = :contactId];
    }

    /**
     * @description get number of all open cases related to specified contact record
     * @param contactId - Id of contact record
     *
     * @return number of cases
     */
    public static Integer getNumberOfOpenCasesByContactId(Id contactId) {
        return [SELECT COUNT() FROM Case WHERE ContactId = :contactId AND IsClosed = FALSE];
    }

    /**
     * @description get number of all closed related to specified contact record
     * @param contactId - Id of contact record
     *
     * @return number of cases
     */
    public static Integer getNumberOfClosedCasesByContactId(Id contactId) {
        return [SELECT COUNT() FROM Case WHERE ContactId = :contactId AND IsClosed = TRUE];
    }

    /**
     * @description get all cases related to specified contact record
     * @param contactId - Id of contact record
     *
     * @return list of cases
     */
    public static List<Case> getAllRelatedCasesByContactId(Id contactId) {
        return getCasesByContactId(contactId, CASE_TYPE.All);
    }

    /**
     * @description get all open cases related to specified contact record
     * @param contactId - Id of contact record
     *
     * @return list of cases
     */
    public static List<Case> getOpenRelatedCasesByContactId(Id contactId) {
        return getCasesByContactId(contactId, CASE_TYPE.Open);
    }

    /**
     * @description get all closed cases related to specified contact record
     * @param contactId - Id of contact record
     *
     * @return list of cases
     */
    public static List<Case> getClosedRelatedCasesByContactId(Id contactId) {
        return getCasesByContactId(contactId, CASE_TYPE.Closed);
    }

    /**
     * @description get all cases related to specified contact record with specific case type
     * @param contactId - Id of contact record
     * @param caseType - type of case: Open, Closed, All
     *
     * @return list of cases
     */
    private static List<Case> getCasesByContactId(Id contactId, CASE_TYPE caseType) {
        // Prepare string for dynamic SOQL
        String query = 'SELECT Id, CaseNumber, Subject, CreatedDate FROM Case WHERE ContactId = :contactId';

        // Add filter based on caseType
        switch on caseType {
            when Open {
                query += ' AND IsClosed = FALSE';
            }
            when Closed {
                query += ' AND IsClosed = TRUE';
            }
        }

        // Perform dynamic SOQL
        return Database.query(query);
    }
}