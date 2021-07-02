/**
 * Test Data Factory class for unit tests
 */
public with sharing class TestDataFactory {

    // Test Data Factory method signature
    // numberOfRecords - number of records to create
    // toInsert - insert or not records
    // product2Id (only for createProductOptions) - id of related product

    public static List<Contact> createContacts(Integer numberOfRecords, Boolean toInsert) {
        List<Contact> result = new List<Contact>();

        for (Integer i = 0; i < numberOfRecords; i++) {
            result.add(
                    new Contact(
                            FirstName = 'John',
                            LastName = 'Smith ' + i
                    )
            );
        }

        if (toInsert) {
            insert result;
        }
        return result;
    }

    public static List<Case> createCases(Integer numberOfRecords, Boolean toInsert) {
        List<Case> result = new List<Case>();

        for (Integer i = 0; i < numberOfRecords; i++) {
            result.add(
                    new Case(
                            Subject = 'Test Subject ' + i,
                            Origin = 'Email',
                            Status = 'New'
                    )
            );
        }
        if (toInsert) {
            insert result;
        }
        return result;
    }

    public static List<Product_Option__c> createProductOptions(Integer numberOfRecords, Boolean toInsert, Id product2Id) {
        List<Product_Option__c> result = new List<Product_Option__c>();

        for (Integer i = 0; i < numberOfRecords; i++) {
            Integer prodOptType = Math.mod(i, 2);

            result.add(
                    new Product_Option__c(
                            Name = 'Product Option ' + i,
                            Option_Type__c = (prodOptType == 0 ? 'Currency' : 'Percent'),
                            Currency_Value__c = (prodOptType == 0 ? i : null),
                            Percent_Value__c = (prodOptType == 0 ? null : i * 0.01),
                            Product__c = product2Id
                    )
            );
        }

        if (toInsert) {
            insert result;
        }
        return result;
    }

    public static List<Product2> createProducts(Integer numberOfRecords, Boolean toInsert) {
        List<Product2> result = new List<Product2>();

        Product2 productTemplate = new Product2 (
                Name = 'Account Product ',
                ProductCode = 'AccountProduct',
                IsActive = true
        );

        for (Integer i = 0; i < numberOfRecords; i++) {
            Product2 newProduct = productTemplate.clone();
            newProduct.Name += i;
            newProduct.ProductCode += i;

            result.add(
                    newProduct
            );
        }

        if (toInsert) {
            insert result;
        }
        return result;
    }
}