/**
 * @description       : 
 * @author            : walid abidi
 * @group             : 
 * @last modified on  : 12-07-2023
 * @last modified by  : walid abidi
**/
@isTest
public with sharing class WeatherControllerTest {
    @IsTest
    static void getWheatherInfoTest(){
    
        Test.setMock( HttpCalloutMock.class, new MockHttpResponse());
    
               
        Test.startTest();
        String responseBody='{'
            +'"weatherObservation": {'
              + ' "elevation": 179,'
              + '  "lng": 2.2,'
              + '   "observation": "LFPV 051800Z AUTO 28007KT 9999 FEW018 OVC040 06/04 Q1011 NOSIG",'
              + '   "ICAO": "LFPV",'
              + ' "clouds": "few clouds",'
              + ' "dewPoint": "4",'
              + '  "cloudsCode": "FEW",'
              + ' "datetime": "2023-12-05 18:00:00",'
              + '  "countryCode": "FR",'
              + '  "temperature": "6",'
              + '  "humidity": 86,'
              + '  "stationName": "Villacoublay",'
              + '  "weatherCondition": "n/a",'
              + ' "windDirection": 280,'
              + '  "hectoPascAltimeter": 1011,'
              + '  "windSpeed": "07",'
              + ' "lat": 48.766666666666669'
              + ' }'
              + ' }';
        // Synchronous function call
       String result= WeatherController.getWheatherInfo('-2','43' );
        Test.stopTest();

        // Verify that the received response contains expected mock values
      
        System.assertEquals(responseBody,result);
       
   }
    @IsTest
    static void sendEmailToContactsTest(){
    
       

   }
}