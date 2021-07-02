/**
 * Selector class for Product2 SObject
 */
public with sharing class ProductSelector {
    // Cached map of products by product code
    public static Map<String, Product2> PRODUCT_BY_PRODUCT_CODE {
        get {
            if (PRODUCT_BY_PRODUCT_CODE == null) {
                Map<String, Product2> result = new Map<String, Product2>();

                for (Product2 product : getAccountProducts()) {
                    result.put(product.ProductCode, product);
                }

                PRODUCT_BY_PRODUCT_CODE = result;
            }
            return PRODUCT_BY_PRODUCT_CODE;
        }
        set;
    }

    /**
     * @description get list of all products with 'Account' product family
     * @return list of Product2s
     */
    public static List<Product2> getAccountProducts() {
        return [SELECT Id, Name, ProductCode, Family, CurrencyIsoCode, Description FROM Product2 WHERE Family = 'Account'];
    }

    /**
     * @description get product info with all related product options
     * @param productId - Id of Product record
     *
     * @return product record with all product options
     */
    public static Product2 getProductInfo(Id productId) {
        List<Product2> products = [
                SELECT Id, Name, ProductCode, CurrencyIsoCode, (
                        SELECT Id, Name, Option_Type__c, Currency_Value__c, Percent_Value__c
                        FROM Product_Options__r
                )
                FROM Product2
                WHERE Id = :productId
        ];

        return !products.isEmpty() ? products[0] : null;
    }
}