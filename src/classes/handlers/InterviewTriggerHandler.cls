/**
 * Created by Dennis Klochko on 9/24/2022.
 */

public with sharing class InterviewTriggerHandler {

    public static void handle(List<Interview__c> interviews, System.TriggerOperation triggerOperation){
        switch on triggerOperation{
            when AFTER_UPDATE{
                InterviewService.updateRelatedApplication(interviews);
            }
        }
    }

}