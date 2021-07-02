/**
 * Product Descriptor
 */
public with sharing class ProductDescriptor {
    // Product Option Label
    @AuraEnabled
    public String productOptionLabel { get; set; }
    // Product Option Name
    @AuraEnabled
    public String productOptionName { get; set; }
    // Displaying Label instead of null value
    @AuraEnabled
    public String labelInsteadOfNull { get; set; }
    // Option type: Currency, Percent
    @AuraEnabled
    public String optionType { get; set; }
    // Is this product option required for product creation
    @AuraEnabled
    public Boolean isRequired { get; set; }

    // Constructor
    // Create ProductDescriptor based on Product_Option_Descriptor__mdt
    public ProductDescriptor(Product_Option_Descriptor__mdt productOptionDescriptor) {
        this.productOptionLabel = productOptionDescriptor.Label;
        this.productOptionName = productOptionDescriptor.DeveloperName;
        this.labelInsteadOfNull = productOptionDescriptor.Label_instead_of_NULL__c;
        this.optionType = productOptionDescriptor.Option_Type__c;
        this.isRequired = productOptionDescriptor.Is_Required__c;
    }

    /**
     * @description get all product descriptors
     * @return List of ProductDescriptors
     */
    public static List<ProductDescriptor> getProductDescriptors() {
        List<ProductDescriptor> result = new List<ProductDescriptor>();
        for (Product_Option_Descriptor__mdt pd : ProductOptionDescriptorSelector.getDescriptors()) {
            result.add(new ProductDescriptor(pd));
        }
        return result;
    }
}