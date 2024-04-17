import { LightningElement, api, wire, track } from 'lwc';
import {getRecord, getFieldValue} from 'lightning/uiRecordApi';

const fields = [
    'Account.Id',
    'Account.Name',
    'Account.Phone',
    'Account.Website',
    'Account.Type'
];

export default function getDynamicData(){
    return [
        {
            rowNum : 1,
            name: `Hello Name`,
            website: 'www.salesforce.com',
            phone: `${Math.floor(Math.random() * 9000000000) + 1000000000}`,
            accountType : 'New Account'
        },
        {
            rowNum : 2,
            name: `Hello Name`,
            website: 'www.salesforce.com',
            phone: `${Math.floor(Math.random() * 9000000000) + 1000000000}`,
            accountType : 'New Account'
        }
    ];
}

class getDataFormApex extends LightningElement {
    @api recordId;
    @track name; 
    @track stageName; 

    @wire(getRecord, { recordId: '$recordId', fields: fields })
    receivedData({ error, data }) {
        if (data) {
            // this.name = getFieldValue(data, fields[0]);
            // this.stageName = getFieldValue(data, fields[1]);
            console.log(data);
        } else if (error) {
            console.error(error);
        }
    }
    
    handleChange(e) {
        this.name = e.target.value;
    }
    
}