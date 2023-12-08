/**
 * @description       : 
 * @author            : walid abidi
 * @group             : 
 * @last modified on  : 12-07-2023
 * @last modified by  : walid abidi
**/
@IsTest
public with sharing class SendEmailTest {
    
    @IsTest
    static void testThatEmailWasSent(){
    
       Test.startTest();
       List<String> emailList=new List<String>();
        
       emailList.add('wabidi73@gmail.com');
       System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');

       SendEmail.sendEmailMethod(emailList,'Html Body');

       System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');
       Test.stopTest();
   }
}