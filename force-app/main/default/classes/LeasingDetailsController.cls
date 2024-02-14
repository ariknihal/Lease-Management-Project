public with sharing class LeasingDetailsController {
    @AuraEnabled
    public static List<Leasing_Real_Estate_Agent__c> getLeasingRealEstateAgent(String leasingId) {
        return [
            SELECT Id, Name, Real_Estate_Agent__c, Real_Estate_Agent__r.Name, Real_Estate_Agent__r.Phone__c, Real_Estate_Agent__r.Email__c, Real_Estate_Agent__r.Profile__c, Real_Estate_Agent__r.About_Me__c
            FROM Leasing_Real_Estate_Agent__c
            WHERE Leasing__c = :leasingId
            WITH SECURITY_ENFORCED
        ];
    }
    
    @AuraEnabled
    public static Leasing__c getLocationDetails(String leasingId) {
        return [
            SELECT Id, Name, Leasing_Office_Location__c, Leasing_Office_Location__r.Name, Leasing_Office_Location__r.City__c, Leasing_Office_Location__r.Country__c, Leasing_Office_Location__r.Land_Mark__c, Leasing_Office_Location__r.Postal_Code__c, Leasing_Office_Location__r.State__c, Leasing_Office_Location__r.Street__c
            FROM Leasing__c
            WHERE Id = :leasingId
            WITH SECURITY_ENFORCED
        ];
    }
    
    @AuraEnabled
    public static List<Leasing_Potential_Client__c> getClients(String leasingId) {
        return [
            SELECT Id, Name, Potential_Client__c, Potential_Client__r.Name, Potential_Client__r.Email__c, Potential_Client__r.Leasing_Office_Location__c, Potential_Client__r.Leasing_Office_Location__r.Name
            FROM Leasing_Potential_Client__c
            WHERE Leasing__c = :leasingId
            WITH SECURITY_ENFORCED
        ];
    }
}
