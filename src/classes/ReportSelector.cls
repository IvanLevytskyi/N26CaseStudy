/**
 * Selector class for Reports
 */
public inherited sharing class ReportSelector {
    /**
     * @description get report id by
     * @param developerName - DeveloperName of report
     *
     * @return id of report
     */
    public static Id getReportIdByDeveloperName(String developerName) {
        developerName = String.escapeSingleQuotes(developerName);
        return [SELECT Id FROM Report WHERE DeveloperName = :developerName]?.Id;
    }
}