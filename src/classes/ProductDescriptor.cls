public with sharing class ProductDescriptor {
    @AuraEnabled
    public String productOptionLabel { get; set; }
    @AuraEnabled
    public String productOptionName { get; set; }
    @AuraEnabled
    public String labelInsteadOfNull { get; set; }
    @AuraEnabled
    public String optionType { get; set; }
    @AuraEnabled
    public Boolean isRequired { get; set; }

    public ProductDescriptor(Product_Option_Descriptor__mdt productOptionDescriptor) {
        this.productOptionLabel = productOptionDescriptor.Label;
        this.productOptionName = productOptionDescriptor.DeveloperName;
        this.labelInsteadOfNull = productOptionDescriptor.Label_instead_of_NULL__c;
        this.optionType = productOptionDescriptor.Option_Type__c;
        this.isRequired = productOptionDescriptor.Is_Required__c;
    }

    public static List<ProductDescriptor> getProductDescriptors() {
        List<ProductDescriptor> result = new List<ProductDescriptor>();
        for (Product_Option_Descriptor__mdt pd : ProductOptionDescriptorSelector.getDescriptors()) {
            result.add(new ProductDescriptor(pd));
        }
        return result;
    }
}