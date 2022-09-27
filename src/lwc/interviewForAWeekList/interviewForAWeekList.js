/**
 * Created by Dennis Klochko on 9/25/2022.
 */

import {LightningElement, api, wire} from 'lwc';
import getInterviewsListByAccountId from '@salesforce/apex/ContactController.getInterviewsListByAccountId';
import getInterviewsListByAccountIdForThisWeek from '@salesforce/apex/ContactController.getInterviewsListByAccountIdForThisWeek';
import CANDIDATE_FIELD from '@salesforce/schema/Interview__c.Applicant_Name__c';
import APPLICATION_FIELD from '@salesforce/schema/Interview__c.Application_Name__c';
import INTERVIEWER_FIELD from '@salesforce/schema/Interview__c.Interviewer_Name__c';
import JOBOPENING_FIELD from '@salesforce/schema/Interview__c.Job_Opening_Name__c';
import DATE_FIELD from '@salesforce/schema/Interview__c.Scheduled_Date__c';
import STAGE_FIELD from '@salesforce/schema/Interview__c.Stage__c';
const COLS = [
    {
        label: 'Candidate Name',
        fieldName: CANDIDATE_FIELD.fieldApiName,
    },
    {
        label: 'Application',
        fieldName: APPLICATION_FIELD.fieldApiName,
        type: 'text',
    },
    {
        label: 'Interviewer',
        fieldName: INTERVIEWER_FIELD.fieldApiName,
        type: 'text',
    },
    {
        label: 'Job Opening',
        fieldName: JOBOPENING_FIELD.fieldApiName,
        type: 'text',
    },
    {
        label: 'Scheduled Date',
        fieldName: DATE_FIELD.fieldApiName,
        type: 'date',
    },
    {
        label: 'Stage',
        fieldName: STAGE_FIELD.fieldApiName,
        type: 'picklist',
    }
];



export default class InterviewForAWeekList extends LightningElement {
    @api recordId;
    columns = COLS;

    @wire(getInterviewsListByAccountId, {contactId : '$recordId'})
    interviews;

    @wire(getInterviewsListByAccountIdForThisWeek, {contactId : '$recordId'})
    interviewsweek;

}