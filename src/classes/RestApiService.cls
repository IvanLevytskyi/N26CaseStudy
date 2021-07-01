@RestResource(urlMapping='/N26RestApi/*')
global with sharing class RestApiService {

    // !!! WORK IN PROGRESS !!!
    @HttpGet
    global static Contact getContactInfo() {
        // TODO get String externalId from URL
        return new Contact();
    }
}