/**
 * @description       : Apex class to send email
 * @author            : walid abidi
 * @group             : 
 * @last modified on  : 12-07-2023
 * @last modified by  : walid abidi
**/
public class SendEmail {

    /**
    * @description method send email
    * @author walid abidi | 12-07-2023 
    * @param toaddresses :list of address
    **/
    public static void sendEmailMethod(List<String> toaddresses,String htmlBody){
  
                //Messaging.reserveSingleEmailCapacity(2);
                Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
                
                mymail.setToAddresses(toAddresses);
                mymail.setSenderDisplayName('[Doctolib] wheather information');
                mymail.setSubject('Wheather Information ');
                mymail.setPlainTextBody('This email has been sent through Apex');
                mymail.setHtmlBody(htmlBody);
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });
    }
  }