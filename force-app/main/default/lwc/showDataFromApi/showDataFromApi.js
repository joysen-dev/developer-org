import { track, api, wire, LightningElement } from 'lwc';
import retriveData from '@salesforce/apex/FetchDataFromApi.getDataFormApi';

export default class ShowDataFromApi extends LightningElement {

    @track reqData;

    connectedCallback(){
        this.getData();
    }
    async getData(){
        await retriveData().then(res => {
            this.reqData = JSON.parse(res);
            this.reqData = JSON.parse(this.reqData);
            console.log('Data : ', JSON.parse(this.reqData));
        }).catch(req => {
            console.error('Error Happend');
        });
    }
}