import { LightningElement, api, wire, track } from 'lwc';
import NAME from '@salesforce/schema/Student__c.Name';
import Roll__c from '@salesforce/schema/Student__c.Roll__c';
import Email__c from '@salesforce/schema/Student__c.Email__c';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getStudentHierarchy from '@salesforce/apex/StudentTriggerHandler.getStudentHierarchy';
import getCurrecntStudent from '@salesforce/apex/StudentTriggerHandler.getCurrecntStudent';

export default class StudentHierarchy extends LightningElement {

    @api recordId;

    @track immediateStudent = [];
    
    @api currentRecord = {};
    
    // @wire(getRecord, {recordId: '$recordId', fields: [NAME, Roll__c, Email__c]})
    // wiredRecord({ error, data }) {
    //     if (error) {
    //         console.error(error);
    //     } else if (data) {
    //         this.setCurrentRecord(data.fields);
    //     }
    // }

    setCurrentRecord(data){
        this.currentRecord = {
            name: data.Name.value,
            roll: data.Roll__c.value,
            email: data.Email__c.value,
        };
        console.log('Current Record: ', this.jsonToArray(this.currentRecord));
    }

    connectedCallback(){
        // Calling retriveStudentHierarchy Func for First Time
        this.retriveCurrentStudent();
        this.retriveStudentHierarchy();
    }
    async retriveCurrentStudent(){
        // console.log('record Id : ', this.recordId);
        await getCurrecntStudent({stuId : this.recordId}).then(data => {
            this.currentRecord = data;
            console.log('Current Student : ', this.jsonToArray(this.currentRecord));

        }).catch(error => {
            console.error('Error Happend : ', error.message);
        })
    }

    async retriveStudentHierarchy(){
        await getStudentHierarchy({stuId : this.recordId}).then(data => {

            this.immediateStudent = data.map( ele => {
                return {...ele, isOpen : false};
            });

            console.log('Immediate Students : ', this.jsonToArray(this.immediateStudent));

        }).catch(error => {
            console.error('Error Happend : ', error.message);
        })
    }

    // Handling the clicking event
    handleClickEvent(event) {
        var btnIndex = event.target.getAttribute('data-index');
        this.immediateStudent[btnIndex].isOpen = !this.immediateStudent[btnIndex].isOpen;
    }

    jsonToArray(data){
        return JSON.parse(JSON.stringify(data));
    }
}