import { LightningElement, api } from 'lwc';
import retriveStageFromOpportunity from '@salesforce/apex/AccountInfoController.getStageFromOpportunity';

export default class AccountInfo extends LightningElement {

    @api recordId;

    // Record Contact Form 
    contactFields = ['FirstName', 'LastName', 'Description', 'LeadSource'];










    //  Codes For Get Data Form Apex
    toggler = true;
    data = {};
    // connectedCallback(){
    //     console.log('Record Id of this opportunity ; ', this.recordId);
    //     // this.toggler = false;
    //     this.retriveStageDataFromOpportunity(this.recordId);
    // }
    async retriveStageDataFromOpportunity(recordId){
        return await retriveStageFromOpportunity({recordId: recordId})
        .then(res => {
            this.data = res;
            console.log('Response From Server in Async : ',res);
            // return res; 
        })
        .catch( err => {console.error(err)});
    }



    // Code For Toggler 
    name = 'Joy Sen';

    joyDesc = 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquid perferendis impedit voluptates nisi sint temporibus beatae quaerat rerum facere corrupti. Inventore enim porro similique officia quod hic repudiandae mollitia vero?';
    
    rahiDesc = 'consectetur adipisicing elit. Enim dolore tempore quas voluptatem, eum doloremque laboriosam saepe repudiandae unde fugiat, totam cum possimus error minus nihil eaque nobis! Impedit obcaecati ad, harum commodi fugit cupiditate neque facilis quidem provident odio!';
    
    // desc = this.joyDesc;
    
    fruits = ["Apple", "Orange", "Mango", "Banana", "Guava", "Pineapple"];
    count = false;

    startToggling() {
        if(this.count) return;

        this.toggler = !this.toggler;
        this.name = this.toggler === false ? 'Rahi Vai' : 'Joy Sen';
        
        setTimeout(()=>{
            this.startToggling();
        }, 1000);

        // this.desc = this.toggler === false ? this.rahiDesc : this.joyDesc;
    }

    stopToggling(){
        this.count = true;
        this.startToggling();
    }
}