/**
 * Created by Dennis Klochko on 9/24/2022.
 */

trigger InterviewTrigger on Interview__c (after update, after insert) {

    InterviewTriggerHandler.handle(Trigger.new, Trigger.operationType);

}

//
//trigger InterviewTrigger on Interview__c (after update) {
//
//    InterviewTriggerHandler.handle(Trigger.new, Trigger.operationType);
//
//}