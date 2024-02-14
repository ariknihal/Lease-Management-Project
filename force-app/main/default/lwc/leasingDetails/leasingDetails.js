import { LightningElement, api, track, wire } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import { NavigationMixin } from "lightning/navigation";
import { encodeDefaultFieldValues } from "lightning/pageReferenceUtils";
import id from "@salesforce/user/Id";
import profile from "@salesforce/schema/User.Profile.Name";
import getLeasingRealEstateAgent from '@salesforce/apex/LeasingDetailsController.getLeasingRealEstateAgent';
import getLocationDetails from '@salesforce/apex/LeasingDetailsController.getLocationDetails';
import getClients from '@salesforce/apex/LeasingDetailsController.getClients';

const COLUMNS = [
    {
        label: "Name",
        fieldName: "Name",
        cellAttributes: {
            iconName: "standard:user",
            iconPosition: "left"
        }
    },
    {
        label: "Email",
        fieldName: "Email",
        type: "email"
    },
    {
        label: "Company Name",
        fieldName: "Company Name"
    },
    {
        label: "Location",
        fieldName: "Location",
        cellAttributes: {
            iconName: "utility:location",
            iconPosition: "left"
        }
    }
];

export default class LeasingDetails extends NavigationMixin(LightningElement) {
    @api recordId;
    @track isAdmin = false;
    @track realestateagentList;
    @track leaseRec;
    @track clientList;
    errors;
    userId = id;
    columnsList = COLUMNS;

    @wire(getRecord, { recordId: '$userId', fields: [profile] })
    wiredMethod({ error, data }) {
        if (data) {
            window.console.log("userRecord:", JSON.stringify(data));
            let userProfileName = data.fields.Profile.displayValue;
            console.log("userProfileName:" + userProfileName);
            this.isAdmin = userProfileName === "System Administrator";
        }
        if (error) {
            console.log("Error Occurred ", JSON.stringify(error));
        }
    }

    createRealEstateAgent(event) {
        const defaultValues = encodeDefaultFieldValues({
            Leasing__c: this.recordId
        });

        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
                objectApiName: "Leasing_Real_Estate_Agent__c",
                actionName: "new"
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
    }

    handleAgentActive() {
        getLeasingRealEstateAgent({
            leasingId: this.recordId
        })
        .then((result) => {
            result.forEach((agent) => {
                agent.Name = agent.Real_Estate_Agent__r.Name;
                agent.Email__c = "************@gmail.com";
                agent.Phone__c = agent.Real_Estate_Agent__r.Phone__c;
                agent.Profile__c = agent.Real_Estate_Agent__r.Profile__c;
                agent.About_Me__c = agent.Real_Estate_Agent__r.About_Me__c;
            });

            this.realestateagentList = result;
            this.errors = undefined;

            console.log("result", JSON.stringify(result));
        })
        .catch((err) => {
            this.errors = err;
            this.realestateagentList = undefined;
            console.log("ERR:", this.errors);
        });
    }

    handleLocationDetails() {
        getLocationDetails({
            leasingId: this.recordId
        })
        .then((result) => {
            if (result.Leasing_Office_Location__c) {
                this.leaseRec = result;
            } else {
                this.leaseRec = undefined;
            }
            this.errors = undefined;
        })
        .catch((err) => {
            this.errors = err;
            this.realestateagentList = undefined;
        });
    }

    handleServiceClient() {
        getClients({
            leasingId: this.recordId
        })
        .then((result) => {
            result.forEach((clnt) => {
                clnt.Name = clnt.Potential_Client__r.Name;
                clnt.Email = "************@gmail.com";

                if (clnt.Potential_Client__r.Leasing_Office_Location__c) {
                    clnt.Location = clnt.Potential_Client__r.Leasing_Office_Location__r.Name;
                } else {
                    clnt.Location = "Prefer Not to Say";
                }
            });
            this.clientList = result;
            this.errors = undefined;
        })
        .catch((err) => {
            this.errors = err;
            this.realestateagentList = undefined;
        });
    }

    createClient() {
        const defaultValues = encodeDefaultFieldValues({
            Leasing__c: this.recordId
        });

        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
                objectApiName: "Leasing_Potential_Client__c",
                actionName: "new"
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
    }
}
