import { LightningElement } from 'lwc';
import createNewLead from '@salesforce/apex/CustomForm.createLead';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CustomForm extends LightningElement {

    showSpinner = false;

    async handleSubmit(event){
        event.preventDefault();

        let firstName = this.template.querySelector('.firstName');
        let lastName = this.template.querySelector('.lastName');
        let company = this.template.querySelector('.company');

        this.showSpinner = true;
        await createNewLead({fName : firstName.value, lName : lastName.value, company : company.value})
        .then( result => {
            this.showSpinner = false;
            firstName.value = '';
            lastName.value = '';
            company.value = '';
            console.log('Result -> ', result);
            this.showToast('New Lead Created..', result, 'success');
        })
        .catch( error => {
            console.log('Error -> ', error);
        })
    }


    showToast(msg, result, variant) {
        const event = new ShowToastEvent({
            title: 'Success',
            variant: variant,
            message:msg +' '+result,
        });
        this.dispatchEvent(event);
    }

}