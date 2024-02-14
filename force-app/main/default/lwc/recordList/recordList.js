import { LightningElement, api } from 'lwc';

export default class RecordList extends LightningElement {

    @api rec;
    @api iconName = 'standard:event';

    handleSelect(){
        let selectLease = new CustomEvent('select', {
            detail: {
                selRec : this.rec
            }
        });
        this.dispatchEvent(selectLease);
    }

    handleRemove(){
        let selectLease  = new CustomEvent('select', {
            detail: {
                selRec : undefined
            }
        });
        this.dispatchEvent(selectLease);
    }
}