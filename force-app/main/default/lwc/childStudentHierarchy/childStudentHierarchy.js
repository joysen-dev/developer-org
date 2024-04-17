import { LightningElement, api } from 'lwc';

export default class ChildStudentHierarchy extends LightningElement {
    @api student;
    collapseCard = true;

    handleClick(e) {
        this.collapseCard = !this.collapseCard;
        
        let Id = e.target.getAttribute('data-key');
        this.retriveStudentHierarchy(Id, 'child');
        let childCard = this.template.querySelector(`[data-id="${Id}"]`);
        if(!this.collapseCard){
            childCard.style.display = 'block';
        }else{
            childCard.style.display = 'none';
        }
    }
}