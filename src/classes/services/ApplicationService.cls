/**
 * Created by Dennis Klochko on 9/24/2022.
 */

public with sharing class ApplicationService {

    public static void createInterviewIfInterviewerHasThemLessThanThree(Map<Id, Application__c> updatedApplications, Map<Id, Application__c> applicationsPrevious) {
        //Check if interview date or interviewer have changed
        //get all interviews
        //check the date and see it falls within the week of the date from the application
        // check if interviewer  is the same as interviewer in this application- if it is, counter++
        //if counter <3 - create an interview, fill out the fields from application and application id itself else - prompt an error


        Set<Id> applicationIds = updatedApplications.keySet();
        List<Interview__c> allInterviews = [SELECT Id, Interviewer__c, Scheduled_Date__c, Application__c FROM Interview__c];
        List<Interview__c> interviewsToCreate = new List<Interview__c>();

        for (Id appId : applicationIds) {
            Integer counter = 0;
            if (updatedApplications.get(appId).Interview_Date__c != applicationsPrevious.get(appId).Interview_Date__c || updatedApplications.get(appId).Interviewer__c != applicationsPrevious.get(appId).Interviewer__c) {
                for (Interview__c interview : allInterviews) {
                    if (isoWeekNumber(interview.Scheduled_Date__c) == isoWeekNumber(updatedApplications.get(appId).Interview_Date__c)) {
                        counter = (interview.Interviewer__c == updatedApplications.get(appId).Interviewer__c) ? counter + 1 : counter;
                    }
                }
                if (counter < 3) {
                    interviewsToCreate.add(new Interview__c(Scheduled_Date__c = updatedApplications.get(appId).Interview_Date__c, Application__c = updatedApplications.get(appId).Id, Applicant__c = updatedApplications.get(appId).Applicant__c, Interviewer__c = updatedApplications.get(appId).Interviewer__c, Job_Opening__c = updatedApplications.get(appId).Job_Opening__c));
                } else {
                    updatedApplications.get(appId).addError('The interviewer you selected has the maximum workload of 3 interviews that week. Please choose another date or another interviewer!');
                }
            }
        }

        insert interviewsToCreate;
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

}

//public with sharing class ApplicationService {
//
//
//    public static void checkTheNumberOfInterviewsThisWeekAndCreate(List<Application__c> updatedApplications, List<Application__c> applicationsPrevious) {
//        List<Interview__c> allInterviews = [SELECT Id, Interviewer__c, Scheduled_Date__c FROM Interview__c];
//        List<Interview__c> interviewsForInterviewer;
//        List<Interview__c> interviewsToCreate = new List<Interview__c>();
//
//        for (Application__c application : updatedApplications) {
//            Application__c previousStateOfApplication;
//            for (Application__c applicationPrevious : applicationsPrevious) {
//                if (application.Id == applicationPrevious.Id) {
//                    previousStateOfApplication = applicationPrevious;
//                }
//            }
//            if (previousStateOfApplication != null && (previousStateOfApplication.Interview_Date__c != application.Interview_Date__c || previousStateOfApplication.Interviewer__c != application.Interviewer__c)) {
//                interviewsForInterviewer = new List<Interview__c>();
//                for (Interview__c interview : allInterviews) {
//                    if (interview.Interviewer__c == application.Interviewer__c && isoWeekNumber(interview.Scheduled_Date__c) == isoWeekNumber(application.Interview_Date__c)) {
//                        interviewsForInterviewer.add(interview);
//                    }
//                }
//                if (interviewsForInterviewer.size() < 3) {
//                    interviewsToCreate.add(new Interview__c(Scheduled_Date__c = application.Interview_Date__c, Application__c = application.Id, Applicant__c = application.Applicant__c, Interviewer__c = application.Interviewer__c, Job_Opening__c = application.Job_Opening__c));
//
//                } else {
//                    application.addError('The interviewer you selected has the maximum workload of 3 interviews that week. Please choose another date or another interviewer!');
//                }
//            }
//
//
//        }
//        insert interviewsToCreate;
//
//
//    }
//
//    private static Integer isoWeekNumber(Date value) {
//        Integer daysSince1900_01_07 = Date.newInstance(1900, 1, 7).daysBetween(value);
//        Integer dayNumber = Math.mod(daysSince1900_01_07, 7) + 1;
//
//        Date dateForYear = value.addDays(Math.mod(8 - dayNumber, 7) - 3);
//        Integer year = dateForYear.year();
//        Date year_01_01 = Date.newInstance(year, 1, 1);
//
//        Integer week = (Integer) Math.floor((year_01_01.daysBetween(value)
//                + Math.mod((Math.mod(Date.newInstance(1900, 1, 7).daysBetween(year_01_01), 7) + 1) + 1, 7) - 3) / 7 + 1);
//
//        return week;
//    }
//
//}