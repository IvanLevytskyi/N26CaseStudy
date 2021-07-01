public with sharing class CreateNewProductController {
    public static final String DEFAULT_CURRENCY = 'EUR';
    public static final String PRODUCT_FAMILY = 'Account';

    private static List<ProductDescriptor> PRODUCT_OPTION_DESCRIPTORS {
        get {
            if (PRODUCT_OPTION_DESCRIPTORS == null) {
                PRODUCT_OPTION_DESCRIPTORS = ProductDescriptor.getProductDescriptors();
            }
            return PRODUCT_OPTION_DESCRIPTORS;
        }
        set;
    }

    public class PicklistOption {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String value { get; set; }

        public PicklistOption(String lbl, String val) {
            label = lbl;
            value = val;
        }
    }

    @AuraEnabled(Cacheable=true)
    public static Map<String, Object> getInitialData() {
        Map<String, Object> result = new Map<String, Object>();

        result.put('countries', getCountryList());
        result.put('defaultCurrency', DEFAULT_CURRENCY);
        result.put('prodOptionDescriptors', ProductDescriptor.getProductDescriptors());
        result.put('currencyByCountry', getCurrencyByCountry());

        return result;
    }

    @AuraEnabled
    public static void createProducts(String productName, List<Map<String, Object>> products) {
        Product2 productTemplate = new Product2(
                Name = productName,
                Family = PRODUCT_FAMILY
        );

        List<Cascade> cascades = new List<Cascade>();

        for (Map<String, Object> product : products) {
            Product2 parentProduct = productTemplate.clone();

            parentProduct.ProductCode = productName + '-' + (product.containsKey('country') ? String.valueOf(product.get('country')) : '');
            parentProduct.IsActive = product.containsKey('isActive') ? Boolean.valueOf(product.get('isActive')) : true; // true - default value
            parentProduct.CurrencyIsoCode = product.containsKey('currencyCode') ? String.valueOf(product.get('currencyCode')) : DEFAULT_CURRENCY;

            Cascade cscd = new Cascade(parentProduct, 'Product__c', generateProductOptions(product));

            cascades.add(cscd);
        }

        Cascade.cascadeInsert(cascades);
    }

    private static List<PicklistOption> getCountryList() {
        List<PicklistOption> result = new List<PicklistOption>();
        for (PicklistEntry pe : Contact.Home_Country__c.getDescribe().getPicklistValues()) {
            if (pe.active) {
                result.add(new PicklistOption(pe.label, pe.value));
            }
        }
        return result;
    }

    private static Map<String, String> getCurrencyByCountry() {
        Map<String, String> result = new Map<String, String>();
        for (Country_Descriptor__mdt cd : CountryDescriptorSelector.getCountryDescriptors()) {
            result.put(cd.Label, cd.Currency_Code__c);
        }
        return result;
    }

    private static List<Product_Option__c> generateProductOptions(Map<String, Object> product) {
        List<Product_Option__c> result = new List<Product_Option__c>();

        for (ProductDescriptor pd : PRODUCT_OPTION_DESCRIPTORS) {
            if (product.containsKey(pd.productOptionName)) {

                Product_Option__c newProductOption = new Product_Option__c(
                        Name = pd.productOptionLabel,
                        Option_Type__c = pd.optionType
                );

                newProductOption.CurrencyIsoCode = CountryDescriptorSelector.CURRENCY_BY_COUNTRY.get((String)product.get('country'));

                if (product.containsKey(pd.productOptionName) && product.get(pd.productOptionName) != null) {
                    switch on pd.optionType {
                        when 'Currency' {
                            System.debug(pd.productOptionName);
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