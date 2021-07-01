global class TestHttpCalloutMock implements HttpCalloutMock {
    global static String RESPONSE_BODY = 'TestBody';
    global static Integer RESPONSE_STATUS_CODE = 200;

    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setBody(RESPONSE_BODY);
        response.setStatusCode(RESPONSE_STATUS_CODE);
        return response;
    }
}