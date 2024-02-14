public with sharing class PurgeLeasing implements Database.Batchable<sObject>, Schedulable {

    public void execute(SchedulableContext s){
        Database.executeBatch(new PurgeLeasing(), 1);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {

    return Database.getQueryLocator([SELECT Id FROM Leasing__c WHERE End_Date_Time__c <=: Datetime.now().addMonths(-2)]);
   }


    public void execute(Database.BatchableContext bc, List<Leasing__c> deleteleasing){

      
       try {
        delete deleteleasing;  
       } catch (Exception exc)  {
        ErrorLogHelper.CreateError('PurgeLeasing', 'execute', exc.getMessage());
        
       }
    }


    public void finish(Database.BatchableContext bc){

        list<GroupMember> members = [SELECT UserOrGroupId FROM GroupMember WHERE Group.DeveloperName =  'DailyJob'];

        set<Id> userIds = new Set<Id>();
        for(GroupMember groupss : members){
            userIds.add(groupss.UserOrGroupId);

        }
        Set<String> toAddresses = new Set<String>();
        for (User u : [SELECT Email FROM User WHERE Id IN: userIds]) {
            toAddresses.add(u.Email);
        }
        if(toAddresses.size() == 0 ) return;

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Daily Leasing Job Has Run');
        mail.setHtmlBody('Hi,<br/><br/> Daily e-mail job has finished.<br/>');

        try {
            Messaging.sendEmail(new list<Messaging.SingleEmailMessage>{mail});
            
        } catch (Exception exc) {
            ErrorLogHelper.CreateError('PurgeLeasing', 'sendEmail', exc.getMessage());
            
        }


       
    }
}
