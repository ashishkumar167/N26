/*****************************************************************************************
Name: ProductDetailWrapperTest
===============================================================================================
===============================================================================================
Purpose:
--------
Test class for ProductDetailWrapper.
===============================================================================================
===============================================================================================
History
-------
VERSION       AUTHOR                  DATE               DETAIL
1.0           Ashish           		28-Aug-2021      Initial Development
******************************************************************************************/

@isTest
public class ProductDetailWrapperTest {

    //Test setup method
    @testSetup
    static void createTestRecords(){
        
        //Fetching admin profile
        Profile profileSysAdmin = TestDataFactory.getProfile(Constant.PROFILE_ADMIN)[0];
        
        //Creating user record
        User userRecord = TestDataFactory.createTestUser(Constant.USER_ALIAS, Constant.USER_EMAIL, Constant.USER_FIRST_NAME, Constant.USER_LAST_NAME, profileSysAdmin.Id, Constant.USER_EMAIL);
        insert userRecord; 
        
        //Creating product record
        Product__c productRecord = TestDataFactory.createProduct(Constant.PRODUCT_NAME);
        insert productRecord;
        
        //Creating country record
        Country__c countryRecord = TestDataFactory.createCountry(Constant.COUNTRY_CODE_DE, Constant.COUNTRY_NAME_GERMANY);
        insert countryRecord;
        
        //Creating account record
        Account accountRecord = TestDataFactory.createAccount(Constant.ACCOUNT_NAME);
        insert accountRecord;
        
        //Creating contact record
        Contact contactRecord = TestDataFactory.createContact(Constant.CONTACT_FIRSTNAME, Constant.CONTACT_LASTNAME, Constant.UUID, productRecord.Id, countryRecord.Id, Constant.CONTACT_EMAIL, accountRecord.Id);
        insert contactRecord;
        
        //Creating case record
        Case caseRecord = TestDataFactory.createCase(contactRecord.Id);
        insert caseRecord;
    }
    
    //Test method for wrapper class ProductDetailWrapper.ProductInformation
    @isTest
    static void ProductInformationTest(){
        //Fetch test record of User, Product and Country created in setup method
        User userRecord = TestDataFactory.getUserByUsername(Constant.USER_EMAIL)[0];
        Product__c productRecord =  TestDataFactory.getProduct(Constant.PRODUCT_NAME)[0];
        Country__c countryRecord = TestDataFactory.getCountry(Constant.COUNTRY_CODE_DE)[0];

        List<Product_Detail__c> lstproductDetailRecord = new List<Product_Detail__c>();
        
        //positive scenario - populating Cost Per Calendar Month and ATM Fee In Other Currencies 
        lstproductDetailRecord.add(TestDataFactory.createProductDetail(productRecord.Id, countryRecord.Id, true, Constant.COST_PER_CALENDAR_MONTH , false, Constant.NUMBER_WITHOUT_DECIMAL, Constant.CARD_REPLACEMENT_COST, Constant.CURRENCYISOCODE_EUR));
        //positive scenario - populating Cost Per Calendar Month and ATM Fee In Other Currencies  as null
        lstproductDetailRecord.add(TestDataFactory.createProductDetail(productRecord.Id, countryRecord.Id, false, null , true, null, Constant.CARD_REPLACEMENT_COST, Constant.CURRENCYISOCODE_EUR));
        //Negative scenario - Setting Is Cost Per Calendar Month as true and Cost Per Calendar Month as null
        lstproductDetailRecord.add(TestDataFactory.createProductDetail(productRecord.Id, countryRecord.Id, true, null , true, null, Constant.CARD_REPLACEMENT_COST, Constant.CURRENCYISOCODE_EUR));
        //Negative scenario - Setting Is ATM Fee Free as false and ATM Fee In Other Currencies as null
        lstproductDetailRecord.add(TestDataFactory.createProductDetail(productRecord.Id, countryRecord.Id, true, Constant.COST_PER_CALENDAR_MONTH , false, null, Constant.CARD_REPLACEMENT_COST, Constant.CURRENCYISOCODE_EUR));
        //Postive scenario - Setting card replacement cost as null
        lstproductDetailRecord.add(TestDataFactory.createProductDetail(productRecord.Id, countryRecord.Id, true, Constant.COST_PER_CALENDAR_MONTH , false, null, null, Constant.CURRENCYISOCODE_EUR));
        
        //Running in context of admin user
        System.runAs(userRecord){
            Test.startTest();
            	//Iterating over list of product detail records
                for(Integer i=0; i<lstproductDetailRecord.size(); i++){
                    //Calling product information wrapper class
                    ProductDetailWrapper.ProductInformation prodInformation = new ProductDetailWrapper.ProductInformation(lstproductDetailRecord[i]);
                }
            Test.stopTest();
        }
    }
    
    //Test method for wrapper class ProductDetailWrapper.ErrorInformation
    @isTest
    static void ErrorInformationTest(){
        //Fetch test record of User created in setup method
        User userRecord = TestDataFactory.getUserByUsername(Constant.USER_EMAIL)[0];
        
        //Running in context of admin user
        System.runAs(userRecord){
            Test.startTest();
            	//Calling error information wrapper class
                ProductDetailWrapper.ErrorInformation errorDetails = new ProductDetailWrapper.ErrorInformation(Constant.BAD_REQUEST, Constant.INVALID_UUID);
            Test.stopTest();
        }
    }
}