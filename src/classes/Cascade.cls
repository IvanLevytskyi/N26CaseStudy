/**
 * This class is designed for cascade insert
 */
public with sharing class Cascade {
    // Parent record
    public SObject parentRecord { get; set; }
    // List of related child records
    public List<SObject> childRecords { get; set; }
    // Api name of lookup/master-detail field that links parent with child records
    public String childToParentFieldName { get; set; }

    // Parameterized constructor
    public Cascade(SObject parentRec, String childToParentField, List<SObject> childRecords) {
        this.parentRecord = parentRec;
        this.childToParentFieldName = childToParentField;
        this.childRecords = childRecords;
    }

    /**
     * @description Cascade Insert of one parent record and related child records
     * @param cscd - instance of Cascade class
     */
    public static void cascadeInsert(Cascade cscd) {
        // generate a savepoint
        Savepoint sp = Database.setSavepoint();
        try {
            // insert parent record first
            insert cscd.parentRecord;

            // populate lookup/master-detail field on child records
            for (SObject child : cscd.childRecords) {
                child.put(cscd.childToParentFieldName, cscd.parentRecord.Id);
            }

            // insert child records
            insert cscd.childRecords;
        } catch (Exception ex) {
            // In case of exception - rollback
            Database.rollback(sp);
        }
    }

    /**
     * @description Cascade insert of many parent records and related child records
     * @param cascades - list of Cascade instances
     */
    public static void cascadeInsert(List<Cascade> cascades) {
        // generate a savepoint
        Savepoint sp = Database.setSavepoint();
        try {
            // get list of all parent records
            List<SObject> parentRecords = new List<SObject>();

            for (Cascade cscd : cascades) {
                parentRecords.add(cscd.parentRecord);
            }

            // insert parent records
            insert parentRecords;

            // get list of all child records
            List<SObject> childRecords = new List<SObject>();

            for (Integer i = 0; i < cascades.size(); i++) {
                for (SObject child : cascades[i].childRecords) {
                    // populate lookup/master-detail field on child records
                    child.put(cascades[i].childToParentFieldName, parentRecords[i].Id);
                    childRecords.add(child);
                }
            }

            // insert child records
            insert childRecords;
        } catch (Exception ex) {
            // In case of exception - rollback
            Database.rollback(sp);
        }
    }
}