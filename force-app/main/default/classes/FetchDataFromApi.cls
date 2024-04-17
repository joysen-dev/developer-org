public with sharing class FetchDataFromApi {
    public FetchDataFromApi() {}

    @AuraEnabled
    public static String getDataFormApi(){        
        String endPointURL = 'https://marketplace.api.healthcare.gov/api/v1/drugs/autocomplete?q=ibuprof&apikey=d687412e7b53146b2631dc01974ad0a4';

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPointURL);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());

        return json.serialize(res.getBody());
    }
}