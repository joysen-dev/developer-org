import { LightningElement } from 'lwc';
import getImages from '@salesforce/resourceUrl/images';


export default class LightningCarousel extends LightningElement {

    // image = images + '/1.jpg';
    connectedCallBack(){
        console.log('Hello');
        // console.log('images --> ', image);
    }

}