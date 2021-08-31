/*****************************************************************************************
Name: Utility
===============================================================================================
===============================================================================================
Purpose:
--------
This is utility class for performing generic code logic.
===============================================================================================
===============================================================================================
History
-------
VERSION       AUTHOR                  DATE               DETAIL
1.0           Ashish           		28-Aug-2021      Initial Development
******************************************************************************************/

public class Utility {
    
    /********************************************************************************
     **Method Name- getContactRecord
     **Parameters- UUID as string
     **Return type: list of Contact record
     **Description- This method returns list of Contact on the basis of UUID.
    ***********************************************************************************/
	public static List<Contact> getContactRecord(String strUUID){
        return [Select Product__c, Home_Country__c from Contact where UUID__c = :strUUID];
    }
    
    /********************************************************************************
     **Method Name- getProductDetailRecord
     **Parameters- Id of Product and Contact record
     **Return type: List of Product Detail record
     **Description- This method returns list of Product detail records fetched on the
		basis of Id of Product and Contact record
    ***********************************************************************************/
    public static List<Product_Detail__c> getProductDetailRecord(String productId, String homeCountryId){
        return [Select Product__r.Name, Country_Code__r.Name, Is_Cost_per_Calendar_Month__c, Cost_per_Calendar_Month__c, 
                ATM_Fee_Free__c, ATM_Fee_in_other_currencies__c, Card_Replacement_Cost__c, CurrencyIsoCode from Product_Detail__c
                where Product__c = :productId and Country_Code__c = :homeCountryId];
    }
    
    /********************************************************************************
     **Method Name- getContactFromCaseId
     **Parameters- Id of Case record
     **Return type: List of Contact record
     **Description- This method returns list of contact fetched on basis of Contact Id
		on Case record.
    ***********************************************************************************/
    public static List<Contact> getContactFromCaseId(String caseId){
        return [Select Product__c, Home_Country__c from Contact 
                            where Id in (Select ContactId from Case where Id = :caseId)];
    }
    
    /********************************************************************************
     **Method Name- getFormattedCurrency
     **Parameters- Decimal value and CurrencyIsocode
     **Return type: String
     **Description- This method removes digits after decimal if it is 00, replace dot with 
		comma, and merges them with currency symbol.
    ***********************************************************************************/
    public static String getFormattedCurrency(Decimal currencyValue, String currencyIsoCode){
        //Fetching currency Symbol
        String currencySymbol = getCurrencySymbol(currencyIsoCode);
        //Getting digits after decimal
        Decimal digitsAfterDecimal = currencyValue - currencyValue.round(System.RoundingMode.DOWN);
        if(digitsAfterDecimal == 0){
            //Returning concat of currency symbol and currency without decimal value
            return getCurrencySymbol(currencyIsoCode) + ' ' + String.valueOf(currencyValue).subStringBefore('.');
        }else{
            //Returning concat of currency symbol and currency with decimal value
            return getCurrencySymbol(currencyIsoCode) + ' ' + String.valueOf(currencyValue).replace('.',',');   
        }
    }
    
    /********************************************************************************
     **Method Name- getCurrencySymbol
     **Parameters- CurrecnyIsoCode
     **Return type: Currency Symbol
     **Description- This method accepts CurrencyIsoCode and retuns Currency symbol from
		Custom Metadata.
    ***********************************************************************************/
    public static String getCurrencySymbol(String strCurrencyIsoCode){
        return [Select Symbol__c from Currency_Symbol__mdt 
                                 where CurrencyIsoCode__c = :strCurrencyIsoCode][0].Symbol__c;
    }
    
    /********************************************************************************
     **Method Name- getFormattedDecimal
     **Parameters- Decimal value
     **Return type: String
     **Description- This method accepts decimal value, add pecent symbol to it and return
		the value in string format.
    ***********************************************************************************/
    public static String getFormattedDecimal(Decimal percentValue){
        //Return concat of percent value and percent symbol
        return String.valueOf((percentValue).format()) + Constant.PERCENT_SYMBOL;
    }
}