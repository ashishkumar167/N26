/*****************************************************************************************
Name: ProductDetailTest
===============================================================================================
===============================================================================================
Purpose:
--------
Test class for ProductDetail
===============================================================================================
===============================================================================================
History
-------
VERSION       AUTHOR                  DATE               DETAIL
1.0           Ashish           		28-Aug-2021      Initial Development
******************************************************************************************/

@isTest
public class ProductDetailTest {
    
    //Test setup method
    @testSetup
    static void createTestRecords(){
        //Fetch Admin profile
        Profile profileSysAdmin = TestDataFactory.getProfile(Constant.PROFILE_ADMIN)[0];
 		
        //Create test user
        User userRecord = TestDataFactory.createTestUser(Constant.USER_ALIAS, Constant.USER_EMAIL, Constant.USER_FIRST_NAME, Constant.USER_LAST_NAME, profileSysAdmin.Id, Constant.USER_EMAIL);
        insert userRecord; 
        
        //Create test product record
        Product__c productRecord = TestDataFactory.createProduct(Constant.PRODUCT_NAME);
        insert productRecord;
        
        //Create Country record for Germany
        Country__c countryRecord = TestDataFactory.createCountry(Constant.COUNTRY_CODE_DE, Constant.COUNTRY_NAME_GERMANY);
        insert countryRecord;
        
        //Create test Account record
        Account accountRecord = TestDataFactory.createAccount(Constant.ACCOUNT_NAME);
        insert accountRecord;
        
        //Create test Contact record
        Contact contactRecord = TestDataFactory.createContact(Constant.CONTACT_FIRSTNAME, Constant.CONTACT_LASTNAME, Constant.UUID, null, null, Constant.CONTACT_EMAIL, accountRecord.Id);
        insert contactRecord;
        
        //Create test case record
        Case caseRecord = TestDataFactory.createCase(contactRecord.Id);
        insert caseRecord;
        
        
    }
    
    //Test method to cover getProduct()
    @isTest
    static void getProductTest(){
        //Fetch test record of User, Contact, Product and Country created in setup method
        User userRecord = TestDataFactory.getUserByUsername(Constant.USER_EMAIL)[0];
        Contact contactRecord = TestDataFactory.getContact(Constant.CONTACT_EMAIL)[0];
        Product__c productRecord =  TestDataFactory.getProduct(Constant.PRODUCT_NAME)[0];
        Country__c countryRecord = TestDataFactory.getCountry(Constant.COUNTRY_CODE_DE)[0];
        //Updating contact record to associate it with Product Id and Country Id
        contactRecord.Product__c = productRecord.Id;
        contactRecord.Home_Country__c = countryRecord.Id;
        update contactRecord;
        
        //Running in context of admin user
        System.runAs(userRecord){
            Test.startTest();
            	//Testing positive scenario where response code is 200 and response has product detail information
                //Created product detail record
                Product_Detail__c productDetailRecord = TestDataFactory.createProductDetail(productRecord.Id, countryRecord.Id, true, 29.50 , true, null, 10, Constant.CURRENCYISOCODE_EUR);
                insert productDetailRecord;
                //Calling web-service class
            	RestResponse res = TestDataFactory.callGetProduct(contactRecord.UUID__c);
                //Calling web-service class
            	Map<String, Object> apiResponse = (Map<String, Object>) JSON.deserializeUntyped(res.responseBody.toString());
                //Expecting status code 404 in response
            	System.assertEquals(Constant.STATUS_CODE_200, res.statusCode);
            	//Expecting Product Name within response
                System.assertEquals(productRecord.Name, apiResponse.get(Constant.WRAPPER_VARIABLE_PRODUCT_NAME));
            	//Expecting Country Name within response
                System.assertEquals(countryRecord.Name, apiResponse.get(Constant.WRAPPER_VARIABLE_COUNTRY));
            
            Test.stopTest();
        }
    }
    
    //Test method to cover getResponse()
    @isTest
    static void getResponseTest(){
        //Fetch test record of User, Contact, Product and Country created in setup method
        User userRecord = TestDataFactory.getUserByUsername(Constant.USER_EMAIL)[0];
        Contact contactRecord = TestDataFactory.getContact(Constant.CONTACT_EMAIL)[0];
        Product__c productRecord =  TestDataFactory.getProduct(Constant.PRODUCT_NAME)[0];
        Country__c countryRecord = TestDataFactory.getCountry(Constant.COUNTRY_CODE_DE)[0];
        String strUUID = '';
        
        //Running in context of admin user
        System.runAs(userRecord){
            Test.startTest();
            	//Checking the negative scenaio where UUIL is invalid or null
            	//Calling getResponse method
                ProductDetail.getResponse(strUUID);
            	//Deserializing the response from web-service class
                Map<String, Object> apiResponse = (Map<String, Object>) JSON.deserializeUntyped(ProductDetail.strResponse);
            	//Expecting status code 400 in response
            	System.assertEquals(Constant.STATUS_CODE_400, ProductDetail.statusCode);
            	//Expecting Invalid UUID message in response
                System.assertEquals(Constant.INVALID_UUID, apiResponse.get(Constant.WRAPPER_VARIABLE_MESSAGE));
            	
            	
            	//Checking the negative scenaio where Contact record is not found
            	strUUID = '12';
                //Calling getResponse method
                ProductDetail.getResponse(strUUID);
            	//Deserializing the response from web-service class
            	apiResponse = (Map<String, Object>) JSON.deserializeUntyped(ProductDetail.strResponse);
                //Expecting status code 404 in response
            	System.assertEquals(Constant.STATUS_CODE_404, ProductDetail.statusCode);
            	//Expecting Contact Not Found message in response
                System.assertEquals(Constant.CONTACT_NOT_FOUND, apiResponse.get(Constant.WRAPPER_VARIABLE_MESSAGE));
                
                
                //Checking the negative scenaio where Product or Country not associated on Contact
                //Calling getResponse method
                ProductDetail.getResponse(contactRecord.UUID__c);
            	//Deserializing the response from web-service class
                apiResponse = (Map<String, Object>) JSON.deserializeUntyped(ProductDetail.strResponse);
            	//Expecting status code 404 in response
                System.assertEquals(Constant.STATUS_CODE_404, ProductDetail.statusCode);
            	//Expecting Product or Country missing message in response
                System.assertEquals(Constant.PRODUCT_COUNTRY_MISSING, apiResponse.get(Constant.WRAPPER_VARIABLE_MESSAGE));
                
            	//Checking the negative scenaio where ProductDetail Record is not found
            	//Updating contact record to associate it with Product Id and Country Id
                contactRecord.Product__c = productRecord.Id;
                contactRecord.Home_Country__c = countryRecord.Id;
                update contactRecord;
                //Calling getResponse method
                ProductDetail.getResponse(contactRecord.UUID__c);
            	//Deserializing the response from web-service class
                apiResponse = (Map<String, Object>) JSON.deserializeUntyped(ProductDetail.strResponse);
                //Expecting status code 404 in response
                System.assertEquals(Constant.STATUS_CODE_404, ProductDetail.statusCode);
                //Expecting Product not found message in response
                System.assertEquals(Constant.PRODUCT_NOT_FOUND, apiResponse.get(Constant.WRAPPER_VARIABLE_MESSAGE));
                
                
                //Testing positive scenario where response code is 200 and response has product detail information
                //Created product detail record
                Product_Detail__c productDetailRecord = TestDataFactory.createProductDetail(productRecord.Id, countryRecord.Id, true, 29.50 , true, null, 10, Constant.CURRENCYISOCODE_EUR);
                insert productDetailRecord;
                //Calling getResponse method
                ProductDetail.getResponse(contactRecord.UUID__c);
            	//Calling web-service class
            	apiResponse = (Map<String, Object>) JSON.deserializeUntyped(ProductDetail.strResponse);
                //Expecting status code 404 in response
            	System.assertEquals(Constant.STATUS_CODE_200, ProductDetail.statusCode);
            	//Expecting Product Name within response
                System.assertEquals(productRecord.Name, apiResponse.get(Constant.WRAPPER_VARIABLE_PRODUCT_NAME));
            	//Expecting Country Name within response
                System.assertEquals(countryRecord.Name, apiResponse.get(Constant.WRAPPER_VARIABLE_COUNTRY));
            Test.stopTest();
        }
    }
}