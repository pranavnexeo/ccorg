@isTest
public class cc_imp_3d_VatAndTax_HttpResponse implements HttpCalloutMock {

    protected Integer code;
    protected String status;
    protected String body;
    protected Map<String, String> responseHeaders;
    protected Boolean useVat;

    public cc_imp_3d_VatAndTax_HttpResponse(Integer code, String status, String body, Map<String, String> responseHeaders, Boolean useVat) {
        this.code = code;
        this.status = status;
        this.body = body;
        this.responseHeaders = responseHeaders;
        this.useVat = useVat;
    }

    static Boolean firstRequest = true;
    public HTTPResponse respond(HTTPRequest req) {
        if(firstRequest && useVat){
            firstRequest = false;
            return VATResponse(req);
        }
        return TaxResponse(req);
    }

    public HTTPResponse VATResponse(HTTPRequest req) {

        HttpResponse res = new HttpResponse();
        for (String key : this.responseHeaders.keySet()) {
            res.setHeader(key, this.responseHeaders.get(key));
        }
        res.setBody(this.body);
        res.setStatusCode(this.code);
        res.setStatus(this.status);
        return res;
    }

    public HTTPResponse TaxResponse(HTTPRequest req) {
        System.assertEquals('POST', req.getMethod());
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(cc_imp_json_TaxResponseTest.json);
        res.setStatusCode(200);
        return res;
    }

}