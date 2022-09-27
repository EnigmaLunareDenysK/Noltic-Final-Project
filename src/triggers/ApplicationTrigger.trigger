/**
 * Created by Dennis Klochko on 9/24/2022.
 */

trigger ApplicationTrigger on Application__c (before update) {

    ApplicationTriggerHandler.handle(Trigger.newMap, Trigger.oldMap, Trigger.operationType);

}
//trigger ApplicationTrigger on Application__c (before update) {
//
//    ApplicationTriggerHandler.handle(Trigger.new, Trigger.old, Trigger.operationType);
//
//}