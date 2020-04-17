/* eslint-disable no-console */
import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import retriveModelList from '@salesforce/apex/StockCheckCtrl.retrieveModelPicklist';

import retriveModelVarient from '@salesforce/apex/StockCheckCtrl.retriveModelVarient';
import retriveColorVarient from '@salesforce/apex/StockCheckCtrl.retriveColorVarient';
import retriveOutletAndForCodeInfo from '@salesforce/apex/StockCheckCtrl.retriveOutletAndForCodeInfo';
import retriveOutletAndForCodeFromAccount from '@salesforce/apex/StockCheckCtrl.retriveOutletAndForCodeFromAccount';
import findVariant from '@salesforce/apex/TestDriveFunctionality.findVariants';
import getAccountList from '@salesforce/apex/StockCheckCtrl.getAccounts';

import getProductStockList from '@salesforce/apexContinuation/MSILMuleSoftIntegration.getProductStockList';
import UI_Error_Message from '@salesforce/label/c.UI_Error_Message';

export default class StockCheck extends LightningElement {

// Before Search Component Data
@track isLoading = false;
@track records;
@track error;
@track selectedRecord;
@api index;
@api relationshipfield;
@api iconname = "standard:product";
@api objectName = 'Product2';
@api searchfield = 'Name';
@track colorOptions = [];
@track modelList=[];
@track selectedModel; // This variable is used to store selected Model
@track hideComponent = false;
@track showAccountSearchUI=false;
@track variants=[];
@track responseResult = [];
@track selectedVariant;
@track dealerAccountOptions = [];
@track accessoriesResultData=[];
@track accessoriesResultColumn=[];
@track colorVarientsRecords;
@track showNoDataError=false;
@track selectedColorVarientRecords;
@track selectedOutletType;
@track accountList;
@track selectedAccount;
@track variantCode = '';
@track colorCode = '';
@track dealerMapCode = '';
@track locationCode = '';
@track parentCode = '';

@track placeHolder = 'Enter Variant Name e.g. Spresso vxi , Baleno Delta';


@track showButton = false;
@track showDetails = false;
@track showOutletTypes = false;
@track tempShowOutletTypes = false;

@track typeValue; // This variable is used to store selected type
@track showModelVariant=false; // This variable is used to show/hide model variant search box
//@track showTypeCombobox=true; // This variable is used to show/hide type combobox
@track modelSearchBoxLabel=''; // This variable is used to pass modelSearchBoxLabel on basis of type selection
@track accessoriesTypeSelected=false; // This variable is used to show/hide accessories type selected or not

@api deviceFormFactor;
showAccountSearch=false;
consingneeCode=''; // This variable is used to store Consingnee Code of selected dealer Account
userType='E'; // This variable is used to account type Internal/External

carsColumns = [
   // { label: 'Model', fieldName: 'ModelDescription' },
    { label: 'Colour', fieldName: 'ColorDescription' },
   // { label: 'Variant', fieldName: 'Variant' },
    { label: 'Available', fieldName: 'Available', type: 'number', cellAttributes: { alignment: 'left' } },
    { label: 'Allotted', fieldName: 'Allotted', type: 'number', cellAttributes: { alignment: 'left' } },
    { label: 'InTransit', fieldName: 'InTransit', type: 'number', cellAttributes: { alignment: 'left' } }
];

accessoriesColumns = [
    { label: 'Part Name', fieldName: 'PartDescription' },
    { label: 'Part Number', fieldName: 'PartNumber' },
    { label: 'Available Stock', fieldName: 'Quantity', type: 'number', cellAttributes: { alignment: 'left' } }
]; 


@wire(retriveOutletAndForCodeInfo)
wiredCodeValue({data, error}){
    if (data) {
         
        this.hideComponent = data.hideComponent;
        this.showAccountSearch=data.showAccountSearch;
        this.dealerMapCode = data.dealerMapCode;
        this.locationCode = data.locationCode;
        this.parentCode = data.parentCode;

        if(data.accountList !== undefined && data.accountList.length > 0){
            this.tempShowOutletTypes = true;
            for(let i = 0; i<data.accountList.length; i++){
                let objInfo = {};
                objInfo.value = data.accountList[i].Id;
                let objLabel = data.accountList[i].Name +
                (data.accountList[i].Dealer_Location__c ? ( ' - ' + data.accountList[i].Dealer_Location__c ) : '' ) +
                 (data.accountList[i].BillingCity ? (' - ' +  data.accountList[i].BillingCity) : '');
                objInfo.label = objLabel;
                this.dealerAccountOptions.push(objInfo);
            }
            /*eslint-disable  no-console*/
            console.log('== dealerAccountOptions ', this.dealerAccountOptions);
        }
            
    } else if(error){
        /*eslint-disable  no-console*/
        console.log('== Code Error ', error);
    }
}
connectedCallback(){ 
    this.setModelPicklist();
}

//Method to set the model picklist based on logged in user dealership type (Nexa , Arena ..)
//Added as part of enhancement - DE 506
setModelPicklist(){
    retriveModelList({})
    .then(result => {

        let keyArray = [];
        let valueArray = [];

        Object.keys(result).forEach(function(key){
            keyArray.push(key);
        });

        Object.values(result).forEach(function(val){
            valueArray.push(val);
        }); 
 
        /* eslint-disable no-console */  
        
        for(let i=0;i<valueArray.length;i++){
            let obj = {label : keyArray[i], value : valueArray[i]} 
            this.modelList.push(obj);
        } 

        this.isLoading = false;
    })
    .catch(error => {
        this.error = error;
        this.records = undefined;
    });
}


handleOutletchange(event){ 
    getAccountList({name:event.detail.value})
    .then(result => {
        
        console.log(result);
        this.accountList=result.dataList;
        
    })
    .catch(error => {
        this.error = error;
        //this.loadSpinner=false;
        this.tostMessage(UI_Error_Message,0,'Error','');
    });
}
// This section is added by Sunit on 30-10-2019 for Accessories stock check update
/**** This function is used get type options ****/
get typeOptions()
{
    return[
        { label: 'Car', value:'C'},
        { label: 'Accessories', value:'A'}
    ];
}
/***********************************************/
handleVariantChange(event)
{
    this.selectedVariant=event.detail.value;
}
handleModelChange(event)
{
    this.selectedModel=event.detail.value;
    findVariant({searchVar:this.selectedModel})
    .then(result => { 
        //this.variants=result.dataList;
        this.variants=[];
        if(result.dataList.length>0)
            {
                result.dataList.forEach(element=>{
                    this.variants.push({label:element.Name, value:element.Id});
                    //this.variants = [...this.variants, {label:element.Name, value:element.ProductCode}];
                })
            }
        console.log(this.variants);
    })
    .catch(error => {
        this.error = error;
        //this.loadSpinner=false;
        this.tostMessage(UI_Error_Message,0,'Error','');
    });
}
tostMessage(message,code,status,id)
    {
        const showSuccess = new ShowToastEvent({
            title: status,
            message: message,
            variant: status,
        });
        this.dispatchEvent(showSuccess);
        if(code===200)
        { 
            this.redirct(id);
        }
        
    }
get OutletNameWithConsingneeCode()
{
    return this.selectedAccount.Name+' '+this.selectedAccount.Consingnee_Code__c;
}
/**** This function is used to handle onchange event of type dropdown  ****/

get lookupInputField() {
    return this.template.querySelector("c-lookup-input-field");
}

get showAccSearch(){
    return this.typeValue === 'A' ? true : false; 
}

get showVarSearch(){
    return this.typeValue === 'C' ? true : false; 
}

handleOutletCustomSearch(event){ 
    getAccountList({name:event.detail.searchTerm})
    .then(result => {
        
        console.log(result);
        this.accountList = result.dataList;
        let formatedResult = [];
        if(this.accountList){
            for (let data of this.accountList) {
                if(data){
                    let obj = {id : data.Id, title : data.Name + '   ' + data.Consingnee_Code__c};
                    formatedResult.push(obj);
                }
            }
        }
        console.log('== formatedResult ', formatedResult);
        if(formatedResult){
            this.lookupInputField.updateSearchResults(formatedResult);
        }

    })
    .catch(error => {
        this.error = error;
        //this.loadSpinner=false;
        this.tostMessage(UI_Error_Message,0,'Error','');
    });
}

handleOutletSelect(event){
    console.log('Inside handleOutletSelect');
    this.isLoading = true;
    const selectedRecordId = event.detail.value;
    console.log('== Record id ',selectedRecordId);
    console.log(this.accountList);
    this.selectedAccount = this.accountList.find( record => record.Id === selectedRecordId);
    this.dealerMapCode = this.selectedAccount.Dealer_Map_Code__c;
    this.locationCode = this.selectedAccount.Dealer_Location__c;
    this.parentCode = this.selectedAccount.Parent_Group__c;
    this.showButton = true;
    this.isLoading=false;
}

handleCustomSearch(event){
    console.log('== selectedVariant ', this.selectedVariant);
    console.log('== ON Custom Search 1 ', event.target.value);
    console.log('== ON Custom Search 2', event.detail.value);
    console.log('== ON Custom Search 3', event.detail.searchTerm);

    retriveModelVarient({
        name : event.detail.searchTerm,
        type: this.typeValue,
        variant: this.selectedVariant
    })
    .then(result => {
        console.log('== == ON Custom Search 3 Result ', result);
        this.records = result;
        let formatedResult = [];
        if(result){
            for (let data of result) {
                if(data){
                    let obj = {id : data.Id, title : data.Name, ProductCode : data.ProductCode};
                    formatedResult.push(obj);
                }
            }
        }
        console.log('== formatedResult ', formatedResult);
        if(formatedResult){
            this.lookupInputField.updateSearchResults(formatedResult);
        }

        if(result.length>0 && this.typeValue==='A' && this.tempShowOutletTypes){
            this.showOutletTypes = true;
        }   
        else if(result.length>0 && this.typeValue==='A' && this.showAccountSearch){
            this.showAccountSearchUI=true;
        }
        console.log(this.showAccountSearchUI);
        this.showButton=true;

    })
    .catch(error =>{
        console.log('== == ON Custom Search 3 Error ', error);
    })

}

handleProductSearch(event){
    console.log('== Search Product ', event.target.value);
    console.log('== Deatil Value ', event.detail.value);
    console.log('== Detail Search term ', event.detail.searchTerm);

    if(event.detail.value){
        const selectedRecordId = event.detail.value;
        this.selectedRecord = this.records.find( record => record.Id === selectedRecordId);
        console.log('== Selected Record ',this.selectedRecord);
        this.isLoading = true;
        if(this.typeValue==='C')
        {
            retriveColorVarient({
                productId : selectedRecordId
            })
            .then(result => {
                /*eslint-disable no-console */
                console.log('== Color Varient Result  ', result);
                this.colorVarientsRecords = result;
        
                if(result.length > 0){
                    this.variantCode = result[0].Variant__r.ProductCode;
                }
        
                this.colorOptions = [];
                this.colorOptions.push({label : 'All', value: '%25'});
                
                for(let i = 0; i<result.length; i++){
                    let objInfo = {};
                    objInfo.value = result[i].Color_Code__c;
                    objInfo.label = result[i].Name;
                    this.colorOptions.push(objInfo);
                }
                /*eslint-disable no-console */
                console.log('== Final color Options  ', this.colorOptions);
                //this.showButton = true;
                this.isLoading = false;
                this.records = undefined;
            })
            .catch(error => {
                /*eslint-disable no-console */
                console.log('== colorOptions Error ',error);
                this.isLoading = false;
            })
        }
        else{
            this.variantCode = this.records.find( record => record.Id === selectedRecordId).ProductCode;
            this.isLoading = false;
        }
    }else if(event.detail.value === undefined){
        this.handleRemove();
    }
}


handleTypeChange(event)
{
    this.typeValue=event.detail.value;
    if(event.detail.value==='C')
    {
        this.modelSearchBoxLabel='Search Model Variant';
        this.accessoriesTypeSelected=false;
        this.placeHolder = 'Enter Variant Name e.g. Spresso vxi , Baleno Delta'
    }
    else if(event.detail.value==='A')
    {
        this.modelSearchBoxLabel='Part Name';
        this.accessoriesTypeSelected=true;
        //this.showButton=true;
        this.placeHolder = 'Enter Accessories Description or Accessories Code'
    }
    if(event.detail.value==='C' && this.showAccountSearch)
    {
        this.hideComponent=true;
        this.placeHolder = 'Enter Variant Name e.g. Spresso vxi , Baleno Delta'
    }
    this.showModelVariant=true;
    //this.showTypeCombobox=false;

    this.selectedModel = undefined;
    this.selectedVariant = undefined;
    this.showAccountSearchUI = false;
    this.handleRemove();
}
/**************************************************************************/

handleOnchange(event){
    this.isLoading = true;
    //event.preventDefault();
    const searchKey = event.detail.value;
    //this.records = null;
    /* eslint-disable no-console */

    /* Call the Salesforce Apex class method to find the Records */
    retriveModelVarient({
        name : searchKey,
        type: this.typeValue,
        variant: this.selectedVariant
    })
    .then(result => {
        /* eslint-disable no-console */
        this.records = result;
        this.error = undefined;
        if(result.length>0 && this.typeValue==='A' && this.tempShowOutletTypes){
            this.showOutletTypes = true;
        }
        else if(result.length>0 && this.typeValue==='A' && this.showAccountSearch){
            this.showAccountSearchUI=true;
        }
        this.showButton=true;
        this.isLoading = false;
    })
    .catch(error => {
        this.error = error;
        this.records = undefined;
    });
}

handleSelect(event){
    this.isLoading = true;
    const selectedRecordId = event.detail;
    /* eslint-disable no-console*/
    console.log('== Record id ',selectedRecordId);

    this.selectedRecord = this.records.find( record => record.Id === selectedRecordId);
    console.log('== Selected Record ',this.selectedRecord);

    if(this.typeValue==='C')
    {
        retriveColorVarient({
            productId : selectedRecordId
        })
        .then(result => {
            /*eslint-disable no-console */
            console.log('== Color Varient Result  ', result);
            this.colorVarientsRecords = result;
    
            if(result.length > 0){
                this.variantCode = result[0].Variant__r.ProductCode;
            }
    
            this.colorOptions = [];
            this.colorOptions.push({label : 'All', value: '%25'});
            
            for(let i = 0; i<result.length; i++){
                let objInfo = {};
                objInfo.value = result[i].Color_Code__c;
                objInfo.label = result[i].Name;
                this.colorOptions.push(objInfo);
            }
            /*eslint-disable no-console */
            console.log('== Final color Options  ', this.colorOptions);
            //this.showButton = true;
            this.isLoading = false;
            this.records = undefined;
        })
        .catch(error => {
            /*eslint-disable no-console */
            console.log('== colorOptions Error ',error);
            this.isLoading = false;
        })
    }
    else{
        this.variantCode = this.records.find( record => record.Id === selectedRecordId).ProductCode;
        this.isLoading = false;
    }
   

}

handleDealerAccountSelect(event){
    this.isLoading = true;
    this.showButton = true;
    this.showDetails = false;
    // this.selectedOutletType = event.target.value;
    /* eslint-disable no-console*/
    console.log('== Selected Outlet type ', event.target.value);

    retriveOutletAndForCodeFromAccount({
        accountId : event.target.value
    })
    .then(result => {
        /*eslint-disable no-console */
        console.log('== Outlet And For Code Result  ', result);
        this.dealerMapCode = result.dealerMapCode;
        this.locationCode = result.locationCode;
        this.parentCode = result.parentCode;
        this.consingneeCode=result.consingneeCode;
        this.userType='I';
        this.isLoading = false;
    })
    .catch(error => {
        /*eslint-disable no-console */
        console.log('== colorOptions Error ',error);
        this.isLoading = false;
    })
}

handleColor(event){
    event.preventDefault();
    
    this.showDetails = false;
    this.selectedOutletType = undefined;
    if(this.tempShowOutletTypes){
        this.showOutletTypes = true;
        this.showButton = false;
    }else{
        this.showOutletTypes = false;
        this.showButton = true;
    }

    this.colorCode = event.target.value;
}

handleRemove(){
    this.selectedRecord = undefined;
    this.showOutletTypes = false;
    this.showDetails = false;
    this.showButton = false;
    this.records = undefined;
    this.error = undefined;
}

handleOutletRemove(event){
    event.preventDefault();
    //this.selectedRecord = undefined;
    //this.showOutletTypes = false;
    //this.showDetails = false;
    //this.accessoriesTypeSelected=false;
    this.selectedAccount=undefined;
    this.showButton = false;

    //this.records = undefined;
    //this.error = undefined;
}

// After Search Component Data

checkStock(){
    this.isLoading = true;
    
    /*eslint-disable  no-console*/
    console.log('== VariantCode ', this.variantCode);
    console.log('== ColorCode ', this.colorCode);
    console.log('== dealerMapCode ', this.dealerMapCode);
    console.log('== locationCode ',this.locationCode);
    console.log('== parentCode ',this.parentCode);
    console.log('== productType ',this.typeValue);
    
    /*
    getProductStockList({
        apiType : 'Product Stock List',
        variantCode : 'AKA4AVA',
        colorCode : '26U',
        dealerMapCode : '10933',
        locationCode : 'NDS',
        parentCode : 'AAA'
    })
    */
   let stoctCheckQueryData={
    "apiType" : "Product Stock List",
    "variantCode" : this.variantCode,
    "colorCode" : this.colorCode,
    "dealerMapCode" : this.dealerMapCode,
    "locationCode" : this.locationCode,
    "parentCode" : this.parentCode,
    "productType":this.typeValue,
    "consingneeCode":this.consingneeCode,
    "userType":this.userType
};
    getProductStockList({queryData:JSON.stringify(stoctCheckQueryData)})
    .then(result =>{
        
        /*eslint-disable  no-console*/
        console.log('== In Fetch Result ', result);
        if(result === UI_Error_Message){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: '',
                    message: UI_Error_Message,
                    variant: 'error'
                })
            );
         }else{
            let dataValue = JSON.parse(result);
            this.responseResult = dataValue.productStockList;
            console.log(this.responseResult.length);
            if(this.responseResult.length===0)
            {
                this.showNoDataError=true;
            }
            else{
                this.showNoDataError=false;
            }
            console.log(this.showNoDataError);
            console.log('== List Result ', this.responseResult);
            this.showDetails = true;
         }
        this.isLoading = false;
    })
    .catch(error =>{
        this.isLoading = false;
        /*eslint-disable  no-console*/
        console.log('== In Fetch Error ', error);
        this.dispatchEvent(
            new ShowToastEvent({
                title: '',
                message: UI_Error_Message,
                variant: 'error'
            })
        );
    })
}

get browserFormFactor(){
    return this.deviceFormFactor==='DESKTOP' ? true : false;
}

}