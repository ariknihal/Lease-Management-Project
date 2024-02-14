// import { LightningElement, api } from 'lwc';

// import findLeasing from '@salesforce/apex/EditMembershipService.findLeasing';
// import manageMembership from '@salesforce/apex/EditMembershipService.manageMembership';
// import {ShowToastEvent} from 'lightning/platformShowToastEvent';

// import {CloseActionScreenEvent} from 'lightning/actions';

// const COLUMNS = [
//     {
//         label: "Leasing Name",
//         fieldName: "detailsPage",
//         type: "url",
//         wrapText: "true",
//         typeAttributes: {
//             label: {
//                 fieldName: "Name"
//             }
//         }
//     },
//     {
//         label: "Name",
//         fieldName: "LEASINGORG",
//         cellAttributes: {
//             iconName: "standard:user",
//             iconPosition: "left"
//         }
//     },
//     {
//         label: "Leasing Date",
//         fieldName: "StartDateTime",
//         type: "date",
//         typeAttributes: {
//             weekday: "long",
//             year: "numeric",
//             month: "long"
//         }
//     },
//     {
//         label: "Location",
//         fieldName: "Location",
//         type: "text",
//         cellAttributes: {
//             iconName: "utility:location",
//             iconPosition: "left"
//         }
//     }
// ];


// export default class EditMembership extends LightningElement {

//     //to be set by flow
//     @api recordId;
//     @api selection; // add or clear meaning insert or delete

//     leasing;
//     columnsList = COLUMNS;
//     errors;

//     retrievedRecordId = false;

//     renderedCallback() {
       
//         if (!this.retrievedRecordId && this.recordId) {
         
//             console.log("recordId: " + this.recordId);
//             console.log("selection: " + this.selection);

//             //escape case from recursion

//             this.retrievedRecordId = true;

//             console.log("found recordId" + this.recordId);

//             this.workOnEvents();
//         }
//     }

//     workOnEvents(){

//         findLeasing({
//         potentialclientId: this.recordId,
//         selection: this.selection

//     })
//     .then((result) => {
//         this.leasing = [];
//         result.forEach((record)=>{
//             let obj = new Object();
// obj.id = record.leasingId;
// obj.Name = record.leasing.Name__c;
// obj.detailsPage = "https://" + window.location.host + "/" + record.leasing.Id;
// obj.LEASINGORG = record.leasing.Lease_Office_Manager__r.Name;
// obj.StartDateTime = record.leasing.Start_Date_Time__c;
          

// if (record.leasing.Leasing_Office_Location__c) {
//     obj.Location = record.leasing.Leasing_Office_Location__r.Name;
// } else {
//     obj.Location = 'this is a virtual leasing';
// }
//             this.leasing.push(obj);

//         });
//         this.errors = undefined;
//     })
//     .catch((error) => {
//         this.leasing =undefined;
//         this.errors = error.message;
//     });

//     }

//     handleClick(leasing){
//         let selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
//         console.log('selectedRecords' + JSON.stringify(selectedRecords));

//         let ids = [];
//         selectedRecords.forEach((line) => {
//             ids.push(line.id);

//         });

//         console.log('ids' + ids);

//         manageMembership ({
//             potentialclientId: this.recordId,
//             leasingIds: ids,
//             selection: this.selection
            
//         })

//         .then((result) => {
//             console.log('result:' + result);

//             if(result){
//                 this.showNotification('Successful Operation' , 'That worked great', 'success');
//                 this.dispatchEvent(new CloseActionScreenEvent());

//             }else{
//                 this.showNotification('Error' , 'Oppppssss' , 'error');

//             }
//         })
//         .catch((error) =>{
//             this.errors =error.message;
//             this.showNotification('Error' , error.message, 'error');
//         });

//     }

//     showNotification(title, message, variant) {
//         const leasing = new ShowToastEvent({
//             title: title,
//             message:message,
//             variant: variant
//         });
//         this.dispatchEvent(leasing);
//     }


// }

import { LightningElement, api } from 'lwc';
import findLeasing from '@salesforce/apex/EditMembershipService.findLeasing';
import manageMembership from '@salesforce/apex/EditMembershipService.manageMembership';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

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

export default class EditMembership extends LightningElement {
    @api recordId;
    @api selection;
    leasing;
    columnsList = COLUMNS;
    errors;
    retrievedRecordId = false;

    renderedCallback() {
        if (!this.retrievedRecordId && this.recordId) {
            this.retrievedRecordId = true;
            this.workOnEvents();
        }
    }

    workOnEvents() {
        findLeasing({ potentialclientId: this.recordId, selection: this.selection })
            .then((result) => {
                this.leasing = [];
                result.forEach((record) => {
                    let obj = {
                        id: record.leasingId,
                        Name: record.leasing.Name,
                        detailsPage: "https://" + window.location.host + "/" + record.leasing.Id,
                        LEASINGORG: record.leasing.Lease_Office_Manager__r.Name,
                        StartDateTime: record.leasing.Start_Date_Time__c
                    };

                    if (record.leasing.Leasing_Office_Location__c) {
                        obj.Location = record.leasing.Leasing_Office_Location__r.Name;
                    } else {
                        obj.Location = 'this is a virtual leasing';
                    }
                    this.leasing.push(obj);
                });
                this.errors = undefined;
            })
            .catch((error) => {
                this.leasing = undefined;
                this.errors = error.message;
            });
    }

    handleClick(leasing) {
        let selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
        let ids = [];
        selectedRecords.forEach((line) => {
            ids.push(line.id);
        });

        manageMembership({ potentialclientId: this.recordId, leasingIds: ids, selection: this.selection })
            .then((result) => {
                if (result) {
                    this.showNotification('Successful Operation', 'That worked great', 'success');
                    this.dispatchEvent(new CloseActionScreenEvent());
                } else {
                    this.showNotification('Error', 'Oppppssss', 'error');
                }
            })
            .catch((error) => {
                this.errors = error.message;
                this.showNotification('Error', error.message, 'error');
            });
    }

    showNotification(title, message, variant) {
        const leasing = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(leasing);
    }
}
