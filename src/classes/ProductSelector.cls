public with sharing class ProductSelector {
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

    public static List<Product2> getAccountProducts() {
        return [SELECT Id, Name, ProductCode, Family, CurrencyIsoCode, Description FROM Product2 WHERE Family = 'Account'];
    }

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