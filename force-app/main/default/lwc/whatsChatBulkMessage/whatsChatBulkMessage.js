import { LightningElement, track, api, wire} from 'lwc';
import retriveLeadListViews from '@salesforce/apex/WhatsChatBulkMessageController.getLeadListViews';
import retriverecordsBasedOnListView from '@salesforce/apex/WhatsChatBulkMessageController.recordsBasedOnListView';

export default class WhatsChatBulkMessage extends LightningElement {

    @track options = [];
    @track isLoading = false;
    @track data = [];
    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'MobilePhone', fieldName: 'MobilePhone', type: 'phone' },
        { label: 'Email', fieldName: 'Email', type: 'email' },
        { label: 'Title', fieldName: 'Title' },
        { label: 'LeadSource', fieldName: 'LeadSource' },
    ];

    @wire(retriveLeadListViews)
    wiredData({data, error}){
        if(data){
            this.options = JSON.parse(data);
            console.log('Picklist Response : ', data);
        }else if(error){
            console.error('Something Error happend fetching Picklist Value : ', error);
        }
    }

    connectedCallback() {

    }


    handleListViewChange(event){
        let listViewId = event.detail.value;
        this.getRecordsBasedOnListViewId(listViewId);
    }

    async getRecordsBasedOnListViewId(Id){
        this.isLoading = true;
        await retriverecordsBasedOnListView({listViewId : Id})
        .then(res => {
            this.data = res;
            console.log(res);
            this.isLoading = false;
        }).catch(error => {
            console.error('Error Happend on (getRecordsBasedOnListViewId) => ', error);
        })
    }

    getSelectedName(event) {
        const selectedRows = event.detail.selectedRows;
        // Display that fieldName of the selected rows
        // for (let i = 0; i < selectedRows.length; i++) {
        //     console.log('You selected: ' + selectedRows[i].Name);
        // }
        console.log('Selected Rows : ', selectedRows);
    }

    handleFormSubmit(event){
        event.preventDefault();
        let message = template.getElementById('message');

        console.log('Hello World');
        console.log('Value : ', message.value);
    }
}