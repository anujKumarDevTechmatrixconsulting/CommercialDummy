/**
* @File Name          : GenerateOTPValidationTest.cls
* @Description        : Test class for GenerateOTPValidation SFMC API.
* @Author             : Nishant Prajapati
*==============================================================================
* Ver             Author                   Modification
*==============================================================================
* 1.0             Nishant Prajapati           Initial Version
**/
@isTest(seeAllData = false)
public class GenerateOTPValidationTest{
    @testSetup
    static void testrecordcreation(){
        
        List<Account> userAccountList = TestDataFactory.createBusinessAccount(1, 'User Account');
        insert userAccountList;
        
        List<Account> personAccountList = TestDataFactory.createPersonAccount(2);
        insert personAccountList;
        
        List<Opportunity> oppList = TestDataFactory.createTestOpportunity(1, 'Vehicle Sales');
        oppList[0].accountId = userAccountList[0].id;
        oppList[0].StageName = 'New';
        oppList[0].Customer__c= personAccountList[0].Id;
        oppList[0].ownerId = label.Integration_user;
        
        if(opplist.size() > 0)
            opplist[0].Mobile__c= '9001256780';
        
        insert opplist;
        //insert Account
        list<Account> accList = TestDataFactory.createPersonAccount(1);
        Insert accList;
    }
    
    @istest
    static void otptest(){
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new GenerateOTPMockClass()); 
        list<Opportunity> opplist = new list<opportunity>([Select id from opportunity]);
        GenerateOTPValidation.saveOtp('123456',opplist[0].id,new map<String, Object>());
        list<Opportunity> opplistQuery = new list<opportunity>([Select id,OTP_Base_Value__c from opportunity]);
        test.stopTest();
    }
    
    @istest
    static void otptestAcc(){
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new GenerateOTPMockClass()); 
        list<Account> accListQuery = new list<Account>([Select id,PersonMobilePhone,OTP_Base_Value__c from Account where isPersonAccount =true]);
        GenerateOTPValidation.saveOtp('123456',accListQuery[0].id,new map<String, Object>());
        test.stopTest();
    }
    @istest
    static void otptestCVScenario(){
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new GenerateOTPMockClass()); 
        list<Account> accListQuery = new list<Account>([Select id,PersonMobilePhone,OTP_Base_Value__c from Account where isPersonAccount =true]);
        GenerateOTPValidation.saveOtp('123456',accListQuery[0].id,new map<String, Object>{'CUSOTOMER_VISIBILITY_OTP'=>'CUSOTOMER_VISIBILITY_OTP'});
        test.stopTest();
    }
}