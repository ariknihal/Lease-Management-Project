import { LightningElement, api, track } from 'lwc';
import searchRecords from '@salesforce/apex/SearchController.searchRecords';

export default class CustomLookup extends LightningElement {

    @api objectName = 'Leasing__c';
    @api fieldName = 'Name';
    @api iconName = 'standard:record';
    @api label = 'Lease';
    @api parentIdField = 'Leasing__c';

    //private property
    @track records;
    @track selectedRecord;

    handleSearch(event) {
        var searchVal = event.detail.value;

        searchRecords({
            objName : this.objectName,
            fieldName : this.fieldName,
            searchKey : searchVal
        })
        .then(data => {
            if(data){
                let parsedResponse = JSON.parse(data);
                let searchRecordList = parsedResponse[0];
                for (let i = 0; i < searchRecordList.length; i++) {
                    let record = searchRecordList[i];
                    record.Name = record[this.fieldName];   
                }
                this.records = searchRecordList;
            }
        }).catch(error => {
            window.console.log('ERR:', JSON.stringify(error));
        });
    }

    handleSelect(event){
        var selectedVal = event.detail.selRec;
        this.selectedRecord = selectedVal;
        
        let finalRecEvent = new CustomEvent('select',{
            detail:
            {
                selectedRecordId : this.selectedRecord.Id,
                parentfield : this.parentIdField
            }
        });
        this.dispatchEvent(finalRecEvent);
    }

    handleRemove(){
        this.selectedRecord = undefined;
        this.records =undefined;

        let finalRecEvent = new CustomEvent('select', {
            detail :{
                selectedRecordId : undefined,
                parentfield : this.parentIdField
            }
        });
        this.dispatchEvent(finalRecEvent);
    }

}