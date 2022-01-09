import { LightningElement, wire } from 'lwc';
import GetClassDetails from '@salesforce/apex/ClassInfoController.GetClassDetails';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/ldsUtils';

export default class ClassInfos extends LightningElement 
{
    isLoading=true;
    classDetails=[];
    isLoading=true; 

    @wire(GetClassDetails)
    gotClassDetails(result) {
        if (result.data) {
            this.isLoading=false;
            console.log('Class Details = ' + JSON.stringify(result.data, null, 4));
            this.classDetails=result.data;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Got Class Details',
                    message: 'Retrieved ' + this.classDetails.length + ' class details',
                    variant: 'success'
                })
            );
        }
        else if (result.error) {
            let errors=reduceErrors(result.error).reduce((accumulator, currentValue) => accumulator.concat(', ', currentValue), '');
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error retrieving class details',
                    message: errors.substring(2),
                    variant: 'error'
                })
            );
        }
    }
}