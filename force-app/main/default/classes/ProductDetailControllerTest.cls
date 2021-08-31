/*****************************************************************************************
Name: ProductDetailControllerTest
===============================================================================================
===============================================================================================
Purpose:
--------
Test class for ProductDetailController
===============================================================================================
===============================================================================================
History
-------
VERSION       AUTHOR                  DATE               DETAIL
1.0           Ashish           		29-Aug-2021      Initial Development
******************************************************************************************/

@isTest
public class ProductDetailControllerTest {
    
    //Test setup method
    @testSetup
    static void createTestRecords(){
        
        //Fetch Agent profile
        Profile profileSysAdmin = TestDataFactory.getProfile(Constant.PROFILE_AGENT)[0];
        
        //Create test user
        User userRecord = TestDataFactory.createTestUser(Constant.USER_ALIAS, Constant.USER_EMAIL, Constant.USER_FIRST_NAME, Constant.USER_LAST_NAME, profileSysAdmin.Id, Constant.USER_EMAIL);
        insert userRecord; 
        
        //Create Product record
        Product__c productRecord = TestDataFactory.createProduct(Constant.PRODUCT_NAME);
        insert productRecord;
        
        //Create Country record
        Country__c countryRecord = TestDataFactory.createCountry(Constant.COUNTRY_CODE_DE, Constant.COUNTRY_NAME_GERMANY);
        insert countryRecord;
        
        //Create Account record
        Account accountRecord = TestDataFactory.createAccount(Constant.ACCOUNT_NAME);
        insert accountRecord;
        
        //Create contact record
        Contact contactRecord = TestDataFactory.createContact(Constant.CONTACT_FIRSTNAME, Constant.CONTACT_LASTNAME, Constant.UUID, productRecord.Id, countryRecord.Id, Constant.CONTACT_EMAIL, accountRecord.Id);
        insert contactRecord;
        
        //Create case record
        Case caseRecord = TestDataFactory.createCase(contactRecord.Id);
        insert caseRecord;
        
        //Create product detail record
        Product_Detail__c productDetailRecord = TestDataFactory.createProductDetail(productRecord.Id, countryRecord.Id, true, Constant.COST_PER_CALENDAR_MONTH , true, null, Constant.CARD_REPLACEMENT_COST, Constant.CURRENCYISOCODE_EUR);
        insert productDetailRecord;
                
    }
    
    //Test method for getProductDetails()
    @isTest
    static void getProductDetailsTest(){
        //Fetch test record of User, Contact, Product and Country created in setup method
        User userRecord = TestDataFactory.getUserByUsername(Constant.USER_EMAIL)[0];
        Contact contactRecord = TestDataFactory.getContact(Constant.CONTACT_EMAIL)[0];
        Product__c productRecord =  TestDataFactory.getProduct(Constant.PRODUCT_NAME)[0];
        Country__c countryRecord = TestDataFactory.getCountry(Constant.COUNTRY_CODE_DE)[0];
        
        //Running in context of agent user
        System.runAs(userRecord){
            Test.startTest();
            	
            	//Testing negative scenario where method is returning null due to unavailability of contact or product detail record
            	//Creating case without contact associated to it
            	Case caseRecord = TestDataFactory.createCase(null);
        		insert caseRecord;
            	List<Product_Detail__c> lstProductDetail1 = ProductDetailController.getProductDetails(caseRecord.Id);
                //Expecting null in response since associated contact is not available
            	System.assert(lstProductDetail1 == null);
            
            	//Testing postive scenario where method is returning list of product detail records
            	//Updating case record to update contact Id on record.
            	caseRecord.ContactId = contactRecord.Id;
            	update caseRecord;
                List<Product_Detail__c> lstProductDetail2 = ProductDetailController.getProductDetails(caseRecord.Id);
                //Expecting product detail record in response.
            	System.assertEquals(true, lstProductDetail2[0].ATM_Fee_Free__c);
            	System.assertEquals(null, lstProductDetail2[0].ATM_Fee_in_other_currencies__c);
			Test.stopTest();
        }	
    }
}