/**
 * Created by Dennis Klochko on 9/25/2022.
 */

@IsTest
private class InterviewServiceTest {
    @IsTest
    static void updateRelatedApplication_positive() {
        //given

        Contact interviewer = TestDataFactory.createInterviewer();
        insert interviewer;
        Contact applicant = TestDataFactory.createApplicant();
        insert applicant;
        Account company = TestDataFactory.createAHiringCompany('Best Hiring Company');
        insert company;
        Job_Opening__c jobOpening =TestDataFactory.createAnActiveJobOpeningForACompany(company);
        insert jobOpening;
        Application__c application = TestDataFactory.createAJobApplicationWithoutInterviewer(applicant, jobOpening);
        insert application;
        System.debug(application);

        //when
        Test.startTest();
        application.Interview_Date__c = Date.newInstance(2022, 10, 5);
        application.Interviewer__c = interviewer.Id;
        update application;
        Interview__c interview = [SELECT Id, Interviewer__c, Scheduled_Date__c, Application__c, Stage__c, Candidate_Approved__c from Interview__c WHERE Interviewer__c = :application.Interviewer__c And Scheduled_Date__c = :application.Interview_Date__c AND Application__c = :application.Id LIMIT 1];
        interview = TestDataFactory.setInterviewConductedAccepted(interview);
        update interview;
        interview = [SELECT Id, Interviewer__c, Scheduled_Date__c, Application__c, Stage__c, Candidate_Approved__c from Interview__c WHERE Interviewer__c = :application.Interviewer__c And Scheduled_Date__c = :application.Interview_Date__c AND Application__c = :application.Id LIMIT 1];
        application= [SELECT Id, Status__c from Application__c WHERE Id=:interview.Application__c];

        //then
        System.assertEquals('Candidate Approved', application.Status__c);
    }
    @IsTest
    static void updateRelatedApplication_negative() {
        //given

        Contact interviewer = TestDataFactory.createInterviewer();
        insert interviewer;
        Contact applicant = TestDataFactory.createApplicant();
        insert applicant;
        Account company = TestDataFactory.createAHiringCompany('Best Hiring Company');
        insert company;
        Job_Opening__c jobOpening =TestDataFactory.createAnActiveJobOpeningForACompany(company);
        insert jobOpening;
        Application__c application = TestDataFactory.createAJobApplicationWithoutInterviewer(applicant, jobOpening);
        insert application;
        System.debug(application);

        //when
        Test.startTest();
        application.Interview_Date__c = Date.newInstance(2022, 10, 5);
        application.Interviewer__c = interviewer.Id;
        update application;
        Interview__c interview = [SELECT Id, Interviewer__c, Scheduled_Date__c, Application__c, Stage__c, Candidate_Approved__c from Interview__c WHERE Interviewer__c = :application.Interviewer__c And Scheduled_Date__c = :application.Interview_Date__c AND Application__c = :application.Id LIMIT 1];
        interview = TestDataFactory.setInterviewConductedRejected(interview);
        update interview;
        interview = [SELECT Id, Interviewer__c, Scheduled_Date__c, Application__c, Stage__c, Candidate_Approved__c from Interview__c WHERE Interviewer__c = :application.Interviewer__c And Scheduled_Date__c = :application.Interview_Date__c AND Application__c = :application.Id LIMIT 1];
        application= [SELECT Id, Status__c from Application__c WHERE Id=:interview.Application__c];

        //then
        System.assertEquals('Candidate Rejected', application.Status__c);
    }
}