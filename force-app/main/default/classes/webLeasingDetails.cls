@RestResource(urlMapping='/LeasingDetails/*')

global with sharing class webLeasingDetails {



    @HttpGet
    global static list<LeasingDetail> getLeasingDetails() {

        List<LeasingDetail> details = new List<LeasingDetail>();

            for(Leasing__c l : [SELECT Id, Name, Frequency__c, Leasing_Type__c, Recurring__c, Start_Date_Time__c, End_Date_Time__c 
            FROM Leasing__c	
            WHERE Recurring__c = TRUE
            AND Start_Date_Time__c >: Date.today()
            WITH SECURITY_ENFORCED
            ] 
        ){
            details.add(new LeasingDetail(l));
        }

        return details;
 


}
        global class LeasingDetail {

            public String leasingId;
            public String name;
            public String frequency;
            public String leasingType;
            public Boolean recurring;
            public String startDate;
            public String endDate;

            public LeasingDetail(Leasing__c l) {
                this.leasingId = l.Id;
                this.name = l.Name;
                this.frequency = l.Frequency__c;
                this.leasingType = l.Leasing_Type__c;
                this.recurring = l.Recurring__c;
                this.startDate = l.Start_Date_Time__c?.format('yyyy-MM-dd hh:MM');
                this.endDate = l.End_Date_Time__c?.format('yyyy-MM-dd hh:MM');
            }

        }


}
