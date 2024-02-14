// public with sharing class EditMembershipService {
  
//     @AuraEnabled
//     public static List<MemberWrapper> findLeasing(String potentialclientId, String selection){

//         List<MemberWrapper> memberInfo = new List<MemberWrapper>();

//         List<Leasing__c> leasing = [
//             SELECT Id, Name, Location__c, Leasing_Office_Location__r.Name, Lease_Office_Manager__c, Lease_Office_Manager__r.Name, Name__c, Start_Date_Time__c,
//             (SELECT Id, Name 
//             FROM Leasing_Potential_Clients__r 
//             WHERE Potential_Client__c = :potentialclientId)
//             FROM Leasing__c
//             WHERE Recurring__c = true
//             WITH SECURITY_ENFORCED
//         ];

//         for (Leasing__c lea : leasing) {
//             MemberWrapper wrapper = new MemberWrapper();
//             wrapper.isMember = lea.Max_Potential_Client__c > 0;
//             wrapper.leasing = lea;
//             wrapper.leasingId = lea.Id;
//             wrapper.leasingpotentialclient = wrapper.isMember ? lea.Leasing_Potential_Clients__r[0] : null;
//             //wrapper.leasingpotentialclient = wrapper.isMember ? lea.Max_Potential_Client__c : null;

//             if(selection.equalsIgnoreCase('delete') && wrapper.isMember){
//                 memberInfo.add(wrapper);

//             }
//             else if(selection.equalsIgnoreCase('create') && !wrapper.isMember){

           
//             memberInfo.add(wrapper);
//         }
//     }
//         return memberInfo;
//     }

//     @AuraEnabled
    
//     public static Boolean manageMembership(string potentialclientId , List<string> leasingIds , string selection){
//         System.debug('leasingIds:' + leasingIds);

//         try{
//             if(selection.equalsIgnoreCase('delete')){
//                 delete [SELECT Id FROM Leasing_Potential_Client__c WHERE Leasing__c IN: leasingIds AND Potential_Client__c =: potentialclientId ];

//             }
//             else if (selection.equalsIgnoreCase('create')){
//                 list<Leasing_Potential_Client__c> newPotentialClients = new list<Leasing_Potential_Client__c>();
//                 for(string lId : leasingIds ){
//                     newPotentialClients.add(new Leasing_Potential_Client__c(Leasing__c = lId, Potential_Client__c = potentialclientId));
                    
//                 }
//                 insert newPotentialClients;
//             }
//             return true;
//         } catch(Exception exc){
//              throw new AuraHandledException(exc.getMessage());
//         }
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

public with sharing class EditMembershipService {
    @AuraEnabled
    public static List<MemberWrapper> findLeasing(String potentialclientId, String selection) {
        

        List<Leasing__c> leasing = [
            SELECT Id, Name, Leasing_Office_Location__c, Leasing_Office_Location__r.Name, Lease_Office_Manager__c, Lease_Office_Manager__r.Name, Name__c, Start_Date_Time__c,
            (SELECT Id, Name 
            FROM Leasing_Potential_Clients__r 
            WHERE Potential_Client__c = :potentialclientId)
            FROM Leasing__c
            WHERE Recurring__c = true
            WITH SECURITY_ENFORCED
        ];
        List<MemberWrapper> memberInfo = new List<MemberWrapper>();

        for (Leasing__c lea : leasing) {
            MemberWrapper wrapper = new MemberWrapper();
            wrapper.isMember = lea.Leasing_Potential_Clients__r.size() > 0;
            wrapper.leasing = lea;
            wrapper.leasingId = lea.Id;
            wrapper.leasingpotentialclient = wrapper.isMember ? lea.Leasing_Potential_Clients__r[0] : null;

            if (selection.equalsIgnoreCase('delete') && wrapper.isMember) {
                memberInfo.add(wrapper);
            } else if (selection.equalsIgnoreCase('create') && !wrapper.isMember) {
                memberInfo.add(wrapper);
            }
        }
        return memberInfo;
    }

    @AuraEnabled
    public static Boolean manageMembership(String potentialclientId, List<String> leasingIds, String selection) {
        System.debug('leasingIds:' + leasingIds);

        try {
            if (selection.equalsIgnoreCase('delete')) {
                delete [SELECT Id FROM Leasing_Potential_Client__c WHERE Leasing__c IN :leasingIds AND Potential_Client__c = :potentialclientId];
            } else if (selection.equalsIgnoreCase('create')) {
                List<Leasing_Potential_Client__c> newPotentialClients = new List<Leasing_Potential_Client__c>();
                for (String lId : leasingIds) {
                    newPotentialClients.add(new Leasing_Potential_Client__c(Leasing__c = lId, Potential_Client__c = potentialclientId));
                }
                insert newPotentialClients;
            }
            return true;
        } catch (Exception exc) {
            throw new AuraHandledException(exc.getMessage());
        }
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
