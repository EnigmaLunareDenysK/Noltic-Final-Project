/**
 * Created by Dennis Klochko on 9/25/2022.
 */

@IsTest
private class ApplicationServiceTest {
    @IsTest
    static void checkTheNumberOfInterviewsThisWeekAndCreate_positive() {

        //given
        Contact interviewer1 = TestDataFactory.createInterviewer();
        insert interviewer1;
        Contact applicant = TestDataFactory.createApplicant();
        insert applicant;
        Date scheduleDate = Date.newInstance(2022, 10, 5);
        Date newScheduleDate = Date.newInstance(2022, 10, 4);
        Account company = TestDataFactory.createAHiringCompany('Best Hiring Company');
        insert company;
        Job_Opening__c jobOpening =TestDataFactory.createAnActiveJobOpeningForACompany(company);
        insert jobOpening;
        Application__c application = TestDataFactory.createAJobApplicationWithInterviewer(applicant, jobOpening, interviewer1);
        insert application;
        List<Interview__c> interviews = TestDataFactory.createNInterviews(2, interviewer1, scheduleDate);
        insert interviews;
//        ApexTrigger at = [SELECT Id, Status, Name from ApexTrigger where name='Notify an Interviewer about new Interview'];
//        at.status = 'Inactive';
//        update at; -> didn't work, so I just disabled the flow in the org


        //when
        Test.startTest();
        application.Interview_Date__c = newScheduleDate;
        update application;
        Test.stopTest();
        //then

        System.assertEquals(3, [SELECT Id from Interview__c WHERE Interviewer__c = :interviewer1.Id].size());

    }

    @IsTest
    static void checkTheNumberOfInterviewsThisWeekAndCreate_negative() {

        //given
        Contact interviewer1 = TestDataFactory.createInterviewer();
        insert interviewer1;
        Contact applicant = TestDataFactory.createApplicant();
        insert applicant;
        Date scheduleDate = Date.newInstance(2022, 10, 5);
        Date newScheduleDate = Date.newInstance(2022, 10, 4);
        Account company = TestDataFactory.createAHiringCompany('Best Hiring Company');
        insert company;
        Job_Opening__c jobOpening =TestDataFactory.createAnActiveJobOpeningForACompany(company);
        insert jobOpening;
        Application__c application = TestDataFactory.createAJobApplicationWithInterviewer(applicant, jobOpening, interviewer1);
        insert application;
        List<Interview__c> interviews = TestDataFactory.createNInterviews(3, interviewer1, scheduleDate);
        insert interviews;
//        FlowDefinitionView flow = [SELECT Id, ApiName, IsActive FROM FlowDefinitionView WHERE ApiName = 'Notify_an_Interviewer_about_new_Interview'];
//        ApexTrigger at = [SELECT Id, Status, Name from ApexTrigger where name='Notify an Interviewer about new Interview'];
//        at.status = 'Inactive';
//        update at; -> didn't work, so I just disabled the flow in the org


        //when
        Test.startTest();
        try {
            application.Interview_Date__c = newScheduleDate;
            update application;
        } catch (DmlException e) {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
            System.assert(e.getMessage().contains('The interviewer you selected has the maximum workload of 3 interviews that week. Please choose another date or another interviewer!'));
        }
        Test.stopTest();
        //then

        System.assertEquals(3, [SELECT Id from Interview__c WHERE Interviewer__c = :interviewer1.Id].size());

    }
}