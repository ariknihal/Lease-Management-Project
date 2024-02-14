public with sharing class LeasingRealEstateAgentHandler {
    public static void DuplicateLeasingRealEstateAgent(list<Leasing_Real_Estate_Agent__c> LeasingRealEstateAgent){

        map<string, Leasing_Real_Estate_Agent__c> lrEstateMap = new map<string, Leasing_Real_Estate_Agent__c>();

        set<id> leasingIds = new set<id>();
        set<id> realestateagentIds = new set<id>();

        for(Leasing_Real_Estate_Agent__c rea : LeasingRealEstateAgent) {
            String Key = string.valueOf(rea.Real_Estate_Agent__c) + string.valueOf(rea.Leasing__c);
            lrEstateMap.put(Key, rea);

            leasingIds.add(rea.Leasing__c);
            realestateagentIds.add(rea.Real_Estate_Agent__c);

        }

        List<Leasing_Real_Estate_Agent__c> Record = [select id, Leasing__c, Real_Estate_Agent__c FROM Leasing_Real_Estate_Agent__c WHERE Leasing__c IN: leasingIds AND Real_Estate_Agent__c IN: realestateagentIds ];


        for(Leasing_Real_Estate_Agent__c leasing : Record){

            String Key = string.valueOf(leasing.Real_Estate_Agent__c) + string.valueOf(leasing.Leasing__c);

            Leasing_Real_Estate_Agent__c checkObj = lrEstateMap.get(Key);

            if(checkObj == null) continue;

            checkObj.addError('System found duplicate rule ' + String.valueOf(leasing.Id));



        }


    }
    
}