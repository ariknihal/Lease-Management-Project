import { LightningElement, api } from 'lwc';
import upcomingLeasing from "@salesforce/apex/ClientLeasingService.upcomingLeasing";
import pastLeasing from "@salesforce/apex/ClientLeasingService.pastLeasing";
const COLUMNS = [
    {
        label: "Leasing Name",
        fieldName: "detailsPage",
        type: "url",
        wrapText: "true",
        typeAttributes: {
            label: {
                fieldName: "Name"
            }
        }
    },
    {
        label: "Name",
        fieldName: "LEASINGORG",
        cellAttributes: {
            iconName: "standard:user",
            iconPosition: "left"
        }
    },
    {
        label: "Leasing Date",
        fieldName: "StartDateTime",
        type: "date",
        typeAttributes: {
            weekday: "long",
            year: "numeric",
            month: "long"
        }
    },
    {
        label: "Location",
        fieldName: "Location",
        type: "text",
        cellAttributes: {
            iconName: "utility:location",
            iconPosition: "left"
        }
    }
];
export default class ClientLeasing extends LightningElement {
    @api recordId;
    selectedLeasing;
    upcomingLeasing;
    pastLeasing;
    columnsList = COLUMNS;
    errors;
    retrievedRecordId = false;
    renderedCallback() {
        console.log("renderedCallback");
        if (!this.retrievedRecordId && this.recordId) {
            // Escape case from recursion
            this.retrievedRecordId = true;
            console.log("found recordId: " + this.recordId);
            this.upcomingLeasingFromApex();
            this.pastLeasingFromApex();
        }
    }
    upcomingLeasingFromApex() {
        upcomingLeasing({ potentialclientId: this.recordId })
            .then((result) => {
                console.log("result: " + JSON.stringify(result));
                this.upcomingLeasing = [];
                this.selectedLeasing = [];
                result.forEach((record) => {
                    let obj = { 
                        id: record.leasingId,
                        Name: record.leasing.Name__c,
                        detailsPage: "https://" + window.location.host + "/" + record.leasing.Id,
                        LEASINGORG: record.leasing.Lease_Office_Manager__r.Name,
                        StartDateTime: record.leasing.Start_Date_Time__c,
                        Location: record.leasing.Location__c ? record.leasing.Location__r.Name : "This is a virtual leasing"
                    };
                    this.upcomingLeasing.push(obj);
                    if (record.isMember) {
                        this.selectedLeasing.push(obj.id);
                    }
                });
                this.errors = undefined;
            })
            .catch((error) => {
                this.upcomingLeasing = undefined;
                this.errors = JSON.stringify(error);
            });
    }
    pastLeasingFromApex() {
        pastLeasing({ 
            potentialclientId: this.recordId 
        })
            .then((result) => {
                this.pastLeasing = [];
                result.forEach((record) => {
                    let pastLease = {
                        Name: record.Leasing__r.Name__c,
                        detailsPage: "https://" + window.location.host + "/" + record.Leasing__c,
                        LEASINGORG: record.Leasing__r.Lease_Office_Manager__r.Name,
                        StartDateTime: record.Leasing__r.Start_Date_Time__c,
                        Location: record.Leasing__r.Location__c ? record.Leasing__r.Location__r.Name : "This is a virtual leasing"
                    };
                    this.pastLeasing.push(pastLease);
                });
                this.errors = undefined;
            })
            .catch((error) => {
                this.pastLeasing = undefined;
                this.errors = JSON.stringify(error);
            });
    }
}