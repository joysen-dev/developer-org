@isTest
public class FetchDataFromApiMock implements HttpCalloutMock{
    private Integer code;
    private String status;
    private String body;
    private Map<String, String> responseHeader;

    public FetchDataFromApiMock(Integer code, String status, String body, Map<String, String> responseHeader) {
        this.code = code;
        this.status = status;
        this.body = body;
        this.responseHeader = responseHeader;
    }

    public HTTPResponse Respond (HttpRequest req){
        HTTPResponse res = new HTTPResponse();
        for (String key : this.responseHeader.keySet()) {
            res.setHeader(key, this.responseHeader.get(key));
        }
        res.setBody(this.body);
        res.setStatusCode(this.code);
        res.setStatus(this.status);

        return res;
    }

}