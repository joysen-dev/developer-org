public with sharing class SearchDataFromAPI {
    public SearchDataFromAPI() {}

    @InvocableMethod(label='Search Product Form API' description='' category='Custom Apex')
    public static List<String> getProducts(List<Parameter> request){
        
        // Getting All the Products based on category
        HttpResponse result = SearchDataFromAPI.runCallout(request[0].category);

        return new List<String>{JSON.serialize(result.getBody())};
        
    }

    public class Parameter{
        @InvocableVariable(label = 'Product Category')
        public String category;
        @InvocableVariable(label = 'Product Price')
        public Integer price;
        @InvocableVariable(label = 'Product Name')
        public String name;
    }

    public static HttpResponse runCallout(String category) {

        String endPoint = 'https://fakestoreapi.com/products/category/' + category;

        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();
        HTTP http = new HTTP();
        req.setEndpoint(endPoint);
        req.setMethod('GET');
        res = http.send(req);
        if (res.getStatusCode() == 200) {
            System.debug('Success');
        }else {
            System.debug('Error');
        }

        return res;
    }
}