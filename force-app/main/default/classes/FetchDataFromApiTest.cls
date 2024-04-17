@isTest
public with sharing class FetchDataFromApiTest {
    public FetchDataFromApiTest() {}

    @isTest
    public static void testGetDataFormApi(){
        String body = '[{"rxcui":"1049589","name":"Ibuprofen/oxyCODONE","strength":"400-5 mg","route":"Oral Pill","full_name":"ibuprofen 400 MG / oxycodone hydrochloride 5 MG Oral Tablet","rxterms_dose_form":"Tab","rxnorm_dose_form":"Oral Tablet"},{"rxcui":"1100066","name":"Famotidine/Ibuprofen","strength":"26.6-800 mg","route":"Oral Pill","full_name":"famotidine 26.6 MG / ibuprofen 800 MG Oral Tablet","rxterms_dose_form":"Tab","rxnorm_dose_form":"Oral Tablet"},{"rxcui":"1297390","name":"Chlorpheniramine/Ibuprofen/Pseudoephedrine","strength":"2-200-30 mg","route":"Oral Pill","full_name":"chlorpheniramine maleate 2 MG / ibuprofen 200 MG / pseudoephedrine hydrochloride 30 MG Oral Tablet","rxterms_dose_form":"Tab","rxnorm_dose_form":"Oral Tablet"},{"rxcui":"1299018","name":"Ibuprofen/Pseudoephedrine","strength":"200-30 mg","route":"Oral Pill","full_name":"ibuprofen 200 MG / pseudoephedrine hydrochloride 30 MG Oral Capsule","rxterms_dose_form":"Cap","rxnorm_dose_form":"Oral Capsule"},{"rxcui":"1299021","name":"Ibuprofen/Pseudoephedrine","strength":"200-30 mg","route":"Oral Pill","full_name":"ibuprofen 200 MG / pseudoephedrine hydrochloride 30 MG Oral Tablet","rxterms_dose_form":"Tab","rxnorm_dose_form":"Oral Tablet"},{"rxcui":"1310503","name":"Chlorpheniramine/Ibuprofen/Phenylephrine","strength":"4-200-10 mg","route":"Oral Pill","full_name":"chlorpheniramine maleate 4 MG / ibuprofen 200 MG / phenylephrine hydrochloride 10 MG Oral Tablet","rxterms_dose_form":"Tab","rxnorm_dose_form":"Oral Tablet"},{"rxcui":"1369775","name":"Ibuprofen/Phenylephrine","strength":"200-10 mg","route":"Oral Pill","full_name":"ibuprofen 200 MG / phenylephrine hydrochloride 10 MG Oral Tablet","rxterms_dose_form":"Tab","rxnorm_dose_form":"Oral Tablet"},{"rxcui":"1747294","name":"Ibuprofen","strength":"10 mg/ml","route":"Injectable","full_name":"2 ML ibuprofen 10 MG/ML Injection","rxterms_dose_form":"Injection 2 ml","rxnorm_dose_form":"Injection"},{"rxcui":"197803","name":"Ibuprofen","strength":"100 mg/5ml","route":"Oral Liquid","full_name":"ibuprofen 20 MG/ML Oral Suspension","rxterms_dose_form":"Susp","rxnorm_dose_form":"Oral Suspension"},{"rxcui":"197805","name":"Ibuprofen","strength":"400 mg","route":"Oral Pill","full_name":"ibuprofen 400 MG Oral Tablet","rxterms_dose_form":"Tab","rxnorm_dose_form":"Oral Tablet"}]';


        FetchDataFromApiMock mock = new FetchDataFromApiMock(200, 'OK', body, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        String result = FetchDataFromApi.getDataFormApi();
        System.assertEquals(json.serialize(mock), result);
    }
}