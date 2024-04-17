public class MockHttpResponseGenerator implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        // Create a mock HTTP response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"results": [{"geometry": {"location": {"lat": 37.7749, "lng": -122.4194}}}]}' );
        res.setStatusCode(200);
        return res;
    }
}