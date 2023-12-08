/**
 * @description       : 
 * @author            : walid abidi
 * @group             : 
 * @last modified on  : 12-07-2023
 * @last modified by  : walid abidi
**/
public with sharing class DataFactoryTest {

    /**
    * @description create account record
    * @author walid abidi | 12-07-2023 
    * @return Account 
    **/
    public static Account createAccount(){
        Id recordTypeIdPS = Schema.SObjectType.Account.getRecordTypeInfosByName()
      .get('ProfessionneSante')
      .getRecordTypeId();
        Account account = new Account();
        account.RecordTypeId = recordTypeIdPS;
        account.name = 'Test' ;
        account.Discipline__c = 'Optique';
        account.DateDeffetDuConventionnementCPAM__c = date.today();
        account.Statut__c = 'actif';
        account.Phone = '0222222222';
        account.Email__c = 'test@test.com';
        insert account;
        return account;
    }
}