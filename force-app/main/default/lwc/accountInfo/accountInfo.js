import { LightningElement, api } from 'lwc';
import retriveStageFromOpportunity from '@salesforce/apex/AccountInfoController.getStageFromOpportunity';
import addUser from '@salesforce/apex/APICallout.addUser';

export default class AccountInfo extends LightningElement {

    handleSubmit(){
        let data = {
            email:'John@gmail.com',
            username:'johnd',
            password:'m38rmF$',
            name:{
                firstname:'John',
                lastname:'Doe'
            },
            address:{
                city:'kilcoole',
                street:'7835 new road',
                homenumber:3,
                zipcode:'12926-3874',
                geolocation:{
                    latitude:'-37.3159',
                    longitude:'81.1496'
                }
            },
            phone:'1-570-236-7033',
        }


        addUser({data: JSON.stringify(data)})
        .then(res => {
            console.log('Result -> ', res)
        }).catch(error => {
            console.error('Error -> ', error)
        })
    }












}