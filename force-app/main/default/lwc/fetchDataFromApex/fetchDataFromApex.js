import { LightningElement, api, wire} from 'lwc';
import getContacts from '@salesforce/apex/AccountInfoController.getContacts';

export default class FetchDataFromApex extends LightningElement {
    @api recordId;
    contacts;

    // Wire is the shortcut system for fetching Data form Apex.
    @wire(getContacts, {accountId: '$recordId'})
    resContacts(data, error){
        if(data){
            this.contacts = data;
            console.log('Form Wire Decorators : ', data.data);
        }else{
            this.contacts = error;
        }
    }

    // connectedCallback(){
    //     // console.log('Form Wire Decorators : ', this.contacts);
    //     // this.fetchData();
    // }

    // async fetchData(){
    //     console.log('Data From Direct Apex Class : ');
    //     await getContacts({accountId : this.recordId})
    //     .then((res) => {
    //         console.log(res);
    //     })
    //     .catch((err) => {
    //         console.log(err);
    //     });
    // }
}