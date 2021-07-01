public inherited sharing class CaseSelector {
    public enum CASE_TYPE {
        Open, Closed, All
    }

    public static Case getCaseInfo(Id caseId) {
        return [SELECT Id, Subject FROM Case WHERE Id = :caseId];
    }

    public static Integer getNumberOfAllCasesByContactId(Id contactId) {
        return [SELECT COUNT() FROM Case WHERE ContactId = :contactId];
    }

    public static Integer getNumberOfOpenCasesByContactId(Id contactId) {
        return [SELECT COUNT() FROM Case WHERE ContactId = :contactId AND IsClosed = FALSE];
    }

    public static Integer getNumberOfClosedCasesByContactId(Id contactId) {
        return [SELECT COUNT() FROM Case WHERE ContactId = :contactId AND IsClosed = TRUE];
    }

    public static List<Case> getAllRelatedCasesByContactId(Id contactId) {
        return getCasesByContactId(contactId, CASE_TYPE.All);
    }

    public static List<Case> getOpenRelatedCasesByContactId(Id contactId) {
        return getCasesByContactId(contactId, CASE_TYPE.Open);
    }

    public static List<Case> getClosedRelatedCasesByContactId(Id contactId) {
        return getCasesByContactId(contactId, CASE_TYPE.Closed);
    }

    private static List<Case> getCasesByContactId(Id contactId, CASE_TYPE caseType) {
        String query = 'SELECT Id, CaseNumber, Subject, CreatedDate FROM Case WHERE ContactId = :contactId';

        switch on caseType {
            when Open {
                query += ' AND IsClosed = FALSE';
            }
            when Closed {
                query += ' AND IsClosed = TRUE';
            }
        }

        return Database.query(query);
    }
}