/*****************************************************************************************
Name: UtilityTest
===============================================================================================
===============================================================================================
Purpose:
--------
Test class for Utility.
===============================================================================================
===============================================================================================
History
-------
VERSION       AUTHOR                  DATE               DETAIL
1.0           Ashish           		28-Aug-2021      Initial Development
******************************************************************************************/

@isTest
public class UtilityTest {
    
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
        
        //Creating product record
        Product_Detail__c productDetailRecord = TestDataFactory.createProductDetail(productRecord.Id, countryRecord.Id, true, Constant.COST_PER_CALENDAR_MONTH , true, null, Constant.CARD_REPLACEMENT_COST, Constant.CURRENCYISOCODE_EUR);
        insert productDetailRecord;
    }
    
    //Test method for getContactRecord()
	@isTest 
    static void getContactRecordTest(){	
        //Fetch test record of User, Contact, Product and Country created in setup method
        User userRecord = TestDataFactory.getUserByUsername(Constant.USER_EMAIL)[0];
        Contact contactRecord = TestDataFactory.getContact(Constant.CONTACT_EMAIL)[0];
        Product__c productRecord =  TestDataFactory.getProduct(Constant.PRODUCT_NAME)[0];
        Country__c countryRecord = TestDataFactory.getCountry(Constant.COUNTRY_CODE_DE)[0];
        
        //Running in context of admin user
        System.runAs(userRecord){
            Test.startTest();
                List<Contact> lstContact = Utility.getContactRecord(contactRecord.UUID__c);
            	//Expecting contact record in response
                System.assertEquals(productRecord.Id, lstContact[0].Product__c);
                System.assertEquals(countryRecord.Id, lstContact[0].Home_Country__c);
            Test.stopTest();
        }
    }
    
    //Test method for getProductDetailRecord()
    @isTest
    static void getProductDetailRecordTest(){
        //Fetch test record of User, Product and Country created in setup method
		User userRecord = TestDataFactory.getUserByUsername(Constant.USER_EMAIL)[0];
        Product__c productRecord =  TestDataFactory.getProduct(Constant.PRODUCT_NAME)[0];
        Country__c countryRecord = TestDataFactory.getCountry(Constant.COUNTRY_CODE_DE)[0];
        
        //Running in context of admin user
        System.runAs(userRecord){
            Test.startTest();
                List<Product_Detail__c> lstProductDetail = Utility.getProductDetailRecord(productRecord.Id, countryRecord.Id);
            	//Expecting product detail record in response
                System.assertEquals(productRecord.Name, lstProductDetail[0].Product__r.Name);
            	System.assertEquals(Constant.COST_PER_CALENDAR_MONTH, lstProductDetail[0].Cost_per_Calendar_Month__c);
                System.assertEquals(Constant.CURRENCYISOCODE_EUR, lstProductDetail[0].CurrencyIsoCode);
            Test.stopTest();
        }
	}
    
    //Test method for getContactFromCaseId()
    @isTest
    static void getContactFromCaseIdTest(){
        //Fetch test record of User, Contact and Case created in setup method
        User userRecord = TestDataFactory.getUserByUsername(Constant.USER_EMAIL)[0];
        Contact contactRecord = TestDataFactory.getContact(Constant.CONTACT_EMAIL)[0];
        Case caseRecord = TestDataFactory.getCase(contactRecord.Id)[0];
        
        //Running in context of admin user
        System.runAs(userRecord){
            Test.startTest();
                List<Contact> lstContact = Utility.getContactFromCaseId(caseRecord.Id);
            	//Expecting contact record in response
                System.assertEquals(contactRecord.Product__c, lstContact[0].Product__c);
                System.assertEquals(contactRecord.Home_Country__c, lstContact[0].Home_Country__c);
            Test.stopTest();
        }
    }
    
    //Test method for getFormattedCurrency()
    @isTest
    static void getFormattedCurrencyTest(){
        //Fetch test record of User created in setup method
        User userRecord = TestDataFactory.getUserByUsername(Constant.USER_EMAIL)[0];
        
        //Running in context of admin user
        System.runAs(userRecord){
            Test.startTest();
                String formattedCurrency1 = Utility.getFormattedCurrency(Constant.NUMBER_WITH_DECIMAL, Constant.CURRENCYISOCODE_EUR);
                //Expecting currency without decimal
            	System.assertEquals(Constant.FORMATTED_CURRENCY_WITH_DECIMAL, formattedCurrency1);
                String formattedCurrency2 = Utility.getFormattedCurrency(Constant.NUMBER_WITHOUT_DECIMAL, Constant.CURRENCYISOCODE_EUR);
                //Expecting currency with decimal
            	System.assertEquals(Constant.FORMATTED_CURRENCY_WITHOUT_DECIMAL, formattedCurrency2);
            Test.stopTest();
        }
    }
    
    //Test method for getCurrencySymbol()
    @isTest
    static void getCurrencySymbolTest(){
        //Fetch test record of User created in setup method
        User userRecord = TestDataFactory.getUserByUsername(Constant.USER_EMAIL)[0];
        
        //Running in context of admin user
        System.runAs(userRecord){
            Test.startTest();
                String currencySymbol = Utility.getCurrencySymbol(Constant.CURRENCYISOCODE_EUR);
                //Expecting currency symbol in response
            	System.assertEquals(Constant.EURO_SYMBOL, currencySymbol);
            Test.stopTest();
        }
    }
    
    //Test method for getFormattedDecimal()
    @isTest
    static void getFormattedDecimalTest(){
        //Fetch test record of User created in setup method
        User userRecord = TestDataFactory.getUserByUsername(Constant.USER_EMAIL)[0];
		
		//Running in context of admin user        
        System.runAs(userRecord){
            Test.startTest();
                String formattedDecimal = Utility.getFormattedDecimal(Constant.NUMBER_WITH_DECIMAL);
                //Expecting percentage value with percent symbol in response
            	System.assertEquals(Constant.FORMATTED_PERCENT_VALUE, formattedDecimal);
            Test.stopTest();
        }
    }
}