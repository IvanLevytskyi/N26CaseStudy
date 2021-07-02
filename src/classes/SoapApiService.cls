/**
 * Common class for SOAP Web Service
 */
global with sharing class SoapApiService {
    /**
     * @description SOAP web method for retrieving contact info by external id
     * @param externalId - info by external id
     *
     * @return Contact information
     */
    webService static Contact getContactInfo(String externalId) {
        if (String.isBlank(externalId)) {
            // TODO use custom label
            throw new CustomException('The following parameters are required: externalId!');
        }

        return ContactSelector.getContactByExternalId(externalId);
    }

    /**
     * @description SOAP web method for upserting contact info by external id
     * @param externalId - external id of contact record
     * @param firstName - first name to upsert
     * @param lastName - last name to upsert
     * @return Contact information of a new contact or existing one (depends on externalId)
     */
    webService static Contact upsertContactInfo(String externalId, String firstName, String lastName) {
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
}