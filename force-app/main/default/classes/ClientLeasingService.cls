

// public with sharing class ClientLeasingService {
    
//     @AuraEnabled(cacheable=true)
//     public static List<MemberWrapper> upcomingLeasing(String potentialclientId) {
//         List<Leasing__c> leasing = [
//             SELECT Id, Name, Leasing_Office_Location__c, Leasing_Office_Location__r.Name, Lease_Office_Manager__c, Lease_Office_Manager__r.Name, Name__c, Start_Date_Time__c, Max_Potential_Client__c,
//                 (SELECT Id, Name FROM Leasing_Potential_Clients__r  WHERE Potential_Client__c = :potentialclientId)
//             FROM Leasing__c
//             WHERE Start_Date_Time__c >= TODAY AND Recurring__c = true WITH SECURITY_ENFORCED
//         ];
//         List<MemberWrapper> memberInfo = new List<MemberWrapper>();
//         for (Leasing__c lea : leasing) {
//             MemberWrapper wrapper = new MemberWrapper();
//             wrapper.isMember = lea.Max_Potential_Client__c > 0;  //wrapper.isMember = lea.Leasing_Potential_Client__r.size() > 0;
//             wrapper.leasing = lea;
//             wrapper.leasingId = lea.Id;
//             wrapper.leasingpotentialclient = wrapper.isMember ? new Leasing_Potential_Client__c(): null; //wrapper.leasingpotentialclient = wrapper.isMember ? lea.Leasing_Potential_Client__r[0] : null;
//             memberInfo.add(wrapper);
//         }
//         return memberInfo;
//     }
    
//     @AuraEnabled(cacheable = true)
//     public static List<Leasing_Potential_Client__c> pastLeasing(String potentialclientId) {
//         return [SELECT Id, Name, Leasing__c, Leasing__r.Leasing_Office_Location__c, Leasing__r.Leasing_Office_Location__r.Name, 
//                 Leasing__r.Lease_Office_Manager__c, Leasing__r.Lease_Office_Manager__r.Name,
//                 Leasing__r.Name__c, Leasing__r.Start_Date_Time__c
//             FROM Leasing_Potential_Client__c
//             WHERE Potential_Client__c = :potentialclientId
//             AND Leasing__r.Start_Date_Time__c < TODAY WITH SECURITY_ENFORCED
//         ];
//     }
    
//     public class MemberWrapper {
//         @AuraEnabled
//         public Boolean isMember;
//         @AuraEnabled
//         public String leasingId;
//         @AuraEnabled
//         public Leasing_Potential_Client__c leasingpotentialclient;
//         @AuraEnabled
//         public Leasing__c leasing;
//     }
// }
public with sharing class ClientLeasingService {
    
    @AuraEnabled(cacheable=true)
    public static List<MemberWrapper> upcomingLeasing(String potentialclientId) {
        List<Leasing__c> leasing = [
            SELECT Id, Name, Leasing_Office_Location__c, Leasing_Office_Location__r.Name, Lease_Office_Manager__c, Lease_Office_Manager__r.Name, Name__c, Start_Date_Time__c,
                (SELECT Id, Name FROM Leasing_Potential_Clients__r WHERE Potential_Client__c = :potentialclientId)
            FROM Leasing__c
            WHERE Start_Date_Time__c >= TODAY AND Recurring__c = true AND Max_Potential_Client__c > 0 WITH SECURITY_ENFORCED
        ];
        List<MemberWrapper> memberInfo = new List<MemberWrapper>();
        for (Leasing__c lea : leasing) {
            MemberWrapper wrapper = new MemberWrapper();
            wrapper.isMember = lea.Leasing_Potential_Clients__r.size() > 0;
            wrapper.leasing = lea;
            wrapper.leasingId = lea.Id;
            wrapper.leasingpotentialclient = wrapper.isMember ? lea.Leasing_Potential_Clients__r[0] : null;
            memberInfo.add(wrapper);
        }
        return memberInfo;
    }
    
    
    
    
    @AuraEnabled(cacheable = true)
    public static List<Leasing_Potential_Client__c> pastLeasing(String potentialclientId) {
        return [SELECT Id, Name, Leasing__c, Leasing__r.Leasing_Office_Location__c, Leasing__r.Leasing_Office_Location__r.Name, 
                Leasing__r.Lease_Office_Manager__c, Leasing__r.Lease_Office_Manager__r.Name,
                Leasing__r.Name__c, Leasing__r.Start_Date_Time__c
            FROM Leasing_Potential_Client__c
            WHERE Potential_Client__c = :potentialclientId
            AND Leasing__r.Start_Date_Time__c < TODAY WITH SECURITY_ENFORCED
        ];
    }
    
    public class MemberWrapper {
        @AuraEnabled
        public Boolean isMember;
        @AuraEnabled
        public String leasingId;
        @AuraEnabled
        public Leasing_Potential_Client__c leasingpotentialclient;
        @AuraEnabled
        public Leasing__c leasing;
    }
}
