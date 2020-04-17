/* eslint-disable no-console */

import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//Fetch dummy data from Apex. To be replaced with continuation for final integration
import fetchSelectedSVOCDetails from '@salesforce/apexContinuation/FetchSVOCDetails.fetchSelectedSVOCDetails';
import updateDSEAccountForSVOCCounter from '@salesforce/apex/FetchSVOCDetails.updateDSEAccountForSVOCCounter';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import SVOC_ID_FIELD from '@salesforce/schema/Opportunity.SVOC_ID__c';
import VIN_FIELD from '@salesforce/schema/Asset.VIN__c';

import UI_Error_Message from '@salesforce/label/c.UI_Error_Message';
import Missing_Field_Error_Message from '@salesforce/label/c.SVOC_Detail_Missing_Fields';

export default class LightningExampleAccordionBasic extends LightningElement {
    @api recordId;
    @api svocsection = 'Loyalty';
    @api typeOfSection = 'Table';

    @track activeIcon = 'utility:chevronright';
    @track showSpinner = false;
    @track errorMessage;

    @track data = [];
    @track columns = [];

    @wire(getRecord, { recordId: '$recordId', fields: [SVOC_ID_FIELD] }) opportunity;
    @wire(getRecord, { recordId: '$recordId', fields: [VIN_FIELD] }) asset;

    get svocId() { return getFieldValue(this.opportunity.data, SVOC_ID_FIELD); }
    get vin() { return getFieldValue(this.asset.data, VIN_FIELD); }

    //Function called when clicked on expand/collapse section
    //Sets the value of svoc data to the sections
    handleToggleSection() {
        let secObj = this.template.querySelector('[data-id="detail-section"]');
        if (secObj.classList.contains('slds-is-open')) {
            secObj.classList.remove('slds-is-open');
            this.activeIcon = 'utility:chevronright';
        } else {
            secObj.classList.add('slds-is-open');
            this.activeIcon = 'utility:chevrondown';
            if (this.svocId || this.vin) {
                this.fetchSelectedSVOCDetails();
            } else {
                this.handleError(Missing_Field_Error_Message);
            }
        }
    }
    //Call server method to get the API response and show it in table
    fetchSelectedSVOCDetails() {
        this.showSpinner = true;
        fetchSelectedSVOCDetails({ 
            svocDetail: this.svocsection, 
            svocId: this.svocId, 
            vin: this.vin 
        }).then(result => {
            //console.log("result", JSON.parse(JSON.stringify(result)));
            //console.log("rawResponse", JSON.parse(result.data.rawResponse));
            if (result.code === 200 && result.status === 'Success') {
                this.initDataTable(result.data);
				console.log('success rahul 62');
				this.updateDSEAccountForSVOCCounter(result.data);
            } else {
                this.handleError(UI_Error_Message);
				console.log('success rahul 67');
				this.updateDSEAccountForSVOCCounter(result.data);
            }
            this.showSpinner = false;
        }).catch(error => {
            this.showSpinner = false;
            this.handleError(UI_Error_Message);
            console.error(error);
        });
    }
	 //Call server method to update the counter of SVOC accessed on DSE account
    updateDSEAccountForSVOCCounter() {
		console.log('success rahul 77');
        updateDSEAccountForSVOCCounter( 
             ).then(result => {
			console.log('success rahul 83');
        }).catch(error => {
            console.log('error');
        });
    }
    initDataTable(data) {
        let types = { 
            boolean: new Set(),
            date: new Set() 
        };
        this.data = data.fieldValueWrapList.map((item, ind1) => {
            return item.svocFieldValue.reduce((row, value, ind2) => {
                let col = data.keys[ind2];
                row[col] = this.parseValue(col, value, types);
                return row;
            }, { id: ind1 });
        });
        this.columns = data.svocFielLabelList.map((item, ind) => {
            let col = data.keys[ind];
            return {
                label: item,
                fieldName: col,
                type: types.boolean.has(col) ? 'boolean' : 
                    types.date.has(col) ? 'date' : 'text'
            };
        });
        this.recordsCount = String(this.data.length > 25 ? '25+' : this.data.length);
        if(!this.data.length){
            this.errorMessage = "No data found";
        }
    }
    parseValue(key, value, types){
        if(value){
            switch(key){
                case 'StartDate':
                    types.date.add(key);
                    break;
                case 'EndDate': 
                    if(new Date(value) > new Date()){
                        value = "";
                    }
                    types.date.add(key);
                    break;
                default:
            }  
            switch(value){
                case 'true': 
                case 'false':
                    value = (value === 'true'); 
                    types.boolean.add(key); 
                    break;
                default:
            }
        }
        return value;
    }
    handleError(message) {
        this.errorMessage = message;
        const toastEvent = new ShowToastEvent({
            title: status,
            message: message,
            variant: 'error',
        });
        this.dispatchEvent(toastEvent);
    }
}