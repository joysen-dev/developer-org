import { LightningElement, api } from 'lwc';

export default class ChildComponent extends LightningElement {
    
    @api image;
    @api price;
    @api rating;
    
    _title;
    @api
    get title(){
        return this._title;
    }
    set title(value){
        if(value.length > 30){
            this._title = value.slice(0, 30) + '.......';
        }else{
            this._title = value;
        }
    }
    
    _desc
    @api
    get desc(){
        return this._desc;
    }
    set desc(value){
        if(value.length > 50){
            this._desc = value.slice(0, 50) + '.......';
        }else{
            this._desc = value;
        }
    }

    handleSeeMore(){
        console.log('Clicked');

        let productDetails = {
            image : this.image,
            title : this.title,
            desc : this.desc,
            price : this.price,
            rating : this.rating
        }
        
        const selectEvent = new CustomEvent('seemore', {
            detail: productDetails
        });
        // Fire the custom event
        this.dispatchEvent(selectEvent);
        console.log('selectEvent -> ', selectEvent);
    }

}
