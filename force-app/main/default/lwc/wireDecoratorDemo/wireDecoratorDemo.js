import { LightningElement, api, wire, track } from 'lwc';
import {getRecord, getFieldValue} from 'lightning/uiRecordApi';

const fields = [
    'Opportunity.Name',
    'Opportunity.StageName'
];

export default class WireDecoratorDemo extends LightningElement {
    @api recordId;
    @track name; 
    @track stageName; 

    @wire(getRecord, { recordId: '$recordId', fields: fields })
    receivedData({ error, data }) {
        if (data) {
            this.name = getFieldValue(data, fields[0]);
            this.stageName = getFieldValue(data, fields[1]);
            console.log();
        } else if (error) {
            console.error(error);
        }
    }
    
    handleChange(e) {
        this.name = e.target.value;
    }
    
}