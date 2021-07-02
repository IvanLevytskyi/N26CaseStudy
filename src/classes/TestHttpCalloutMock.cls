/**
 * Test Http Callout Mock class for unit tests
 * Implements HttpCalloutMock
 */
global class TestHttpCalloutMock implements HttpCalloutMock {
    // global property for assigning response body
    global static String RESPONSE_BODY = 'TestBody';
    // global property for assigning response status code
    global static Integer RESPONSE_STATUS_CODE = 200;

    // Implemented respond method
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setBody(RESPONSE_BODY);
        response.setStatusCode(RESPONSE_STATUS_CODE);
        return response;
    }
}