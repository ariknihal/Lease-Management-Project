public with sharing class ErrorLogHelper {
    public static void CreateError(string ProcessName, string ApexClass, String LogDetails) {

        Error_Log__c l = new Error_Log__c();
        l.Process_Name__c = ProcessName;
        l.Log_Details__c = LogDetails;
        l.Log_Date_Time__c = Datetime.now();
        l.Apex_Class__c = ApexClass;


        insert l;

    }
}