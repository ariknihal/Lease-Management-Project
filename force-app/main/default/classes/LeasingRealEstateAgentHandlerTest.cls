@isTest
private class LeasingRealEstateAgentHandlerTest {
    @TestSetup
    static void makeTestData(){

        Lease_Office_Manager__c Office = new Lease_Office_Manager__c(Name = 'Lease Office Manager Name 1', Email__c	= 'office1@test.com' , Phone__c	= '000000000');

        insert Office;

        Leasing__c leasing = new Leasing__c(Lease_Office_Manager__c = Office.Id, Name__c = 'Test' , Status__c = 'Created' ,  Start_Date_Time__c = Datetime.now().addDays(-14), End_Date_Time__c = Datetime.now().addDays(14) );


        insert leasing;

        Real_Estate_Agent__c RealEstate = new Real_Estate_Agent__c(Name = 'Real Estate Agent Name 1' , Email__c = 'realestateagent1@test.com' , Phone__c = '111111111');

        insert RealEstate;

        Leasing_Real_Estate_Agent__c LeasingRealEstate = new Leasing_Real_Estate_Agent__c(Leasing__c = leasing.Id, Real_Estate_Agent__c = RealEstate.Id);

        insert LeasingRealEstate;
        
    }
    @isTest

    static void Positive(){

    Leasing_Real_Estate_Agent__c LeasingRealEstate = [ Select Id, Leasing__c, Real_Estate_Agent__c From Leasing_Real_Estate_Agent__c LIMIT 1 ];

    Boolean isFailed = false;

    try{
        Leasing_Real_Estate_Agent__c  NewLeasing = new Leasing_Real_Estate_Agent__c(Leasing__c = LeasingRealEstate.Leasing__c, Real_Estate_Agent__c = LeasingRealEstate.Real_Estate_Agent__c );

        insert NewLeasing;
    } catch (Exception ex) {
        isFailed= true;
    }
    system.assert(isFailed);


    }

    @isTest

    static void Negative(){

        delete [select id from Leasing_Real_Estate_Agent__c];
        Leasing__c leasing = [select id from  Leasing__c limit 1];
        Real_Estate_Agent__c LeasingRealEstate = [select id from  Real_Estate_Agent__c limit 1];

        Test.startTest();
        insert new Leasing_Real_Estate_Agent__c(Leasing__c = leasing.Id, Real_Estate_Agent__c = LeasingRealEstate.Id);
        Test.stopTest();

        Integer Count = [select COUNT() from Leasing_Real_Estate_Agent__c];
        system.assertEquals(1, Count);

    }

}



    



    
