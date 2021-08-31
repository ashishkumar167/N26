/*****************************************************************************************
Name: TestDataFactory
===============================================================================================
===============================================================================================
Purpose:
--------
Class to create test record for test classes or to fetch test records.
===============================================================================================
===============================================================================================
History
-------
VERSION       AUTHOR                  DATE               DETAIL
1.0           Ashish           		28-Aug-2021      Initial Development
******************************************************************************************/

@isTest
public class TestDataFactory {
    
    //Fetch List of Profile on the basis of profile name
    public static List<Profile> getProfile(String profileName){
        return [Select Id from Profile where Name = :profileName];
    }
    
    //Fetch list of users on the basis of username
    public static List<User> getUserByUsername(String username){
        return [Select Id from User where Username = :username];
    }
    
    //Fetch list of product records on the basis of product name
    public static List<Product__c> getProduct(String productName){
        return [Select Id, Name from Product__c where Name = :productName];
    }
    
    //Fetch list of country records on the basis of country code
    public static List<Country__c> getCountry(String countryCode){
        return [Select Id, Name, Country_Name__c from Country__c where Name = :countryCode];
    }
    
    //Fetch list of contact records on the basis of email of contact
    public static List<Contact> getContact(String email){
        return [Select Id, Product__c, Home_Country__c, UUID__c from Contact where Email = :email];
    }
    
    //Fetch list of case records on the basis of Id of contact record
    public static List<Case> getCase(String contactId){
        return [Select Id from Case where ContactId = :contactId];
    }
    
    //Create test users
    public static User createTestUser(String alias, String email, String firstName, String lastName, String profileId, String username){
        User userRecord = new User();
        userRecord.Alias = alias;
        userRecord.Email = email; 
        userRecord.EmailEncodingKey = Constant.EMAIL_ENCODING_UTF8;
        userRecord.FirstName = firstName;
        userRecord.LastName = lastName;
        userRecord.ProfileId = profileId; 
        userRecord.UserName = username;
        userRecord.LanguageLocaleKey = Constant.LANGUAGE_LOCALE_EN_US;
        userRecord.TimeZoneSidKey = Constant.TIMEZONE_LONDON;
        userRecord.LocaleSidKey = Constant.LOCALSIDKEY_EN_GB; 
        return userRecord;
    }
    
    //Create product record
    public static Product__c createProduct(String productName){
        Product__c productRecord = new Product__c();
        productRecord.Name = productName;
        return productRecord;
    }
    
    //Create country record
    public static Country__c createCountry(String countryCode, String countryName){
    	Country__c countryRecord = new Country__c();
        countryRecord.Name = countryCode;
        countryRecord.Country_Name__c = countryName;
        return countryRecord;
    }
    
    //Create Account record
    public static Account createAccount(String name){
        Account accountRecord = new Account();
        accountRecord.Name = name;
        return accountRecord;
    }
    
    //Create contact record
    public static Contact createContact(String firstName, String lastName, String strUUID, Id productId, Id countryId, String email, Id accountId){
        Contact contactRecord = new Contact();
        contactRecord.FirstName = firstName;
        contactRecord.LastName = lastName;
        contactRecord.Email = email;
        contactRecord.UUID__c = strUUID;
        contactRecord.Product__c = productId;
		contactRecord.Home_Country__c = countryId;
        contactRecord.AccountId = accountId;
        return contactRecord;
    }
    
    //Create case record
    public static Case createCase(Id contactId){
        Case caseRecord = new Case();
        caseRecord.ContactId = contactId;
        caseRecord.Type = Constant.TYPE_ELECTRICAL;
        caseRecord.Reason = Constant.REASON_FEEDBACK;
        caseRecord.CurrencyIsoCode = Constant.CURRENCYISOCODE_EUR;
        caseRecord.Status = Constant.STATUS_NEW;
        caseRecord.Origin = Constant.ORIGIN_PHONE;
        return caseRecord;
    }
	
    //Create product detail record
    public static Product_Detail__c createProductDetail(Id productId, Id countryId, Boolean isCalendarMonth, 
                                                        Decimal costPerCalendarMonth, Boolean isATMFeeFree, Decimal atmFeeInOtherCurrencies,
                                                        Decimal CardRelacementCose, String strCurrencyIsoCode){
        Product_Detail__c productDetailRecord = new Product_Detail__c();
        productDetailRecord.Product__c = productId;
        productDetailRecord.Country_Code__c = countryId;
        productDetailRecord.Is_Cost_per_Calendar_Month__c = isCalendarMonth;
        productDetailRecord.Cost_per_Calendar_Month__c = costPerCalendarMonth;
        productDetailRecord.ATM_Fee_Free__c = isATMFeeFree;
        productDetailRecord.ATM_Fee_in_other_currencies__c = atmFeeInOtherCurrencies;
        productDetailRecord.Card_Replacement_Cost__c = CardRelacementCose;
        productDetailRecord.CurrencyIsoCode = strCurrencyIsoCode;
		return productDetailRecord;
	}  
    
    //Preparing RestResponse to perform call getProduct method of webservice class ProductDetail
    public static RestResponse callGetProduct(String strUUID){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.Url.getSalesforceBaseUrl().toExternalForm()+ Constant.URL_MAPPING_PRODUCT + strUUID;
        req.httpMethod = Constant.HTTP_METHOD_GET;
        RestContext.request = req;
        RestContext.response = res;
        ProductDetail.getProduct();
        res = RestContext.response;
        return res;
    }
}