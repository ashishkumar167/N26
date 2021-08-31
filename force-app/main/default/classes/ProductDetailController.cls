/*****************************************************************************************
Name: ProductDetailController
===============================================================================================
===============================================================================================
Purpose:
--------
Controller for LWC - displayProduct 
===============================================================================================
===============================================================================================
History
-------
VERSION       AUTHOR                  DATE               DETAIL
1.0           Ashish           		29-Aug-2021      Initial Development
******************************************************************************************/

public with sharing class ProductDetailController {
    
    /********************************************************************************
     **Method Name- getProductDetails
     **Parameters- Id of Case record
     **Return type: list of Product Detail record
     **Description- This method accepts case Id and return list of product detail records
		on the basis of associated contact.
    ***********************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<Product_Detail__c> getProductDetails(String caseId){
        String productId;
        String homeCountryId;
        List<Contact> contactRecord;
        List<Product_Detail__c> productDetailRecord;
        
        //Null check on caseId
        if(caseId != null){
            //Fetch Contact record using Contact Id on Case
            contactRecord = Utility.getContactFromCaseId(caseId);
        }
        
        //Null check on Contact record
        if(contactRecord !=null && !contactRecord.isEmpty()){
            //Set value for Product Id and Country Id
            productId = contactRecord[0].Product__c;
            homeCountryId = contactRecord[0].Home_Country__c;
        }
        
        //Null check on Product Id and Country Id
        if(productId != null && homeCountryId!= null){
            //Fetch Product Detail record using Product Id and Country Id
            productDetailRecord = Utility.getProductDetailRecord(productId,homeCountryId);
        }
        
        //Null check on Product Detail record and return the record
        if(productDetailRecord != null && !productDetailRecord.isEmpty()){
        	return productDetailRecord;
        }
        
        //Return null if Product Detail record is not fetched
        return null;
    }
}