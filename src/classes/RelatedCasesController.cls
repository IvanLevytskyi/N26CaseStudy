/**
 * Controller class for LWC component called relatedCases
 */
public with sharing class RelatedCasesController {
    /**
     * @description get initial data for LWC component
     * @param caseId - Id of case record
     *
     * @return map of initial data: contactId, contact information,
     * all related open cases, reportId
     */
    @AuraEnabled(Cacheable=true)
    public static Map<String, Object> getInitialData(Id caseId) {
        Map<String, Object> result = new Map<String, Object>();

        Id contactId = ContactSelector.getContactIdByCaseId(caseId);

        result.put('contactId', String.valueOf(contactId));
        result.put('contactInfo', ContactSelector.getContactInfoById(contactId));
        result.put('relatedOpenCases', CaseSelector.getOpenRelatedCasesByContactId(contactId));
        result.put('reportId', ReportSelector.getReportIdByDeveloperName(Constants.ALL_CASES_REPORT_NAME));

        return result;
    }
}