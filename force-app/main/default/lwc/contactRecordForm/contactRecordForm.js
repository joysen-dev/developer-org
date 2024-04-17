import { LightningElement } from 'lwc';
import retriveContactRecordForm from '@salesforce/apex/ContactRecordFormController.sendContactRecordFormData';


export default class ContactRecordForm extends LightningElement {

    // Record Contact Form 
    contactFields = ['FirstName', 'LastName', 'Description', 'LeadSource'];
    spinner = false;

    handleSubmit(e){
        e.preventDefault();
        e.stopPropagation();
        this.spinner = true;

        let data = JSON.stringify(e.detail.fields);

        this.retriveContactRecordFormData(data);
    }


    connectedCallBack(){
        console.log('connectedCallBack');
        this.retriveContactRecordFormData(data);
    }

    async retriveContactRecordFormData(data){ 
        console.log('Got data: ', data);
        await retriveContactRecordForm({data: data}).then(res => {
            console.log('Res-->', res);
            window.location.href = res;
        }).catch(error => {
            console.error('Error on calling Apex: ', error);
        });
    }

}