/**
 * Created by Dennis Klochko on 9/24/2022.
 */

public with sharing class InterviewService {
    private static final String CONDUCTED_STAGE = 'Conducted';
    private static final String CANDIDATE_APPROVED = 'Candidate Approved';
    private static final String CANDIDATE_REJECTED = 'Candidate Rejected';

    public static void updateRelatedApplication(List<Interview__c> interviews) {
        List<Id> applicationIdsToApprove = new List<Id>();
        List<Id> applicationIdsToReject = new List<Id>();

        List<Interview__c> allInterviews = [SELECT Id, Stage__c, Candidate_Approved__c, Application__c FROM Interview__c WHERE Stage__c = :CONDUCTED_STAGE];
        for (Interview__c interview : allInterviews) {
            if (interview.Candidate_Approved__c == true) {
                applicationIdsToApprove.add(interview.Application__c);
            } else {
                applicationIdsToReject.add(interview.Application__c);
            }
        }

        List<Application__c> applicationsToUpdate = new List<Application__c>();
        applicationsToUpdate.addAll(updateApplicationsStatus(applicationIdsToApprove, CANDIDATE_APPROVED));
        applicationsToUpdate.addAll(updateApplicationsStatus(applicationIdsToReject, CANDIDATE_REJECTED));
        update applicationsToUpdate;

    }

    private static List<Application__c> updateApplicationsStatus(List<Id> applications, String status) {
        List<Application__c> applicationsToReturn = [SELECT Id from Application__c WHERE Id IN :applications];
        for (Application__c application : applicationsToReturn) {
            application.Status__c = status;
        }
        return applicationsToReturn;
    }
}

//public with sharing class InterviewService {
//    private static final String CONDUCTED_STAGE = 'Conducted';
//    private static final String CANDIDATE_APPROVED = 'Candidate Approved';
//    private static final String CANDIDATE_REJECTED = 'Candidate Rejected';
//
//    public static void updateRelatedApplication(List<Interview__c> interviews) {
//        List<Id> applicationIdsToApprove = new List<Id>();
//        List<Id> applicationIdsToReject = new List<Id>();
//
//        for (Interview__c interview : interviews){
//            if (interview.Stage__c == CONDUCTED_STAGE && interview.Candidate_Approved__c == true) {
//                applicationIdsToApprove.add(interview.Application__c);
//            }
//            if (interview.Stage__c == CONDUCTED_STAGE && interview.Candidate_Approved__c == false) {
//                applicationIdsToReject.add(interview.Application__c);
//            }
//        }
//
//
//        List<Application__c> applicationsToUpdate = new List<Application__c>();
//
//        List<Application__c> applicationsToApprove = [SELECT Id from Application__c WHERE Id IN :applicationIdsToApprove];
//        for (Application__c application : applicationsToApprove) {
//            application.Status__c = CANDIDATE_APPROVED;
//            applicationsToUpdate.add(application);
//        }
//
//        List<Application__c> applicationsToReject = [SELECT Id from Application__c WHERE Id IN :applicationIdsToReject];
//        for (Application__c application : applicationsToReject) {
//            application.Status__c = CANDIDATE_REJECTED;
//            applicationsToUpdate.add(application);
//        }
//        update applicationsToUpdate;
//
//
//
//    }
//
//}