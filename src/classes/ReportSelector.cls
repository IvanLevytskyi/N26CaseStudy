public inherited sharing class ReportSelector {
    public static Id getReportIdByDeveloperName(String developerName) {
        developerName = String.escapeSingleQuotes(developerName);
        return [SELECT Id FROM Report WHERE DeveloperName = :developerName]?.Id;
    }
}