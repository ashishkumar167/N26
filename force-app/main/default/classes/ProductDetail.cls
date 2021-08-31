/*****************************************************************************************
Name: ProductDetail
===============================================================================================
===============================================================================================
Purpose:
--------
This is rest web-service class for fetching product information using UUID.
===============================================================================================
===============================================================================================
History
-------
VERSION       AUTHOR                  DATE               DETAIL
1.0           Ashish           		28-Aug-2021      Initial Development
******************************************************************************************/

@RestResource(urlMapping = '/Product/*')
global class ProductDetail{
    
    //Variable to capture statuscode
    @TestVisible
    private static Integer statusCode;
    //Variable to capture response message in JSON format
    @TestVisible
    private static String strResponse;
    
    /********************************************************************************
     **Method Name- getProduct
     **Parameters- UUID(within URL)
     **Return type: void(RestResponse)
     **Description- This method accept UUID as request and send back product information
		error message as response.
    ***********************************************************************************/
    @HttpGet
    global static void getProduct(){
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        //Grab the UUID from the end of the URL
        String strUUID = String.escapeSingleQuotes(request.requestURI.substring(request.requestURI.lastIndexOf('/')+1));
        
        //Calling getResponse method to get response information
        getResponse(strUUID);
        
        //Setting the status code and responseBody
        response.statusCode = statusCode;
        response.responseBody = Blob.valueOf(strResponse);
    }
    
    /********************************************************************************
     **Method Name- getResponse
     **Parameters- UUID as String
     **Return type: void
     **Description- This method fetches product detail record for relevant UUID, and 
		populates the strResponse variable in JSON format. It will also capture 
		reposne code and will take care of error framework during API call.
    ***********************************************************************************/
    @TestVisible
    private static void getResponse(String strUUID){
        String productId;
        String homeCountryId;
        List<Contact> contactRecord;
        List<Product_Detail__c> productDetailRecord;
        //Wrapper class variable for sending product information in response
        ProductDetailWrapper.ProductInformation productWrapperRecord;
        //Wrapper class variable for error message
        ProductDetailWrapper.ErrorInformation errorDetails;
        
        try{
            //Null check on UUID
            if(strUUID != null && !String.isBlank(strUUID)){
                //Fetching contact on basis of UUID
                contactRecord = Utility.getContactRecord(strUUID);
            }
            else{
                //Setting error codes for Invalid UUID
                statusCode = Constant.STATUS_CODE_400;
                errorDetails = new ProductDetailWrapper.ErrorInformation(Constant.BAD_REQUEST, Constant.INVALID_UUID);
            }
            
            if(contactRecord !=null && !contactRecord.isEmpty()){
                //Setting values of Product and Home Country from Contact
                productId = contactRecord[0].Product__c;
                homeCountryId = contactRecord[0].Home_Country__c;
            }
            else{
                //Setting error codes when contact is not available
                if(errorDetails == null){
                    statusCode = Constant.STATUS_CODE_404;
                    errorDetails = new ProductDetailWrapper.ErrorInformation(Constant.NOT_FOUND, Constant.CONTACT_NOT_FOUND);
                }
            }
            
            if(productId != null && homeCountryId!= null){
                //Fetching Product Detail record on the basis of ProductId and HomeCountryId 
                productDetailRecord = Utility.getProductDetailRecord(productId,homeCountryId);
            }
            else{
                //Setting error codes when product details records is not available
                if(errorDetails == null){
                    statusCode = Constant.STATUS_CODE_404;
                    errorDetails = new ProductDetailWrapper.ErrorInformation(Constant.NOT_FOUND, Constant.PRODUCT_COUNTRY_MISSING);
                }
            }
            
            if(productDetailRecord!= null && !productDetailRecord.isEmpty()){
                //Creating Product Information wrapper
                productWrapperRecord = new ProductDetailWrapper.ProductInformation(productDetailRecord[0]);
            }
            else{
                //Setting error codes when product details records is not available
                if(errorDetails == null){
                    statusCode = Constant.STATUS_CODE_404;
                    errorDetails = new ProductDetailWrapper.ErrorInformation(Constant.NOT_FOUND, Constant.PRODUCT_NOT_FOUND);
                }
            }
        }
        //Catch for any unknown issue
        catch(Exception e){
            //Setting error codes for unknow issue
            if(errorDetails == null){
                statusCode = Constant.STATUS_CODE_500;
                errorDetails = new ProductDetailWrapper.ErrorInformation(Constant.BAD_REQUEST, e.getMessage());
            }
        }
        
        if(errorDetails != null){
            //Setting error information wrapper in static variable
        	strResponse = JSON.serialize(errorDetails);
        }
        else{
            //Setting status code and Product Information in static variable
            statusCode = Constant.STATUS_CODE_200;
            strResponse = JSON.serialize(productWrapperRecord);
        }
        
    }
}