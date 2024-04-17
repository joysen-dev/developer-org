import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import sendMsgFromLWC from '@salesforce/apex/WhatsappMsgController.getMsgFromLWC';
import retriveNamePhone from '@salesforce/apex/WhatsappMsgController.getContactNamePhone';
import getWhatsappMessages from '@salesforce/apex/WhatsappMsgController.getWhatsappMessages';

export default class Whatsapp extends LightningElement {

    @api recordId;
    @track phoneNumber = '';
    @track Name = '';
    @track data;
    isLoading = false;


    // @track data = `<div class="message parker">Hey, man! What's up, Mr Stark? 👋</div><div class="message stark">Kid, where'd you come from? </div><div class="message parker">Hey, man! What's up, Mr Stark? 👋</div><div class="message stark">Kid, where'd you come from? </div><div class="message parker">Hey, man! What's up, Mr Stark? 👋</div><div class="message stark">Kid, where'd you come from? </div><div class="message parker">Hey, man! What's up, Mr Stark? 👋</div><div class="message stark">Kid, where'd you come from? </div><div class="message parker">Field trip! 🤣</div><div class="message parker">Uh, what is this guy's problem, Mr. Stark? 🤔</div><div class="message stark">Uh, he's from space, he came here to steal a necklace from a wizard.</div>`;

    


    connectedCallback(){
        this.isLoading = true;

        // console.log('Record Id : ', this.recordId);

        retriveNamePhone({recordId : this.recordId})
        .then(res => {
            this.phoneNumber = res.MobilePhone;
            this.Name = res.Name;
            console.log('Response : ', res);
        })
        .catch(err => {
            console.error('Unknown Error Happend', err);
        })
        this.retriveWhatsappMessages();
    }

    // Retriving All Message for this Phone Number
    retriveWhatsappMessages(){
        getWhatsappMessages({recordId : this.recordId})
        .then(res => {
            this.data = res;
            this.isLoading = false;
            // console.log('Data : ', this.data);
            // console.log('Messages : ', res);
        })
        .catch(err => {
            console.error('Unknown Error Happend', err);
        })
    }

    sendSMS(event){
        event.preventDefault();
        
        let msg = this.template.querySelector('.sendMessage');
        console.log('Message : ', typeof msg.value);
        
        sendMsgFromLWC({ msg : msg.value, objId : this.recordId, phnNumber: this.phoneNumber})
        .then(res => {
            if(res){
                this.showNotification('Unknown Error Happend', 'error');
            }else{
                this.showNotification('Message Successfully Send', 'success');
            }
        })
        .catch(err => {
            console.log(JSON.stringify(err));
        });
        msg.value = '';

        this.isLoading = false;
        this.retriveWhatsappMessages();
    }

    showNotification(msg, varient) {
        const evt = new ShowToastEvent({
          title: 'Whatsapp SMS',
          message: msg,
          variant: varient,
        });
        this.dispatchEvent(evt);
    }
    
}