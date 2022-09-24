/**
 * Created by Dennis Klochko on 9/24/2022.
 */

public with sharing class InterviewService {

    public static void updateRelatedApplication(List<Interview__c> interviews){
        List<Id> applicationIdsToApprove = new List<Id>();
        List<Id> applicationIdsToReject = new List<Id>();
        for (Interview__c interview : interviews){
            if (interview.Stage__c == 'Conducted' && interview.Candidate_Approved__c == true) {
                applicationIdsToApprove.add(interview.Application__c);
            }
            if (interview.Stage__c == 'Conducted' && interview.Candidate_Approved__c == false) {
                applicationIdsToReject.add(interview.Application__c);
            }
        }
        List<Application__c> applicationsToApprove = [SELECT Id from Application__c WHERE Id IN :applicationIdsToApprove];
        List<Application__c> applicationsToReject = [SELECT Id from Application__c WHERE Id IN :applicationIdsToReject];
        List<Application__c> applicationsToUpdate = new List<Application__c>();
        for (Application__c application : applicationsToApprove){
            application.Status__c = 'Candidate Approved';
            applicationsToUpdate.add(application);
        }
                for (Application__c application : applicationsToReject){
            application.Status__c = 'Candidate Rejected';
            applicationsToUpdate.add(application);
        }

        update applicationsToUpdate;
    }

}