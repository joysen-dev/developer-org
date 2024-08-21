import { LightningElement, track, api} from 'lwc';
import getAllProduct from '@salesforce/apex/APICallout.getAllProduct';
import bootstrap from "@salesforce/resourceUrl/bootstrap";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadStyle, loadScript } from "lightning/platformResourceLoader";

export default class ParentComponent extends LightningElement {
  
    response;
    showSpinner = true;
    @track showProductDetails = false;
    @track ProductDetails;

    connectedCallback(){

      try {
        Promise.all([
          loadScript(this, bootstrap + "/bootstrap/js/bootstrap.js"),
          loadStyle(this, bootstrap + "/bootstrap/css/bootstrap.css"),
        ]).then(res => {
          this.dispatchEvent(
            new ShowToastEvent({
              title: "success",
              message: 'success',
              variant: "success",
            }),
          );
        });
      } catch (error) {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error loading D3",
            message: error.message,
            variant: "error",
          }),
        );
      }



      getAllProduct()
      .then((result) => {
        if(result){
          this.response = result;
        }
        this.showSpinner = false;
        console.log('Result -> ', result);
      }).catch((error) => {
        console.log('Error -> ', error);
      })
    }
  
     
    handleProductDetails(event) {
      this.showProductDetails = true;
      this.ProductDetails = event.detail;

      console.log('Received seemore event from child:', JSON.stringify(event.detail));
  }

  handleClose(event){
      this.showProductDetails = false;
  }
}