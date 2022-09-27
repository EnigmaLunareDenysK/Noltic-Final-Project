/**
 * Created by Dennis Klochko on 9/25/2022.
 */

import {LightningElement, api, wire} from 'lwc';
import getInterviewsListByAccountId from '@salesforce/apex/ContactController.getInterviewsListByAccountId';
import getConductedInterviews from '@salesforce/apex/ContactController.getConductedInterviews';
import getCancelledInterviews from '@salesforce/apex/ContactController.getCancelledInterviews';
import getSuccessfulInterviewsWithJobOffer
    from '@salesforce/apex/ContactController.getSuccessfulInterviewsWithJobOffer';
import getFailedInterviews from '@salesforce/apex/ContactController.getFailedInterviews';
import getSuccessfulInterviews from '@salesforce/apex/ContactController.getSuccessfulInterviews';



export default class IntervewSuccessRateSummary extends LightningElement {

    @api recordId;

    @wire(getInterviewsListByAccountId, {contactId: '$recordId'})
    interviews;

    @wire(getConductedInterviews, {contactId: '$recordId'})
    conductedInterviews;

    @wire(getFailedInterviews, {contactId: '$recordId'})
    failedInterviews;

    @wire(getCancelledInterviews, {contactId: '$recordId'})
    canceledInterviews;

    @wire(getSuccessfulInterviews, {contactId: '$recordId'})
    successfulInterviews;

    @wire(getSuccessfulInterviewsWithJobOffer, {contactId: '$recordId'})
    jobOfferInterviews;

}