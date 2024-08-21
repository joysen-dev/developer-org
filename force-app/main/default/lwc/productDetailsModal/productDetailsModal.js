import { LightningElement, api } from 'lwc';

export default class ProductDetailsModal extends LightningElement {

    @api productdetails;

    handleClose(){
        this.dispatchEvent(new CustomEvent('close', {
            detail: true
        }));
    }
}