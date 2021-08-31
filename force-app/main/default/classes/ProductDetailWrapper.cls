/*****************************************************************************************
Name: ProductDetailWrapper
===============================================================================================
===============================================================================================
Purpose:
--------
Wrapper class for creating product information and error message.
===============================================================================================
===============================================================================================
History
-------
VERSION       AUTHOR                  DATE               DETAIL
1.0           Ashish           		28-Aug-2021      Initial Development
******************************************************************************************/

public class ProductDetailWrapper {
    
    public static Integer responseCode;
    
    //Wrapper for Prodcuct Details
    public class ProductInformation{
        String productName;
        String homeCountry;
        String costPerCalendarMonth;
        String atmFeeInOtherCurrencies;
        String cardReplacementCost;
        
        //Constructor
        public ProductInformation(Product_Detail__c lstProductDetail){
            //Populate Product Name
            this.productName = lstProductDetail.Product__r.Name != null ? lstProductDetail.Product__r.Name : '';
            //Populate Country
            this.homeCountry = lstProductDetail.Country_Code__r.Name != null ? lstProductDetail.Country_Code__r.Name : '';
            
            //Check if Is Cost Per Calendar Month is checked and populate Cost Per Calendar Month
            if(lstProductDetail.Is_Cost_per_Calendar_Month__c){
               	if(lstProductDetail.Cost_per_Calendar_Month__c != null && lstProductDetail.CurrencyIsoCode != null)
               		//Get currency in formatted value with symbol
                    this.costPerCalendarMonth = Utility.getFormattedCurrency(lstProductDetail.Cost_per_Calendar_Month__c, lstProductDetail.CurrencyIsoCode);
                else
                    this.costPerCalendarMonth = '';
            }
            else{
                //Populate 'N/a' if Is Cost Per Calendar is not checked
                this.costPerCalendarMonth = Constant.NOT_AVAILABLE;
            }
            
            //Check if ATM Fee Free is checked
            if(lstProductDetail.ATM_Fee_Free__c){
                //Populate 'Free' if ATM Fee Free is checked
                this.atmFeeInOtherCurrencies = Constant.FREE;
            }
            else{
                if(lstProductDetail.ATM_Fee_in_other_currencies__c != null)
                    //Get percent value in formatted form
                    this.atmFeeInOtherCurrencies = Utility.getFormattedDecimal(lstProductDetail.ATM_Fee_in_other_currencies__c);
                else
                    this.atmFeeInOtherCurrencies = '';
                
            }
            
            //Populate Card Replacement cost
            if(lstProductDetail.Card_Replacement_Cost__c != null && lstProductDetail.CurrencyIsoCode != null){
                this.cardReplacementCost = Utility.getFormattedCurrency(lstProductDetail.Card_Replacement_Cost__c, lstProductDetail.CurrencyIsoCode);
            }
            else{
                this.cardReplacementCost = '';
            }
        }
    }
    
    //Wrapper for error information
    public class ErrorInformation{
        public String errorCode;
        public String message;
        
        //Constructor
        public ErrorInformation(String errorCode, string message){
            this.errorCode = errorCode;
            this.message = message;
        }
    }
}