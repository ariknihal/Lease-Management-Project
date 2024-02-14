trigger LeasingRealEstateAgentTrigger on Leasing_Real_Estate_Agent__c (before insert, before update) {

    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            LeasingRealEstateAgentHandler.DuplicateLeasingRealEstateAgent(Trigger.new);

        }
    }
}