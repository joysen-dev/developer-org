import { LightningElement, wire, api, track} from 'lwc';

import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import NAME_FIELD from "@salesforce/schema/Account.Name";
import PHONE_FIELD from "@salesforce/schema/Account.Phone";

import wireDemo from '@salesforce/apex/AccountController.wireDemo';

export default class WireDeceretorDemo extends LightningElement {

    @api recordId;

    // @wire(wireDemo, {recordId : '$recordId'})
    // wireDemoData({data, error}){
    //   if(data){
    //     console.log('Data -> ', data);
    //   }else{
    //     console.log('Error -> ', error);
    //   }
    // }
    @wire(wireDemo, {recordId : '$recordId'})
    contacts;

    ConnectedCallback(){
      console.log('Wired data -> ', this.contacts);
    }



    // @wire(getRecord, {
    //     recordId: '$recordId',
    //     fields: [NAME_FIELD, PHONE_FIELD],
    //   })
    //   accountDetails({data, error}){
    //     if(data){
    //         // console.log('Data -> ', data);
    //         this.name = data.fields.Name.value;
    //         this.phone = data.fields.Phone.value;
    //     }else{
    //         console.log('Error -> ', error);
    //     }
    //   }
    //   account;

    //   get name() {
    //     return getFieldValue(this.account.data, NAME_FIELD);
    //   }
    
    //   get phone() {
    //     return getFieldValue(this.account.data, PHONE_FIELD);
    //   }

}