/**
 * Selector class for Product_Option_Descriptor__mdt (Custom Metadata Type)
 */
public inherited sharing class ProductOptionDescriptorSelector {
    // get list of all Product_Option_Descriptor__mdt records
    public static List<Product_Option_Descriptor__mdt> getDescriptors() {
        return [SELECT Id, Label, DeveloperName, Option_Type__c,
                Label_instead_of_NULL__c, Is_Required__c FROM Product_Option_Descriptor__mdt];
    }
}