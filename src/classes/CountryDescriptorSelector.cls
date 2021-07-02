/**
 * Selector class for Country_Descriptor__mdt (Custom Metadata Type)
 */
public inherited sharing class CountryDescriptorSelector {
    /**
     * @description get all Country_Descriptor__mdt records
     * @return list of country descriptors
     */
    public static List<Country_Descriptor__mdt> getCountryDescriptors() {
        return [SELECT Label, DeveloperName, Currency_Code__c FROM Country_Descriptor__mdt];
    }

    /**
     * @description cached map which contains countries as keys and currencies as values
     */
    public static Map<String, String> CURRENCY_BY_COUNTRY {
        get {
            if (CURRENCY_BY_COUNTRY == null) {
                Map<String, String> result = new Map<String, String>();

                for (Country_Descriptor__mdt cd : getCountryDescriptors()) {
                    result.put(cd.DeveloperName, cd.Currency_Code__c);
                }

                CURRENCY_BY_COUNTRY = result;
            }
            return CURRENCY_BY_COUNTRY;
        }

        set;
    }
}