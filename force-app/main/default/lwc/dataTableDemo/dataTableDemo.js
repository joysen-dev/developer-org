import { LightningElement, api, track } from 'lwc';
import getDynamicData from './getDynamicData';
import getRecords from '@salesforce/apex/AccountInfoController.getRecords';
import getFieldLabelFromApex from '@salesforce/apex/AccountInfoController.getFieldLabel';

const columns = [
    // { label: 'Row No.', fieldName: 'rowNum' },
    // { label: 'Account Name', fieldName: 'Name'},
    // { label: 'Phone', fieldName: 'Phone', type: 'phone'},
    // { label: 'Website', fieldName: 'Website', type: 'url'},
    // { label: 'Account Type', fieldName: 'Type'}
];

export default class DataTableDemo extends LightningElement {

    @api dynamicColumns;
    @api dynamicObject;
    data = [];
    @track columns = [];
    errorMsg = '';
    fieldLabels = [];
    @track columnsArr = [];

    connectedCallback() {
        let columnsArr = this.dynamicColumns.split(',');
        this.columnsArr = columnsArr;

        // Getting Field Labels Of Respective Dynamic Columns
        this.retriveFieldLabel(columnsArr);
        
        // console.log('this.fieldLabels 1-->', JSON.stringify(this.fieldLabels));
        /*for(let i = 0; i < columnsArr.length; i++){
            this.columns.push({
                label : this.fieldLabels[i],
                fieldName : columnsArr[i]
            })
        }*/

        // console.log('this.fieldLabels 2--->', JSON.stringify(this.fieldLabels));
        // console.log('this.columns--->', JSON.stringify(this.columns));

        /*
        getFieldLabelFromApex({
            objectName : this.dynamicObject,
            columns : columnsArr
        }).then(res => {
            console.log('All Field name Of the Object : ', res);
            this.fieldLabels = res;
        }).catch(err => {
            console.error(err);
        })
        */

       /* this.columns = [];
        columnsArr.forEach(element => {
            this.columns.push({
                label : element,
                fieldName : element
            });
        })*/

        // console.log('Dynamic Columns : ', JSON.stringify(this.columns));
        // console.log('Dynamic Objetc Name For Sending apex: ', this.dynamicObject);
        // console.log('Dynamic Columns For sending apex: ', this.dynamicColumns);

        // Getting The Dynamic Records form Apex
        // Based on Admin given Object Name and Columns
        
        getRecords({objectName : this.dynamicObject, columns : this.dynamicColumns})
        .then( res => {
            let count = 1;
            this.data = res.map((item) => ({
                ...item, rowNum: `No. ${count++}`
            }));
            // console.log(res);
        })
        .catch(err => {
            this.errorMsg = err.body.message;
            console.error('Error Msg : ', err.body.message);
        })
    }

    async retriveFieldLabel(columnsArr){
        
        // console.log('this.dynamicObject', JSON.stringify(this.dynamicObject));
        // console.log('this.columnsArr', JSON.stringify(this.columnsArr));
        var tempArr = [];
        await getFieldLabelFromApex({
            objectName : this.dynamicObject,
            columns : this.columnsArr
        }).then(res => {
            // console.log('All Field name Of the Object : ', res);
            // this.fieldLabels = res;
            // tempArr = res;
            for(let i = 0; i < res.length; i++){
                console.log('loop-->', res[i]);
                tempArr.push({
                    label: res[i],
                    fieldName: this.columnsArr[i]
                    
                });
    
            }
        }).catch(err => {
            console.error('There was an error on retriveFieldLabel--->', err);
        })

        
        console.log('tempArr--->', tempArr.length);
        // console.log('columnsArr--->', JSON.stringify(columnsArr));
        
        this.columns = tempArr;
        
        
        // console.log('this.columns __> ', this.columns[0].label);

        // console.log('this.fieldLabels--->', this.fieldLabels);
        
    }
}