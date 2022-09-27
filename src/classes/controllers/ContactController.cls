/**
 * Created by Dennis Klochko on 9/25/2022.
 */


public with sharing class ContactController {

    private static final String CONDUCTED_STAGE = 'Conducted';
    private static final String CANCELED_STAGE = 'Canceled';
    private static final String CANDIDATE_RT = 'Candidate';
//    private static final String INTERVIEWER_RT = 'Interviewer';

    @AuraEnabled(Cacheable=true)
    public static List<Interview__c> getInterviewsListByContactId(Id contactId) {
        Contact contact = [SELECT Id, RecordTypeId FROM Contact WHERE Id = :contactId];
        Id candidateRTId = [Select Id, SobjectType, Name From RecordType WHERE Name = :CANDIDATE_RT and SobjectType = 'Contact' limit 1].Id;
//!!!!!!!works only of no other RecordTypes expect for Candidate/Interviewer will be there in an org
            return contact.RecordTypeId == candidateRTId ?
                    [SELECT Id, Applicant_Name__c, Application_Name__c, Interviewer_Name__c, Job_Opening_Name__c, Scheduled_Date__c, Stage__c, Candidate_Approved__c from Interview__c WHERE Applicant__c = :contactId]
                    :
                    [SELECT Id, Applicant_Name__c, Application_Name__c, Interviewer_Name__c, Job_Opening_Name__c, Scheduled_Date__c, Stage__c, Candidate_Approved__c from Interview__c WHERE Interviewer__c = :contactId];

//        Contact contact = [SELECT Id, RecordTypeId FROM Contact WHERE Id = :contactId];
//        List<Interview__c> interviewsToReturn = new List<Interview__c>();
//
//        if (contact.RecordTypeId == [Select Id, SobjectType, Name From RecordType WHERE Name = :CANDIDATE_RT and SobjectType = 'Contact' limit 1].Id) {
//            interviewsToReturn = [SELECT Id, Applicant_Name__c, Application_Name__c, Interviewer_Name__c, Job_Opening_Name__c, Scheduled_Date__c, Stage__c, Candidate_Approved__c from Interview__c WHERE Applicant__c = :contactId];
//
//        }
//        if (contact.RecordTypeId == [Select Id, SobjectType, Name From RecordType WHERE Name = :INTERVIEWER_RT and SobjectType = 'Contact' limit 1].Id) {
//            interviewsToReturn = [SELECT Id, Applicant_Name__c, Application_Name__c, Interviewer_Name__c, Job_Opening_Name__c, Scheduled_Date__c, Stage__c, Candidate_Approved__c from Interview__c WHERE Interviewer__c = :contactId];
//
//        }
//        return interviewsToReturn;
}
    @AuraEnabled(Cacheable=true)
    public static List<Interview__c> getInterviewsListByContactIdForTheCurrentWeek(Id contactId) {
        Contact contact = [SELECT Id, RecordTypeId FROM Contact WHERE Id = :contactId];
        Id candidateRTId = [Select Id, SobjectType, Name From RecordType WHERE Name = :CANDIDATE_RT and SobjectType = 'Contact' limit 1].Id;
//!!!!Same here!!!works only of no other RecordTypes expect for Candidate/Interviewer will be there in an org
        return contact.RecordTypeId == candidateRTId ?
                selectInterviewsWithinTheWeekOfToday([SELECT Id, Applicant_Name__c, Application_Name__c, Interviewer_Name__c, Job_Opening_Name__c, Scheduled_Date__c, Stage__c, Candidate_Approved__c from Interview__c WHERE Applicant__c = :contactId])
        :
                selectInterviewsWithinTheWeekOfToday([SELECT Id, Applicant_Name__c, Application_Name__c, Interviewer_Name__c, Job_Opening_Name__c, Scheduled_Date__c, Stage__c, Candidate_Approved__c from Interview__c WHERE Interviewer__c = :contactId]);

//        Contact contact = [SELECT Id, RecordTypeId FROM Contact WHERE Id = :contactId];
//        List<Interview__c> interviewsToReturn = new List<Interview__c>();
//
//        if (contact.RecordTypeId == [Select Id, SobjectType, Name From RecordType WHERE Name = :CANDIDATE_RT and SobjectType = 'Contact' limit 1].Id) {
//            interviewsToReturn = [SELECT Id, Applicant_Name__c, Application_Name__c, Interviewer_Name__c, Job_Opening_Name__c, Scheduled_Date__c, Stage__c, Candidate_Approved__c from Interview__c WHERE Applicant__c = :contactId];
//            interviewsToReturn = selectInterviewsWithinTheWeekOfToday(interviewsToReturn);
//        }
//        if (contact.RecordTypeId == [Select Id, SobjectType, Name From RecordType WHERE Name = :INTERVIEWER_RT and SobjectType = 'Contact' limit 1].Id) {
//            interviewsToReturn = [SELECT Id, Applicant_Name__c, Application_Name__c, Interviewer_Name__c, Job_Opening_Name__c, Scheduled_Date__c, Stage__c, Candidate_Approved__c from Interview__c WHERE Interviewer__c = :contactId];
//            interviewsToReturn = selectInterviewsWithinTheWeekOfToday(interviewsToReturn);
//        }
//        return interviewsToReturn;
    }

    private static List<Interview__c> selectInterviewsWithinTheWeekOfToday(List<Interview__c> interviews) {
        List<Interview__c> interviewsToReturn = new List<Interview__c>();
        for (Interview__c interview : interviews) {
            if (isoWeekNumber(interview.Scheduled_Date__c) == isoWeekNumber(Date.today())) {
                interviewsToReturn.add(interview);
            }
        }
        return interviewsToReturn;
    }

    private static Integer isoWeekNumber(Date value) {
        Integer daysSince1900_01_07 = Date.newInstance(1900, 1, 7).daysBetween(value);
        Integer dayNumber = Math.mod(daysSince1900_01_07, 7) + 1;

        Date dateForYear = value.addDays(Math.mod(8 - dayNumber, 7) - 3);
        Integer year = dateForYear.year();
        Date year_01_01 = Date.newInstance(year, 1, 1);

        Integer week = (Integer) Math.floor((year_01_01.daysBetween(value)
                + Math.mod((Math.mod(Date.newInstance(1900, 1, 7).daysBetween(year_01_01), 7) + 1) + 1, 7) - 3) / 7 + 1);

        return week;
    }


    @AuraEnabled(Cacheable=true)
    public static List<Interview__c> getConductedInterviews(Id contactId) {
        List<Interview__c> interviewsToCheck = getInterviewsListByContactId(contactId);
        List<Interview__c> conductedInterviews = new List<Interview__c>();
        for (Interview__c interview : interviewsToCheck) {
            if (interview.Stage__c == CONDUCTED_STAGE) {
                conductedInterviews.add(interview);
            }
        }
        return conductedInterviews;
    }


    @AuraEnabled(Cacheable=true)
    public static List<Interview__c> getCancelledInterviews(Id contactId) {
        List<Interview__c> interviewsToCheck = getInterviewsListByContactId(contactId);
        List<Interview__c> canceledInterviews = new List<Interview__c>();
        for (Interview__c interview : interviewsToCheck) {
            if (interview.Stage__c == CANCELED_STAGE) {
                canceledInterviews.add(interview);
            }
        }
        return canceledInterviews;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Job_Offer__c> getSuccessfulInterviewsWithJobOffer(Id contactId) {
        return [SELECT Id, Applicant__c from Job_Offer__c WHERE Applicant__c = :contactId];

//        List<Interview__c> interviewsToCheck = getInterviewsListByContactId(contactId);
//        List<Id> interviewIds = new List<Id>();
//        for (Interview__c interview : interviewsToCheck) {
//            interviewIds.add(interview.Id);
//        }
//        return [SELECT Id, Interview__c from Job_Offer__c WHERE Interview__c IN :interviewIds];
    }

    @AuraEnabled(Cacheable=true)
    public static List<Interview__c> getFailedInterviews(Id contactId) {
        List<Interview__c> interviewsToCheck = getInterviewsListByContactId(contactId);
        List<Interview__c> failedInterviews = new List<Interview__c>();
        for (Interview__c interview : interviewsToCheck) {
            if (interview.Stage__c == CONDUCTED_STAGE && interview.Candidate_Approved__c == false) {
                failedInterviews.add(interview);
            }
        }
        return failedInterviews;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Interview__c> getSuccessfulInterviews(Id contactId) {
        List<Interview__c> interviewsToCheck = getInterviewsListByContactId(contactId);
        List<Interview__c> successfulInterviews = new List<Interview__c>();
        for (Interview__c interview : interviewsToCheck) {
            if (interview.Stage__c == CONDUCTED_STAGE && interview.Candidate_Approved__c == true) {
                successfulInterviews.add(interview);
            }
        }
        return successfulInterviews;
    }

}