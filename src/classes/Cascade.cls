public with sharing class Cascade {
    public SObject parentRecord { get; set; }
    public List<SObject> childRecords { get; set; }
    public String childToParentFieldName { get; set; }

    public Cascade(SObject parentRec, String childToParentField, List<SObject> childRecords) {
        this.parentRecord = parentRec;
        this.childToParentFieldName = childToParentField;
        this.childRecords = childRecords;
    }

    public static void cascadeInsert(Cascade cscd) {
        Savepoint sp = Database.setSavepoint();
        try {
            insert cscd.parentRecord;

            for (SObject child : cscd.childRecords) {
                child.put(cscd.childToParentFieldName, cscd.parentRecord.Id);
            }

            insert cscd.childRecords;
        } catch (Exception ex) {
            Database.rollback(sp);
        }
    }

    public static void cascadeInsert(List<Cascade> cascades) {
        Savepoint sp = Database.setSavepoint();
        try {
            List<SObject> parentRecords = new List<SObject>();

            for (Cascade cscd : cascades) {
                parentRecords.add(cscd.parentRecord);
            }

            insert parentRecords;

            List<SObject> childRecords = new List<SObject>();

            for (Integer i = 0; i < cascades.size(); i++) {
                for (SObject child : cascades[i].childRecords) {
                    child.put(cascades[i].childToParentFieldName, parentRecords[i].Id);
                    childRecords.add(child);
                }
            }

            insert childRecords;
        } catch (Exception ex) {
            Database.rollback(sp);
        }
    }
}