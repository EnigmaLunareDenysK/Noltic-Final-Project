/**
 * Created by Dennis Klochko on 9/27/2022.
 */

@IsTest
private class ContactControllerTest {
    @IsTest
    static void getInterviewsListByAccountId_positive() {
        Id candidateRTId = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Candidate' and SobjectType = 'Contact' limit 1].Id;
        Id interviewerRTId = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Interviewer' and SobjectType = 'Contact' limit 1].Id;
        Contact contactCandidate = new Contact(LastName = 'TestCandidate1', RecordTypeId = candidateRTId);
        Contact contactInterviewer = new Contact(LastName = 'TestInterviewer1', RecordTypeId = interviewerRTId);
        insert contactCandidate;
        insert contactInterviewer;


        Test.startTest();
        insert new Interview__c(Scheduled_Date__c = Date.today(), Applicant__c = contactCandidate.Id);
        insert new Interview__c(Scheduled_Date__c = Date.today() + 2, Applicant__c = contactCandidate.Id);
        insert new Interview__c(Scheduled_Date__c = Date.today() + 2, Interviewer__c = contactInterviewer.Id);
        List<Interview__c> interviewsForCandidate = ContactController.getInterviewsListByContactId(contactCandidate.Id);
        List<Interview__c> interviewsForInterviewer = ContactController.getInterviewsListByContactId(contactInterviewer.Id);
        Test.stopTest();

        System.assertEquals(2, interviewsForCandidate.size());
        System.assertEquals(1, interviewsForInterviewer.size());
    }
    @IsTest
    static void getInterviewsListByContactIdForTheCurrentWeek_positive() {
        Id candidateRTId = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Candidate' and SobjectType = 'Contact' limit 1].Id;
        Id interviewerRTId = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Interviewer' and SobjectType = 'Contact' limit 1].Id;
        Contact contactCandidate = new Contact(LastName = 'TestCandidate1', RecordTypeId = candidateRTId);
        Contact contactInterviewer = new Contact(LastName = 'TestInterviewer1', RecordTypeId = interviewerRTId);
        insert contactCandidate;
        insert contactInterviewer;


        Test.startTest();
        insert new Interview__c(Scheduled_Date__c = Date.today(), Applicant__c = contactCandidate.Id);
        insert new Interview__c(Scheduled_Date__c = Date.today() + 10, Applicant__c = contactCandidate.Id);
        insert new Interview__c(Scheduled_Date__c = Date.today() + 2, Interviewer__c = contactInterviewer.Id);

        List<Interview__c> interviewsForCandidate = ContactController.getInterviewsListByContactIdForTheCurrentWeek(contactCandidate.Id);
        List<Interview__c> interviewsForInterviewer = ContactController.getInterviewsListByContactIdForTheCurrentWeek(contactInterviewer.Id);
        Test.stopTest();

        System.assertEquals(1, interviewsForCandidate.size());
        System.assertEquals(1, interviewsForInterviewer.size());
    }
    @IsTest
    static void getConductedInterviews_positive() {
        Contact contact = new Contact(LastName = 'TestContact1');
        insert contact;


        Test.startTest();
        insert new Interview__c(Scheduled_Date__c = Date.today(), Applicant__c = contact.Id, Stage__c = 'Conducted');
        insert new Interview__c(Scheduled_Date__c = Date.today() + 2, Applicant__c = contact.Id);
        List<Interview__c> interviews = ContactController.getConductedInterviews(contact.Id);
        Test.stopTest();

        System.assertEquals(1, interviews.size());
    }
    @IsTest
    static void getCancelledInterviews_positive() {
        Contact contact = new Contact(LastName = 'TestContact1');
        insert contact;


        Test.startTest();
        insert new Interview__c(Scheduled_Date__c = Date.today(), Applicant__c = contact.Id, Stage__c = 'Canceled');
        insert new Interview__c(Scheduled_Date__c = Date.today() + 2, Applicant__c = contact.Id);
        List<Interview__c> interviews = ContactController.getCancelledInterviews(contact.Id);
        Test.stopTest();

        System.assertEquals(1, interviews.size());
    }
    @IsTest
    static void getSuccessfulInterviewsWithJobOffer_positive() {
        Contact contact = new Contact(LastName = 'TestContact1');
        insert contact;


        Test.startTest();
        insert new Job_Offer__c(Applicant__c = contact.Id);
        List<Job_Offer__c> interviews = ContactController.getSuccessfulInterviewsWithJobOffer(contact.Id);
        Test.stopTest();

        System.assertEquals(1, interviews.size());
    }
    @IsTest
    static void getFailedInterviews_positive() {
        Contact contact = new Contact(LastName = 'TestContact1');
        insert contact;


        Test.startTest();
        insert new Interview__c(Scheduled_Date__c = Date.today(), Applicant__c = contact.Id, Stage__c = 'Conducted', Candidate_Approved__c = true);
        insert new Interview__c(Scheduled_Date__c = Date.today() + 2, Applicant__c = contact.Id, Stage__c = 'Conducted', Candidate_Approved__c = false);
        List<Interview__c> interviews = ContactController.getFailedInterviews(contact.Id);
        Test.stopTest();

        System.assertEquals(1, interviews.size());
    }
    @IsTest
    static void getSuccessfulInterviews_positive() {
        Contact contact = new Contact(LastName = 'TestContact1');
        insert contact;


        Test.startTest();
        insert new Interview__c(Scheduled_Date__c = Date.today(), Applicant__c = contact.Id, Stage__c = 'Conducted', Candidate_Approved__c = true);
        insert new Interview__c(Scheduled_Date__c = Date.today() + 2, Applicant__c = contact.Id, Stage__c = 'Conducted', Candidate_Approved__c = false);
        List<Interview__c> interviews = ContactController.getSuccessfulInterviews(contact.Id);
        Test.stopTest();

        System.assertEquals(1, interviews.size());
    }
}