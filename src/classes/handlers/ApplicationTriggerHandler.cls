/**
 * Created by Dennis Klochko on 9/24/2022.
 */

public with sharing class ApplicationTriggerHandler {

    public static void handle(Map<Id, Application__c> updatedApplications, Map<Id, Application__c> applicationsPrevious, System.TriggerOperation triggerOperation) {
        switch on triggerOperation {
            when BEFORE_UPDATE {
                ApplicationService.createInterviewIfInterviewerHasThemLessThanThree(updatedApplications, applicationsPrevious);
            }
        }
    }

}

//public with sharing class ApplicationTriggerHandler {
//
//    public static void handle(List<Application__c> updatedApplications, List<Application__c> applicationsPrevious, System.TriggerOperation triggerOperation) {
//        switch on triggerOperation {
//            when BEFORE_UPDATE {
//                ApplicationService.checkTheNumberOfInterviewsThisWeekAndCreate(updatedApplications, applicationsPrevious);
//            }
//        }
//    }
//
//}