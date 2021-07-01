public inherited sharing class ProductOptionDescriptorSelector {
    public static List<Product_Option_Descriptor__mdt> getDescriptors() {
        return [SELECT Id, Label, DeveloperName, Option_Type__c,
                Label_instead_of_NULL__c, Is_Required__c FROM Product_Option_Descriptor__mdt];
    }
}