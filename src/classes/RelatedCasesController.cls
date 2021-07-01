public with sharing class RelatedCasesController {
    // TODO Move to Constants
    public static final String ALL_CASES_REPORT_NAME = 'All_Related_Cases_wfg';

    @AuraEnabled(Cacheable=true)
    public static Map<String, Object> getInitialData(Id caseId) {
        Map<String, Object> result = new Map<String, Object>();

        Id contactId = ContactSelector.getContactIdByCaseId(caseId);

        result.put('contactId', String.valueOf(contactId));
        result.put('contactInfo', ContactSelector.getContactInfoById(contactId));
        result.put('relatedOpenCases', CaseSelector.getOpenRelatedCasesByContactId(contactId));
        result.put('reportId', ReportSelector.getReportIdByDeveloperName(ALL_CASES_REPORT_NAME));

        return result;
    }
}