import { LightningElement, track, api} from 'lwc';
import retriveLeadLocation from '@salesforce/apex/LeadTriggerController.leadLocations';
import retriveLeadListViews from '@salesforce/apex/LeadTriggerController.getLeadListViews';
import retriveLeadListViewDataApex from '@salesforce/apex/LeadTriggerController.getLeadListViewDataApex';


export default class GoogleMapApi extends LightningElement {

    @api mapMarkers;
    @track isLoading = false;
    @track showModal = false;
    @track baseURL = '';
    @track leadLink = '';
    @track options = [];

    connectedCallback() {
        this.baseURL = window.location.origin;
        this.getAllLeadListViewForPickList();
    }

    async getAllLeadListViewForPickList(){

        await retriveLeadListViews()
        .then(res => {
            let data = JSON.parse(JSON.stringify(res));
            this.options = JSON.parse(data);

            let recentOptionId = this.options.find(option => option.label === 'Recently Viewed Leads').value;

            // Code Redundancy
            retriveLeadListViewDataApex({listViewId : recentOptionId})
            .then(res => {
                let data = res;
                let markerData = [];
                let selectedMarkerValueCount = 0;

                data.forEach(element => {
                    markerData.push({
                        location: {
                            City: element.City,
                            Country: element.Country,
                            PostalCode: element.PostalCode,
                            State: element.State,
                            Street: element.Street,
                            Latitude: element.Latitude,
                            Longitude: element.Longitude
                        },
                        // For onmarkerselect
                        value: element.Id,
                        // Extra info for tile in list & info window
                        icon: 'standard:account',
                        title: element.Name,
                        description: 'lorem ipsum dolor sit amet',
                    })
                });
                console.log('Data --> ', data);
                // console.log('markerData --> ', JSON.stringify(markerData));

                this.mapMarkers = markerData;
                // console.log('Response ', res);
                this.isLoading = false;
            }).catch(err => {
            console.error('Something error happend in retriveLeadListViewDataApex', err);
        })


            console.log('recentOption --> ', JSON.stringify(recentOptionId));
            console.log('Picklist Response : ', data);
        }).catch(err => {
            console.error('Something Error happend in retriveLeadListViews', err);
        })
    }

    // Get Lead based on list view Start //
    async handleListViewChange(event) {
        this.isLoading = true;
        this.value = event.detail.value;
        
        await retriveLeadListViewDataApex({listViewId : event.detail.value})
        .then(res => {
            let data = res;
            let markerData = [];
            let selectedMarkerValueCount = 0;
            
            data.forEach(element => {
                markerData.push({
                    location: {
                        City: element.City,
                        Country: element.Country,
                        PostalCode: element.PostalCode,
                        State: element.State,
                        Street: element.Street,
                        Latitude: element.Latitude,
                        Longitude: element.Longitude
                    },
                    // For onmarkerselect
                    value: element.Id,
                    // Extra info for tile in list & info window
                    icon: 'standard:account',
                    title: element.Name,
                    description: 'lorem ipsum dolor sit amet',
                })
            });
            console.log('Data --> ', data);
            // console.log('markerData --> ', JSON.stringify(markerData));

            this.mapMarkers = markerData;
            // console.log('Response ', res);
            this.isLoading = false;
        }).catch(err => {
            console.error('Something error happend in retriveLeadListViewDataApex', err);
        })
    }
    // Get Lead based on list view End //



    // Map Marker Selector - Custom Event 
    selectedMarkerValue = 'SF1';
    handleMarkerSelect(event) {
        this.selectedMarkerValue = event.target.selectedMarkerValue; // Lead Id
        this.leadLink = this.baseURL + '/' + this.selectedMarkerValue;
        this.showModal = true;
    }
    handleModalCross(){
        this.showModal = false;
    }
    
}