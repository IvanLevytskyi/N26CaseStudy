/**
 * Controller class for LWC component called createNewProduct
 */
public with sharing class CreateNewProductController {
    // Constant for storing default currency iso code
    public static final String DEFAULT_CURRENCY = 'EUR';
    // Product family for banking contracts
    public static final String PRODUCT_FAMILY = 'Account';

    // Cached list of Product Descriptors
    private static List<ProductDescriptor> PRODUCT_OPTION_DESCRIPTORS {
        get {
            if (PRODUCT_OPTION_DESCRIPTORS == null) {
                PRODUCT_OPTION_DESCRIPTORS = ProductDescriptor.getProductDescriptors();
            }
            return PRODUCT_OPTION_DESCRIPTORS;
        }
        set;
    }

    // Class for Picklist options
    public class PicklistOption {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String value { get; set; }

        // Constructor
        public PicklistOption(String lbl, String val) {
            label = lbl;
            value = val;
        }
    }

    /**
     * @description get initial data for new product creation
     * @return initial data: list of countries, default currency,
     * product option descriptors, map of currencies by country
     */
    @AuraEnabled(Cacheable=true)
    public static Map<String, Object> getInitialData() {
        Map<String, Object> result = new Map<String, Object>();

        result.put('countries', getCountryList());
        result.put('defaultCurrency', DEFAULT_CURRENCY);
        result.put('prodOptionDescriptors', ProductDescriptor.getProductDescriptors());
        result.put('currencyByCountry', getCurrencyByCountry());

        return result;
    }

    /**
     * @description create new product
     * @param productName name of a new Product
     * @param products list of product options
     */
    @AuraEnabled
    public static void createProducts(String productName, List<Map<String, Object>> products) {
        // Product template for cloning
        Product2 productTemplate = new Product2(
                Name = productName,
                Family = PRODUCT_FAMILY
        );

        // Create cascade for insertion parents (products) and children (product information) records
        List<Cascade> cascades = new List<Cascade>();

        for (Map<String, Object> product : products) {
            // Clone product template for a new product
            Product2 parentProduct = productTemplate.clone();

            // Generate Product Code
            parentProduct.ProductCode = productName + '-' + (product.containsKey('country') ? String.valueOf(product.get('country')) : '');
            parentProduct.IsActive = product.containsKey('isActive') ? Boolean.valueOf(product.get('isActive')) : true; // true - default value
            parentProduct.CurrencyIsoCode = product.containsKey('currencyCode') ? String.valueOf(product.get('currencyCode')) : DEFAULT_CURRENCY;

            // Generate child records
            Cascade cscd = new Cascade(parentProduct, 'Product__c', generateProductOptions(product));

            cascades.add(cscd);
        }

        // Cascade insert
        Cascade.cascadeInsert(cascades);
    }

    /**
     * @description get list of countries
     * @return list of countries picklist options
     */
    private static List<PicklistOption> getCountryList() {
        List<PicklistOption> result = new List<PicklistOption>();
        for (PicklistEntry pe : Contact.Home_Country__c.getDescribe().getPicklistValues()) {
            if (pe.active) {
                result.add(new PicklistOption(pe.label, pe.value));
            }
        }
        return result;
    }

    /**
     * @description get map of currency iso codes by countries
     * @return map of currencies by country
     */
    private static Map<String, String> getCurrencyByCountry() {
        Map<String, String> result = new Map<String, String>();
        for (Country_Descriptor__mdt cd : CountryDescriptorSelector.getCountryDescriptors()) {
            result.put(cd.Label, cd.Currency_Code__c);
        }
        return result;
    }

    /**
     * @description generate Product Options based on input from UI
     * @param product - product information
     *
     * @return list of Product Options
     */
    private static List<Product_Option__c> generateProductOptions(Map<String, Object> product) {
        List<Product_Option__c> result = new List<Product_Option__c>();

        for (ProductDescriptor pd : PRODUCT_OPTION_DESCRIPTORS) {
            if (product.containsKey(pd.productOptionName)) {

                // Generate Product Option based on user's input & product option descriptors
                Product_Option__c newProductOption = new Product_Option__c(
                        Name = pd.productOptionLabel,
                        Option_Type__c = pd.optionType
                );

                newProductOption.CurrencyIsoCode = CountryDescriptorSelector.CURRENCY_BY_COUNTRY.get((String)product.get('country'));

                // Populate appropriate field based on option type
                if (product.containsKey(pd.productOptionName) && product.get(pd.productOptionName) != null) {
                    switch on pd.optionType {
                        when 'Currency' {
                            newProductOption.Currency_Value__c = Decimal.valueOf((String)product.get(pd.productOptionName));
                        }
                        when 'Percent' {
                            newProductOption.Percent_Value__c = Decimal.valueOf((String)product.get(pd.productOptionName));
                        }
                    }
                }

                result.add(
                        newProductOption
                );
            }
        }

        return result;
    }
}