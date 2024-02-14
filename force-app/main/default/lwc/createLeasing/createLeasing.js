import { LightningElement, api } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import LEASING_OBJECT from '@salesforce/schema/Leasing__c';
import NAME_FIELD from '@salesforce/schema/Leasing__c.Name__c';
import MANAGER_FIELD from '@salesforce/schema/Leasing__c.Lease_Office_Manager__c';
import STARTDATETIME_FIELD from '@salesforce/schema/Leasing__c.Start_Date_Time__c';
import ENDDATETIME_FIELD from '@salesforce/schema/Leasing__c.End_Date_Time__c';
import MAXPOTENCIALCLIENT_FIELD from '@salesforce/schema/Leasing__c.Max_Potential_Client__c';
import LOCATION_FIELD from '@salesforce/schema/Leasing__c.Leasing_Office_Location__c';
import LEASEDETAIL_FIELD from '@salesforce/schema/Leasing__c.Leasing_Detail__c';
import STATUS_FIELD from '@salesforce/schema/Leasing__c.Status__c';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateService extends NavigationMixin(LightningElement) {
    @api leaseRecord = {
        Name__c: '',
        Lease_Office_Manager__c: '',
        Start_Date_Time__c: null,
        End_Date_Time__c: null,
        Max_Potential_Client__c: null,
        Leasing_Office_Location__c: '',
        Leasing_Detail__c: ''
    };
    errors;
    handleChange(event) {
        let value = event.target.value;
        let name = event.target.name;
        this.leaseRecord[name] = value;
    }
    handleLookup(event) {
        let selectedRecId = event.detail.selectedRecordId;
        let parentField = event.detail.parentfield;
        this.leaseRecord[parentField] = selectedRecId;
    }
    handleClick() {
        const fields = {};
        fields[NAME_FIELD.fieldApiName] = this.leaseRecord.Name__c;
        fields[MANAGER_FIELD.fieldApiName] = this.leaseRecord.Lease_Office_Manager__c;
        fields[STARTDATETIME_FIELD.fieldApiName] = this.leaseRecord.Start_Date_Time__c;
        fields[ENDDATETIME_FIELD.fieldApiName] = this.leaseRecord.End_Date_Time__c;
        fields[MAXPOTENCIALCLIENT_FIELD.fieldApiName] = this.leaseRecord.Max_Potential_Client__c;
        fields[LOCATION_FIELD.fieldApiName] = this.leaseRecord.Leasing_Office_Location__c;
        fields[LEASEDETAIL_FIELD.fieldApiName] = this.leaseRecord.Leasing_Detail__c;
        fields[STATUS_FIELD.fieldApiName] = 'Created';
        const leaseRecord = {
            apiName: LEASING_OBJECT.objectApiName,
            fields
        };
        createRecord(leaseRecord)
            .then((serviceRec) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Record Saved',
                        message: 'Lease Draft is Ready',
                        variant: 'success'
                    })
                );
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        actionName: 'view',
                        recordId: serviceRec.id
                    }
                });
            })
            .catch((err) => {
                this.errors = JSON.stringify(err);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error Occurred',
                        message: this.errors,
                        variant: 'error'
                    })
                );
            });
    }
}