public with sharing class searchController {
    @AuraEnabled
    public static String searchRecords(String objName, String fieldName, String searchKey){
        String searchKeyword = searchKey +'*';
        String returningQuery = objName+ ' (Id, '+fieldName+')';
        String query ='FIND :searchKeyword IN ALL FIELDS RETURNING '+returningQuery+' LIMIT 2000';
        List<List<SObject>> records = Search.query(query);
        return JSON.serialize(records);
    }
}

// public with sharing class searchController {
//     @AuraEnabled
//     public static String searchRecords(String objName, String fieldName, String searchKey){
//         String searchKeyword = searchKey +'*';
//         String returningQuery = objName+ ' (Id, '+fieldName+')';
//         String query ='FIND :searchKeyword IN ALL FIELDS RETURNING '+returningQuery+' LIMIT 2000';
//         List<List<SObject>> records = Search.query(query);
        
//         List<Map<String, Object>> serializedRecords = new List<Map<String, Object>>();
//         for (List<SObject> recordList : records) {
//             for (SObject record : recordList) {
//                 Map<String, Object> serializedRecord = new Map<String, Object>{
//                     'Id' => record.Id,
//                     fieldName => record.get(fieldName)
//                 };
//                 serializedRecords.add(serializedRecord);
//             }
//         }
        
//         return JSON.serialize(serializedRecords);
//     }
// }
