@isTest
private class PurgeLeasingTest {

    @isTest
    static void test(){
        Lease_Office_Manager__c Office = new Lease_Office_Manager__c(Name = 'Lease Office Manager Name 1', Email__c	= 'office1@test.com' , Phone__c	= '000000000');

        insert Office;

        Leasing__c leasing1 = new Leasing__c(Lease_Office_Manager__c = Office.Id, Name__c = 'Test 1' , Status__c = 'Created' ,  Start_Date_Time__c = Datetime.now().addDays(-14), End_Date_Time__c = Datetime.now().addDays(14) );

        Leasing__c leasing2 = new Leasing__c(Lease_Office_Manager__c = Office.Id, Name__c = 'Test 2' , Status__c = 'Completed' ,  Start_Date_Time__c = Datetime.now().addMonths(-3), End_Date_Time__c = Datetime.now().addMonths(-3).addDays(14));

        insert new list<Leasing__c>{leasing1, leasing2};

        test.startTest();
        PurgeLeasing ob = new PurgeLeasing();
        ob.execute(null);

        test.stopTest();
       
        Integer leasing = [SELECT COUNT() FROM Leasing__c ];
        system.assertEquals(1, leasing);

    


      

    }

}