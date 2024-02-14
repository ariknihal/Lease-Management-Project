import { LightningElement, track } from 'lwc';

import searchByKeyword from '@salesforce/apex/LeasingDetails.searchByKeyword';


const COLUMNS = [
    {
        label: "View",
        fieldName: "detailsPage",
        type: "url",
        wrapText: "true",
        typeAttributes: {
            label: {
                fieldName: "Name__c"
            },
            target: "_self"
        }
    },
    {
        label: "Name",
        fieldName: "Name__c",
        wrapText: "true",
        cellAttributes: {
            iconName: "standard:event",
            iconPosition: "left"
        }
    },
    {
        label: "Manager",
        fieldName: "manager",
        wrapText: "true",
        cellAttributes: {
            iconName: "standard:user",
            iconPosition: "left"
        }
    },
    {
        label: "Location",
        fieldName: "Location",
        wrapText: "true",
        cellAttributes: {
            iconName: "utility:location",
            iconPosition: "left"
        }
    }
];

export default class LeasingList extends LightningElement {
    columnsList = COLUMNS;
    error;
    startDateTime;

    @track recordsToDisplay;
    @track result;

    handleSearch(event) {
        let keyword = event.detail.value;

        if(keyword && keyword.length >= 2){
            searchByKeyword({
                name: keyword
            })
            .then((data) => {
                console.log("data:" + JSON.stringify(data));

                data.forEach((record) => {
                    record.detailsPage = "https://" + window.location.host + "/" + record.Id;
                    record.manager = record.Lease_Office_Manager__r.Name;

                    if(record.Leasing_Office_Location__c) {
                        record.Location = record.Leasing_Office_Location__r.Name;
                    } else {
                        record.Location = "This is Virtual Lease";
                    }
                });
                this.result = data;
                this.recordsToDisplay = data;
                this.error = undefined;
            })
            .catch((err) => {
                console.log ('ERR:' + JSON.stringify(err));
                this.error = JSON.stringify(err);
                this.result = undefined;
            });
        }
    }

    handleStartDate(event) {
        let valuedatetime = event.target.value;
        console.log("selectedDate:" + valuedatetime);

        let filteredServices = this.result.filter ((record, index, arrayobject) => {
            return record.Start_Date_Time__c >= valuedatetime;
        });
        this.recordsToDisplay = filteredServices;
    }

    handleLocationSearch(event){
        let keyword = event.detail.value;

        let filteredServices = this.result.filter((record, index, arrayobject) => {
            return record.Location.toLowerCase().includes(keyword.toLowerCase());
        });
        if(keyword && keyword.length >=2) {
            this.recordsToDisplay = filteredServices;
        }else {
            this.recordsToDisplay = this.result;
        }
    }
}