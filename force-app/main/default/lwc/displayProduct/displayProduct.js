import { LightningElement,api, wire, track } from 'lwc';
import getProductDetails from '@salesforce/apex/ProductDetailController.getProductDetails';
import PRODUCT_DETAIL_OBJECT from '@salesforce/schema/Product_Detail__c';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class DisplayProduct extends LightningElement {
    @api recordId;
    @track productDetail;
    productDetailLabel;
    countryCodeLabel;
    costPerCalendarMonthLabel;
    atmFeeInOtherCurrenciesLabel;
    cardReplacementCostLabel;
    headerValue = ' Product Information';
    isCostPerCalendarMonthApplicable;
    isATMFeeFree;
    NOT_APPLICABLE = 'N/a';
    FREE = 'Free';
    
    @wire(getObjectInfo, { objectApiName: PRODUCT_DETAIL_OBJECT }) oppInfo({ data, error }) {
        if (data){
            this.productDetailLabel = data.fields.Product__c.label + ' : ';
            this.countryCodeLabel = data.fields.Country_Code__c.label + ' : ';
            this.costPerCalendarMonthLabel = data.fields.Cost_per_Calendar_Month__c.label + ' : ';
            this.atmFeeInOtherCurrenciesLabel = data.fields.ATM_Fee_in_other_currencies__c.label + ' : ';
            this.cardReplacementCostLabel = data.fields.Card_Replacement_Cost__c.label + ' : ';
            this.error = undefined;
        }
        else{
            this.error = error;
            this.productDetailLabel = undefined;
        }
    }
    
    @wire(getProductDetails,{caseId:'$recordId'}) WireProductDetailRecords({error, data}){
        if(data){
            this.productDetail = data[0];
            this.error = undefined;
        }else{
            this.error = error;
            this.productDetail = undefined;
        }
    }
}