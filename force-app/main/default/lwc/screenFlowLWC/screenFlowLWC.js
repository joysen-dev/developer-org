import { api, LightningElement } from 'lwc';
import getDataFormLWC from '@salesforce/apex/ScreenFlowLWCController.getDataFormLWC';
export default class ScreenFlowLWC extends LightningElement {

    @api oppFirstName;
    @api oppLastName;
    @api Stage;
    @api closeDate;
    
    connectedCallback(){
        let fullName = `${this.oppFirstName} ${this.oppLastName}`;

        let data = {
            'Name' : fullName,
            'StageName' : this.Stage,
            'closeDate' : this.closeDate
        };

        data = JSON.stringify(data);
        getDataFormLWC({data : data}).then((res) => {
            console.log(res);
            window.location.href = res;
            }
        ).catch();
        
        console.log(data);
    }

}