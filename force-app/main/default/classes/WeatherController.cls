/**
 * @description       : 
 * @author            : walid abidi
 * @group             : 
 * @last modified on  : 12-07-2023
 * @last modified by  : walid abidi
**/
public class WeatherController {
    
    /**
    * @description get the weather information
    * @author walid abidi | 12-07-2023 
    * @param latitude 
    * @param longitude 
    * @return String (response of geonames ws )

    **/
    @AuraEnabled
    public static String getWheatherInfo(String latitude,String longitude ){
        try {
         String username=[select DeveloperName from username_geoname__mdt  ].DeveloperName;
          Http http = new Http();
          HttpRequest req = new HttpRequest();
          // userName to be addted into a custom metadata
          req.setEndpoint('callout:geonameNC?lat='+latitude+'&lng='+longitude+'&username='+username);
          req.setMethod(Constants.GET);
          HttpResponse resp = http.send(req);
          return resp.getBody();
        } catch (Exception e) {
            System.debug(e.getStackTraceString());
            return e.getMessage();
        }  
        
     }
    
     /**
     * @description 
     * @author walid abidi | 12-07-2023 
     * @param userId 
     * @param accountId 
     * @param isAccount 
     * @param userEmail 
     * @return String 
     **/
     @AuraEnabled
     public static String sendWetherReport(Id userId,Id accountId,Boolean isAccount,String userEmail,String htmlBody ){
           
           createTaskActivity(accountId,userId);
           
            SendEmail.sendEmailMethod(getEmaiList(isAccount?accountId:userId, isAccount,userEmail),htmlBody);
           return '';
      }

     
      /**
      * @description create task 
      * @author walid abidi | 12-07-2023 
      * @param accountId 
      * @param userid 
      **/
      public static void createTaskActivity(Id accountId,Id userid){

                Task accountTask = new Task(
                    Subject = Constants.SUBJECT,
                    WhatId =accountId,
                    Status=Constants.STATUS_COMPLETED,
                    ActivityDate  = Date.today(),
                    OwnerId =userid
                );

            insert accountTask;
         }	
         
         /**
         * @description 
         * @author walid abidi | 12-07-2023 
         * @param id 
         * @param isAccount 
         * @param userEmail 
         * @return List<String> 
         **/
         public static List<String> getEmaiList(Id id,Boolean isAccount,String userEmail){
            List<String> emailList=new List<String>();
            if(isAccount){
                for (contact con : [SELECT Id, Email from contact where AccountId =:id]) {
                    emailList.add(con.Email);
                }  
                
            }else{
                 emailList.add( userEmail);
                 
            }
          return emailList;
         }
        }