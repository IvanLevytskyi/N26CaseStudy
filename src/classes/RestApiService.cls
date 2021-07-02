/**
 * Common class for REST Web Service
 */
@RestResource(urlMapping='/N26RestApi/*')
global with sharing class RestApiService {
    /**
     * @description HttpGet method for retrieving contact info by external id
     * @return Contact information
     */
    @HttpGet
    global static Contact getContactInfo() {
        String externalId = getParamFromUrl('externalId');

        if (String.isBlank(externalId)) {
            // TODO use custom label
            throw new CustomException('The following parameters are required: externalId!');
        }

        return ContactSelector.getContactByExternalId(externalId);
    }

    /**
     * @description HttpGet method for upserting contact info by external id
     * @param externalId - external id of contact record
     * @param firstName - first name to upsert
     * @param lastName - last name to upsert
     * @return Contact information of a new contact or existing one (depends on externalId)
     */
    @HttpPut
    global static Contact upsertContactInfo(String externalId, String firstName, String lastName) {
        Contact contactToUpsert = new Contact(
                External_Id__c = externalId,
                FirstName = firstName,
                LastName = lastName
        );

        upsert contactToUpsert;

        // TODO it is good practice to retrieve records after DML operations
        // because it can be changed by trigger or declarative automation tools
        return contactToUpsert;
    }

    /**
     * @description get params from URL
     * @param paramName - name of the parameter
     *
     * @return the parameter value
     */
    private static String getParamFromUrl(String paramName) {
        return RestContext.request.params.containsKey(paramName)
                ? RestContext.request.params.get(paramName)
                : null;
    }
}