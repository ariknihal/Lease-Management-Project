public with sharing class LeasingDetails {
    
    @AuraEnabled
    public static List<Leasing__c> searchByKeyword(String name){
        String nameLike = '%' + name + '%';

        return [SELECT Id, Name, Name__c, Leasing_Detail__c, Leasing_Office_Location__c,Leasing_Office_Location__r.Name, Lease_Office_Manager__c,Start_Date_Time__c, Lease_Office_Manager__r.Name 
                FROM Leasing__c
                WHERE Start_Date_Time__c >= TODAY
                AND Recurring__c = true
                AND Name__c LIKE : nameLike
                WITH SECURITY_ENFORCED];
    }
}