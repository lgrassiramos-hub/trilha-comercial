@IsTest
public class ViaCepHttpMock implements HttpCalloutMock {

    private Integer statusCode;
    private String body;

    public ViaCepHttpMock(Integer statusCode, String body) {
        this.statusCode = statusCode;
        this.body = body;
    }

    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        res.setBody(body);
        res.setHeader('Content-Type', 'application/json');
        return res;
    }
}