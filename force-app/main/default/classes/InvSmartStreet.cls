public with sharing class InvSmartStreet {
   
        @InvocableMethod(label='Smarty Street' description='Http GET Smarty' category='Location__c')
        public static void getAccountNames(list<Id> locationIds) {
      

            makeCallout(locationIds[0]);


}


@future(callout=true)
private static void makeCallout(Id locationId){


    try{

        Leasing_Office_Location__c location =[Select City__c , Postal_Code__c , State__c , Street__c from Leasing_Office_Location__c where Id =: locationId];

        SmartyStreet__c setting = SmartyStreet__c.getOrgDefaults();



        string path = '/street-address'
        
        +'?auth-id=' + setting.AuthId__c
        +'&auth-token=' + setting.AuthToken__c
        +'&street=' + EncodingUtil.urlEncode(location.Street__c, 'UTF-8')
        +'&city=' + EncodingUtil.urlEncode(location.City__c, 'UTF-8')
        +'&state=' + EncodingUtil.urlEncode(location.State__c, 'UTF-8')
        +'&zipcode' + location.Postal_Code__c
        +'match=enhanced';

        System.debug('path:' + path);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SmartyStreet' + path);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        Integer StatusCode = response.getStatusCode();
        System.debug('statusCode:' + StatusCode);


        String respBody = response.getBody();
        System.debug('respBody:' + respBody);

            if(StatusCode == 200){

            update new Leasing_Office_Location__c(Id = locationId, Verified__c = true);
             } else{
            update new Leasing_Office_Location__c(Id = locationId, Verified__c = false);
             }
      
            update new Leasing_Office_Location__c(Id = locationId, Verified__c = StatusCode == 200 );


    }catch(Exception exc){

        String msg = exc.getMessage() + '(line : ' + exc.getLineNumber();
        System.debug('EXC:' + msg);

        ErrorLogHelper.CreateError('InvSmartStreet', 'makeCallout', msg);




    }



}
   

}
