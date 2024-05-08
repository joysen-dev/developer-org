public with sharing class APICallout {

    Static String endPointUrl = 'https://fakestoreapi.com/products';

    @AuraEnabled
    public static String getAllProduct(){
        HTTP http = new HTTP();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setMethod('GET');
        request.setEndpoint(endPointUrl);
        response = http.send(request);
        System.debug('response -> '+ response.getBody());
        if(response.getStatusCode() == 200){
            return response.getBody();
        }else {
            return 'An error Happend ' + response.getStatusCode();
        }
    }
}