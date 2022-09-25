/**
 * Created by Dennis Klochko on 9/25/2022.
 */

@IsTest
public with sharing class TestDataFactory {

    public static List<Interview__c> createNInterviews (Integer numberToCreate, Contact interviewer, Date sheduleDate) {
        List<Interview__c> interviews = new List<Interview__c>();
        for (Integer i = 0; i < numberToCreate; i++) {
            interviews.add(new Interview__c(Interviewer__c = interviewer.Id, Scheduled_Date__c = sheduleDate));

        }
        return interviews;
    }

    public static Contact createInterviewer(){
        return new Contact(LastName = 'Interviewer1', Email = 'hegycamu@inboxbear.com', RecordTypeId = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Interviewer' and SobjectType = 'Contact' limit 1].Id);
    }

    public static Contact createApplicant(){
        return new Contact(LastName = 'Interviewer2', Email = 'hegycamu@inboxbear.com', RecordTypeId = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Candidate' and SobjectType = 'Contact' limit 1].Id);
    }

    public static Account createAHiringCompany(String name){
        return new Account(Name = name);
    }

    public static Job_Opening__c createAnActiveJobOpeningForACompany(Account company){
        return new Job_Opening__c(Company__c = company.Id, IsActive__c = true);
    }

    public static Application__c createAJobApplicationWithInterviewer(Contact candidate, Job_Opening__c jobOpening, Contact interviewer){
        return new Application__c(Applicant__c = candidate.Id, Job_Opening__c = jobOpening.Id, Interviewer__c = interviewer.Id, Status__c = 'New');
    }
    public static Application__c createAJobApplicationWithoutInterviewer(Contact candidate, Job_Opening__c jobOpening){
        return new Application__c(Applicant__c = candidate.Id, Job_Opening__c = jobOpening.Id, Status__c = 'New');
    }
    public static Interview__c createAnInterview(){
        return new Interview__c(Stage__c = 'New', Candidate_Approved__c = false);
    }
    public static Interview__c setInterviewConductedAccepted(Interview__c interview){
//        interview.Stage__c='Conducted';
//        interview.Candidate_Approved__c = true;
        return new Interview__c(Id = interview.Id, Stage__c='Conducted', Candidate_Approved__c = true);

    }
    public static Interview__c setInterviewConductedRejected(Interview__c interview){
//        interview.Stage__c='Conducted';
//        interview.Candidate_Approved__c = false;
        return new Interview__c(Id = interview.Id, Stage__c='Conducted', Candidate_Approved__c = false);
    }
}