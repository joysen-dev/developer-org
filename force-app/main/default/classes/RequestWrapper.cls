public with sharing class RequestWrapper {
    @AuraEnabled
    public String Email;
    @AuraEnabled
    public String Username;
    @AuraEnabled
    public String Password;
    @AuraEnabled
    public Name Name;
    @AuraEnabled
    public Address Address;
    @AuraEnabled
    public String Phone;

    public class Name{
        @AuraEnabled
        public String Firstname;
        @AuraEnabled
        public String Lastname;
    }

    public class Address{
        @AuraEnabled
        public String City;
        @AuraEnabled
        public String Street;
        @AuraEnabled
        public String Number;
        @AuraEnabled
        public String Zipcode;
        @AuraEnabled
        public Geolocation Geolocation;
    }

    public class Geolocation{
        @AuraEnabled
        public String Lat;
        @AuraEnabled
        public String Long;
    }

}