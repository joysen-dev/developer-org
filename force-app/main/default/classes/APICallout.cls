public with sharing class APICallout {

    Static String endPointUrl = 'https://fakestoreapi.com/products';
    Static String endPointUrladdUser = 'https://fakestoreapi.com/users';

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

    public static void addUser(){
        HTTP http = new HTTP();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setMethod('POST');
        request.setEndpoint(endPointUrladdUser);
        request.setHeader('Content-Type', 'application/json');
        String body = jsonGenerator();
        request.setBody(body);
        response = http.send(request);
        if (response.getStatusCode() == 200) {
            System.debug('Response -> ' + response.getBody());
        }else {
            System.debug('Error -> '+ response.getStatusCode());
        }
    }

    public static String jsonGenerator(){
        JSONGenerator gen = JSON.createGenerator(true);
        List<String> fruits = new List<String>{'Apple', 'Mango'};

        gen.writeStartObject();

        gen.writeStringField('email', 'John@gmail.com');
        gen.writeStringField('username', 'johnd');
        gen.writeStringField('password', 'm38rmF$');

        gen.writeFieldName('name');
        gen.writeStartObject();
        gen.writeStringField('firstname', 'John');
        gen.writeStringField('lastname', 'Doe');
        gen.writeEndObject();

        gen.writeFieldName('address');
        gen.writeStartObject();
        gen.writeStringField('city', 'kilcoole');
        gen.writeStringField('street', '7835 new road');
        gen.writeNumberField('number', 3);
        gen.writeStringField('zipcode', '12926-3874');
        gen.writeFieldName('geolocation');
        gen.writeStartObject();
        gen.writeStringField('lat', '-37.3159');
        gen.writeStringField('long', '81.1496');
        gen.writeEndObject();
        gen.writeEndObject();

        gen.writeFieldName('fruiteNames');
        gen.writeStartArray();
        for(Integer i = 0; i < fruits.size(); i++){
            gen.writeStartObject();
            gen.writeStringField('fruit', fruits[i]);
            gen.writeEndObject();
        }
        gen.writeEndArray();

        gen.writeStringField('phone', '1-570-236-7033');

        gen.writeEndObject();

        return gen.getAsString();
    }
}