/**
 * @File Name          : TestDataFactory.cls
 * @Description        : 
 * @Author             : Rajesh Ramachandran
 * @Group              : 
 * @Last Modified By   : Rajesh Ramachandran
 * @Last Modified On   : 1/1/2020, 7:17:59 PM
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    12/29/2019   Rajesh Ramachandran     Initial Version
**/
@isTest
public class TestDataFactory {
   
    // CREATE BUSINESS ACCOUNT BASED ON RECORDTYPE
    public static List<Account> createBusinessAccount(Integer numAccts,String accRecTypeName){
        List<Account> accts = new List<Account>(); 
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(accRecTypeName).getRecordTypeId();
        
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i,RecordTypeId=AccRecTypeId);
            accts.add(a); 
        }
        return accts;
    } 
    
    
    // CREATE CONTACTS BASED ON ACCOUNTID
    public static List<Contact> createTestContact(Integer numOfRec, String accountId) {
        List<Contact> contactList = new List<Contact>();
        
        for( Integer i = 0; i < numOfRec; i++ ) {
            
            Contact con = new Contact(LastName = 'John '+i,
                                    accountId = accountId);
            contactList.add(con);
        }
        
        return contactList;
    }


    // CREATE PERSON ACCOUNTS
    public static List<Account> createPersonAccount(Integer numAccts){
        List<Account> accts = new List<Account>();  
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        for(Integer i=0;i<numAccts;i++){
            Account a = new Account(recordTypeId=AccRecTypeId ,FirstName='test',LastName='account',MiddleName='pro',PersonMobilePhone = '9888585565',PersonBirthdate=date.parse('05/11/2012'));
            accts.add(a);
        } 
        
        return accts;
    }

    // CREATE FOR CODE
    public static List<For_Code__c> createTestForCode(Integer numOfRec) {
        List<For_Code__c> forCode = new List<For_Code__c>();
        
        for( Integer i = 0; i < numOfRec; i++ ) {
            
            For_Code__c fcode = new For_Code__c(Name = 'Central For Code '+i,
                                                Zone_Code__c = 'Central',
                                                Region_Code__c = 'C2',
                                                For_Code__c = 'FC-1234'+string.valueOf(system.now()));
            forCode.add(fcode);
        }
        
        return forCode;
    }
    
    
    // CREATE PORTAL/INTERNAL USERS BASED ON PROFILE NAME
    public static List<User> createUserData(String Type, String profileName, List<Contact> contactList){
        List<User> userData = new List<User>();
        
        if(Type == 'Portal'){
            for(contact con : contactList){
                userData.add(generateUserData(con, queryProfileInfo(profileName), profileName));
            }
        }else if(Type == 'Internal'){
            userData.add(generateUserData(new Contact(), queryProfileInfo(profileName), profileName));
        }
        
        return userData;
    }
    
    //CALLED FROM createUserData METHOD
    public static User generateUserData(Contact con, string profileId, string profileName){
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                  Title=ProfileName=='Dealer Sales Executive' ? label.Sales_Executive : 'Team Lead',
                  LocaleSidKey='en_US', ProfileId = profileId, 
                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com'+String.valueOf(Math.random()));
        if(con.LastName != null){
            u.ContactId = con.Id;
        }
        return u;
    }
    
    //QUERY PROFILE NAME BASED ON PASSED STRING
    public static String queryProfileInfo(String ProfileName){
        String profileId = '';
        List<Profile> profileList = new List<Profile>([Select Id from Profile Where Name =: ProfileName]);
        if(profileList != Null && profileList.size() > 0){
            profileId = profileList[0].Id;
        }
        return profileId;
    }
     
    
    // CREATE EVENT VIST PLANS
    public static list<Event_Visit_Plan__c> createEventsPlans(integer numOfRec){
        list<Event_Visit_Plan__c> eventList = new list<Event_Visit_Plan__c>();
        for(integer i =0;i<numOfRec;i++){
            Event_Visit_Plan__c ev =new Event_Visit_Plan__c();
            ev.Name = 'Test';
            eventList.add(ev);
        }
        return eventList;
    }
    
    
    
    // CREATE ACCOUNT TEAM MEMBERS
    public static list<AccountTeamMember> createAccountTeamMember(Integer numOfRec,string userIdd){
        list<AccountTeamMember> AccountTeamMemberList = new list<AccountTeamMember>();
        for(integer i=0;i<numOfRec;i++){
            AccountTeamMember acmember = new AccountTeamMember();
            acmember.UserId = userIdd;
            AccountTeamMemberList.add(acmember);
        }
        return AccountTeamMemberList;
    }
    
    
    // CREATE CAMPAIGNS
    public static list<Campaign> createCampaign(integer numOfRec){
        list<Campaign> CampaignList = new list<Campaign>();
        for(integer i =0;i<numOfRec;i++){
            Campaign ev =new Campaign();
            ev.Name = 'Test';
            CampaignList.add(ev);
        }
        return CampaignList;
    }
    
     
    // CREATE TEST DRIVE 
    public static list<test_drive__c> createTestDriveRecords(integer numOfRec){
        list<test_drive__c> testDriveList = new list<test_drive__c>();
        for(integer i=0 ;i<numOfRec;i++){
            test_drive__c td = new test_drive__c();
            td.Signature__c = true;
            testDriveList.add(td);
        }
        return testDriveList;
    }
    
    // CREATE ASSETS 
    public static list<Asset> CreateAssetsRecords(List<Product2> prodList){
        
        list<Asset> assetList = new list<Asset>();
        for(Product2 prod :  prodList){
            Asset a = new Asset();
            a.name = 'Ciaz';
            a.Product2Id = prod.Id;
            assetList.add(a);
        }
        return assetList;
    }
     
    
    // CREATE OPPORTUNITY BASED ON RECORDTYPE
    public static List<Opportunity> createTestOpportunity(Integer numOfRec,String recordTypeName) {
        List<Opportunity> opportunityList = new List<Opportunity>();
        Id oppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        
        
        
        String dataList = '{"addSchemes":"{"objROfferId":"00k0k000005IDDHAA4","offersText":null,"schemeCode":"SS000000AK0319190472","cashPaymentData":92850,"financeAmountData":"450000","otherDiscountData":null,"ruralDiscountData":3500,"corporateDiscountData":null,"exchangeBonusData":0,"exchangeData":null,"OfferData":null,"otherDiscountValue":false,"ruralOffersValue":true,"exchangeValue":false,"exchangeBonusValue":false,"corporateDiscountValue":false}","registrationAmountVariant":"{"priceBookEntryId":"01u0k000003KnLzAAK","UnitPrice":"5000","Quantity":1,"opporrtunityId":"0060k000008g9I0AAI","registerId":"00k0k000005IDD7AAO"}","exShowRoomVariant":"{"priceBookEntryId":"01u0k000003KnLzAAK","UnitPrice":"537850.00","Quantity":1,"opporrtunityId":"0060k000008g9I0AAI","exShowId":"00k0k000005IDD5AAO"}","selectedColorVariant":{"Variant__r":{"Id":"01t0k0000051AVRAA2","ProductCode":"ER4CD4"},"Color_Type__c":"NM","Variant__c":"01t0k0000051AVRAA2","Color_Code__c":"26U","Name":"SUPERIOR WHITE","Id":"a070k000008D4O7AAK"},"selectedVariant":{"Loyalty_Amount__c":500,"Extended_Warranty_3_year__c":2000,"Extended_Warranty_2_year__c":1500,"Extended_Warranty_1_year__c":1000,"Name":"BALENO ALTURA M","Id":"01t0k0000051AVRAA2"},"addAccessories":"[{"priceBookEntryId":"01u0k000003KoxEAAS","unitPrice":2000,"price":4000,"Maximum_Quantity__c":5,"Minimum_Quantity__c":1,"Id":"01t0k000005R2QpAAK","quantity":"2","Name":"Car Stereo 4","accId":"00k0k000005IDD6AAO"}]","addComponent":"[{"isDisabled":true,"showLabel":false,"isExchangedWarrenty":true,"isChecked":true,"value":"1000","label":"Extended Warranty","comId":"00k0k000005IDDGAA4"},{"isDisabled":true,"showLabel":true,"isChecked":true,"value":500,"label":"Loyalty","comId":"00k0k000005IDD8AAO"},{"isDisabled":false,"showLabel":true,"isChecked":true,"value":"2500","label":"Insurance","comId":"00k0k000005IDD9AAO"},{"isDisabled":false,"showLabel":true,"isChecked":false,"value":"","label":"Municipal Charges"},{"isDisabled":false,"showLabel":true,"isChecked":false,"value":"","label":"Number Plate Charges"},{"isDisabled":false,"showLabel":true,"isChecked":false,"value":"","label":"Road Tax"},{"validityValue":"2 Yrs - 20000 KMs","packageValue":"Economy","isDisabled":false,"showLabel":true,"isMCP":true,"isChecked":true,"value":"2000","label":"MCP","comId":"00k0k000005IDDAAA4"}]","headerValue":["Customer Name : ADNAN F DANE","DMS Enquiry Number : ENQ 00012","Variant Name : BALENO ALTURA M"]}';
        
        for( Integer i = 0; i < numOfRec; i++ ) {
            
            Opportunity opp = new Opportunity(Name = 'John '+i,
                                              recordTypeId = oppRecTypeId, 
                                              CloseDate=System.today().addMonths(1),
                                              First_Name__c='John',Middle_Name__c='Brook',Last_Name__c='Wright',  
                                              Line_Item_Summary__c=dataList, 
                                              Line_Of_Business__c ='Nexa');
            opportunityList.add(opp);
        }
        
        return opportunityList;
    }
    
    
    // CREATE QUOTES
    public static List<Quote> generateQuoteData(Integer numOfRec,String opportunityId){
        
        List<Quote> quoteList = new List<Quote>();
        String dataList = '{"addSchemes":"{"objROfferId":"00k0k000005IDDHAA4","offersText":null,"schemeCode":"SS000000AK0319190472","cashPaymentData":92850,"financeAmountData":"450000","otherDiscountData":null,"ruralDiscountData":3500,"corporateDiscountData":null,"exchangeBonusData":0,"exchangeData":null,"OfferData":null,"otherDiscountValue":false,"ruralOffersValue":true,"exchangeValue":false,"exchangeBonusValue":false,"corporateDiscountValue":false}","registrationAmountVariant":"{"priceBookEntryId":"01u0k000003KnLzAAK","UnitPrice":"5000","Quantity":1,"opporrtunityId":"0060k000008g9I0AAI","registerId":"00k0k000005IDD7AAO"}","exShowRoomVariant":"{"priceBookEntryId":"01u0k000003KnLzAAK","UnitPrice":"537850.00","Quantity":1,"opporrtunityId":"0060k000008g9I0AAI","exShowId":"00k0k000005IDD5AAO"}","selectedColorVariant":{"Variant__r":{"Id":"01t0k0000051AVRAA2","ProductCode":"ER4CD4"},"Color_Type__c":"NM","Variant__c":"01t0k0000051AVRAA2","Color_Code__c":"26U","Name":"SUPERIOR WHITE","Id":"a070k000008D4O7AAK"},"selectedVariant":{"Loyalty_Amount__c":500,"Extended_Warranty_3_year__c":2000,"Extended_Warranty_2_year__c":1500,"Extended_Warranty_1_year__c":1000,"Name":"BALENO ALTURA M","Id":"01t0k0000051AVRAA2"},"addAccessories":"[{"priceBookEntryId":"01u0k000003KoxEAAS","unitPrice":2000,"price":4000,"Maximum_Quantity__c":5,"Minimum_Quantity__c":1,"Id":"01t0k000005R2QpAAK","quantity":"2","Name":"Car Stereo 4","accId":"00k0k000005IDD6AAO"}]","addComponent":"[{"isDisabled":true,"showLabel":false,"isExchangedWarrenty":true,"isChecked":true,"value":"1000","label":"Extended Warranty","comId":"00k0k000005IDDGAA4"},{"isDisabled":true,"showLabel":true,"isChecked":true,"value":500,"label":"Loyalty","comId":"00k0k000005IDD8AAO"},{"isDisabled":false,"showLabel":true,"isChecked":true,"value":"2500","label":"Insurance","comId":"00k0k000005IDD9AAO"},{"isDisabled":false,"showLabel":true,"isChecked":false,"value":"","label":"Municipal Charges"},{"isDisabled":false,"showLabel":true,"isChecked":false,"value":"","label":"Number Plate Charges"},{"isDisabled":false,"showLabel":true,"isChecked":false,"value":"","label":"Road Tax"},{"validityValue":"2 Yrs - 20000 KMs","packageValue":"Economy","isDisabled":false,"showLabel":true,"isMCP":true,"isChecked":true,"value":"2000","label":"MCP","comId":"00k0k000005IDDAAA4"}]","headerValue":["Customer Name : ADNAN F DANE","DMS Enquiry Number : ENQ 00012","Variant Name : BALENO ALTURA M"]}';
        
        for( Integer i = 0; i < numOfRec; i++ ) {
            
            Quote qu = new Quote(
                                    Name = 'John '+i,
                                    Line_Item_Summary__c=dataList,
                                    opportunityId = opportunityId
                                    );
            quoteList.add(qu);
        }
        
        return quoteList;
    }
    
    
    // MAP FIELDS ON USER RECORD - 
    public static User generateUserData(String ProfileName, string ContactId, string titleName){
        
        Profile p = [SELECT Id FROM Profile WHERE Name=:ProfileName]; 
       
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                              title = titleName, 
                              LocaleSidKey='en_US', ProfileId = p.Id,ContactId = ContactId, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com'+DateTime.now().millisecond());
            
        
        return u;
    }
    
    
   
    
    // CREATE COLOR VARIANT MASTER
    public static List<Color_Variant_Master__c> createColorVarientRealetdToProduct(Integer numOfRec, String productId) {
        List<Color_Variant_Master__c> colorList = new List<Color_Variant_Master__c>();
        
        for( Integer i = 0; i < numOfRec; i++ ) {
            
            Color_Variant_Master__c cv = new Color_Variant_Master__c(
                                    Name = 'PRL.SNOW WHITE 3 '+i,
                                    Variant__c = productId, 
                                    Color_Code__c = 'ZQM',
                                    Color_Type__c = 'M');
            colorList.add(cv);
        }
        
        return colorList;
    }
    
    
    
    // CREATE MCP MASTER
    public static List<MCP_Master__c> createMCPMaster(Integer numOfRec) {
        List<MCP_Master__c> mcpList = new List<MCP_Master__c>();
        
        for( Integer i = 0; i < numOfRec; i++ ) {
            
            MCP_Master__c mcp = new MCP_Master__c(
                                    Package_Description__c = 'Economy',
                                    Package_Validity__c = '2Yrs or 20000 KMs',
                                    From_Date__c = system.today().addDays(-1),
                                    To_Date__c = system.today().addDays(1),
                                    Fuel_Type__c = 'Petrol',
                                    Amount__c = 1200
                                    );
            mcpList.add(mcp);
        }
        
        return mcpList;
    }
    
    
    
    // CREATE PRODUCTS BASED ON RECORDTYPE
    public static List<Product2> createProducts(string recordTypeName, integer count){
    
        String productRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
    
        List<Product2> pro = new List<Product2>();
        if(count > 0){
            for(Integer i=0; i<count; i++) {
                Product2 a = new Product2(RecordTypeId= productRecordTypeId, Name='Ciaz '+i, ProductCode = 'Ciaz', Fuel_Type__c='Petrol',Channel__c='EXC',Family='Ciaz', Scheme_Code__c= 'Ciaz', Dealer_Code__c= 'EMP001', Scheme_Description__c= 'Test Drive', Minimum_Quantity__c= 1, Discount_Price__c= 120, Start_Date__c= system.today(), End_Date__c= system.today().addDays(5), Model__c= 'CIAZ', isActive= true);
                pro.add(a);
            }
            return pro;
        }
        return null;
    } 
    
    
    
    // CREATE TASKS BASED ON RECORDTYPE
    public static List<Task> createTask(Integer numOfRec, Opportunity opp, string recordtypId) {
        List<Task> taskList = new List<Task>();
        
        for( Integer i = 0; i < numOfRec; i++ ) {
            
            Task tsk = new Task(ActivityDate = system.today(),
                                IsReminderSet = True,
                                OwnerId = opp.ownerId,
                                Priority = 'Normal',
                                recordTypeId = recordtypId,
                                Status = 'Open',
                                Subject = 'Pre Booking Follow-up',
                                Type = 'Telephone',
                                WhatId = opp.Id,
                                Customer_Mobile__c = '9560128909');
            taskList.add(tsk);
        }
        
        return taskList;
    }
    
    
    // CREATE CONTENT VERSIONS
    public static list<Contentversion> createContentversion(integer numOfRec){
        list<Contentversion> Contentversionlist = new list<Contentversion>();
        for(integer i=0;i<numOfRec;i++){
            ContentVersion cv=new Contentversion();
            cv.title='ABC';
            cv.PathOnClient ='test';
            Blob b=Blob.valueOf('Unit Test Attachment Body');
            cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
            Contentversionlist.add(cv);
        }
        return Contentversionlist;
    }
    
    
    // CREATE PRICE MASTER
    public static List<Price_Master__c> createPriceMaster(Integer numOfRec, String variantCodeId, String forCodeId) {
        List<Price_Master__c> priceMasterList = new List<Price_Master__c>();
        
        for( Integer i = 0; i < numOfRec; i++ ) {
            
            Price_Master__c price = new Price_Master__c(
                                Name = 'Base Price',
                                From_Date__c = system.today().addYears(-1),
                                To_Date__c = system.today().addYears(1),
                                Amount__c =  537850,
                                Active__c = True,
                                External_ID__c = 'ER4CD4-AJ-NM',
                                Color_Type__c = 'NM',
                                Variant_Code__c = variantCodeId,
                                For_Code__c = forCodeId
                                   );
            priceMasterList.add(price);
        }
        
        return priceMasterList;
    }
    
    
    // CREATE SRUVEY TAKEN
    public static list<SurveyTaker__c> createSurveyTaken(integer numOfRec){
        list<SurveyTaker__c> surveyTakenList = new list <SurveyTaker__c>();
        
        for(integer i=0;i<numOfRec;i++){
            SurveyTaker__c sr = new SurveyTaker__c(Taken__c='test');
            surveyTakenList.add(sr);
        }
        return surveyTakenList;
    }
    
    
    // CREATE SRUVEY 
    public static list<Survey__c> createSurvey(integer numOfRec){
        list<Survey__c> sclist= new list<Survey__c>();
        for(integer i= 0 ;i<numOfRec;i++){
            Survey__c sc = new Survey__c();
            sc.Name='Test Drive Feedback';
            sclist.add(sc);
        }
        return sclist;
    }
    
    
    // CREATE SRUVEY 
    public static list<Survey__c> createSurveyPerformance(integer numOfRec,string Name){
        list<Survey__c> svPlist= new list<Survey__c>();
        for(integer i= 0 ;i<numOfRec;i++){
            Survey__c sc = new Survey__c();
            sc.Name=Name;
            svPlist.add(sc);
        }
        return svPlist;
    }
    
    
    // CREATE SRUVEY QUESTIONS
    public static list<Survey_Question__c> createSurveyQuestion(integer numOfRec){
        list<Survey__c> surveylist = new list<Survey__c>();
        surveylist = createSurvey(1);
        insert surveylist;
        list<Survey_Question__c> sclist= new list<Survey_Question__c>();
        for(integer i= 0 ;i<numOfRec;i++){
            Survey_Question__c sc = new Survey_Question__c();
            sc.Name = 'test';
            sc.Type__c = 'Single Select--Vertical';
            sc.OrderNumber__c = 1;
            sc.Question__c ='How was your experience of Test Drive';
            sc.survey__c = surveylist[0].id;
            sclist.add(sc);
        }
        return sclist;
    }
    
    
    // CREATE SRUVEY QUESTIONS RESPONSE
    public static list<SurveyQuestionResponse__c> createSurveyQuestionAnswer(integer numOfRec){
        list<Survey_Question__c> sqlist = new list<Survey_Question__c>();
        list<SurveyTaker__c> surveyTakenList = new list <SurveyTaker__c>();
        surveyTakenList = createSurveyTaken(1);
        sqlist = createSurveyQuestion(1);
        insert surveyTakenList;
        insert sqlist;
        list<SurveyQuestionResponse__c> sclist= new list<SurveyQuestionResponse__c>();
        for(integer i= 0 ;i<numOfRec;i++){
            SurveyQuestionResponse__c sc = new SurveyQuestionResponse__c();
            sc.Remarks__c = 'test';
            sc.Date_Expected__c = System.today();
            sc.Response__c = 'No';
            sc.Survey_Question__c = sqlist[0].id;
            sc.SurveyTaker__c = surveyTakenList[0].id;
        }
        return sclist;
    }
    
    // CREATE PRICEBOOKENTRY
    public static List<PricebookEntry> createPricebookEntry(Integer numOfRec, String productId) {
        List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();
        
        for( Integer i = 0; i < numOfRec; i++ ) {
            
            PricebookEntry priceEntry = new PricebookEntry( 
                                                unitprice = 1, 
                                                Product2Id = productId,
                                                Pricebook2Id = Test.getStandardPricebookId(),
                                                isActive = true,
                                                UseStandardPrice = false);
            pricebookEntryList.add(priceEntry);
        }
        
        return pricebookEntryList;
    }
    
    
    // CREATE OPPORTUNITY LINE ITEMS
    public static List<OpportunityLineItem> createOpportunityLineItem(Integer numOfRec, String opportunityId, String priceBookEntryId) {
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        
        for( Integer i = 0; i < numOfRec; i++ ) {
            
            OpportunityLineItem oli = new OpportunityLineItem( 
                                                quantity = 1, 
                                                UnitPrice = 1,
                                                priceBookEntryId = priceBookEntryId,
                                                opportunityId = opportunityId
                                                );
            oliList.add(oli);
        }
        
        return oliList;
    }
    
    // CREATE CITY MASTER ADDRESS DATA  
    public static list<City__c> createCityAddressMasterData(Integer numOfRec){
        list<city__c> cityList = new list<city__c>();
        for(integer i=0;i<numOfRec;i++){
            City__c c = new City__c();
            c.City_Code__c = '1234';
            c.Name='Noida';
            cityList.add(c);
        }
        return cityList;
    }
    
    // CREATE PINCODE MASTER ADDRESS DATA  
    public static list<Pincode__c> createPinAddressMasterData(Integer numOfRec){
        list<Pincode__c> pinList = new list<Pincode__c>();
        for(integer i=0;i<numOfRec;i++){
            Pincode__c p = new Pincode__c();
            p.Name='Noida';
            pinList.add(p);
        }
        return pinList;
    }
    
    // CREATE QUOTE LINE ITEMS
    public static List<QuoteLineItem> createQuoteLineItem(Integer numOfRec, String quoteId, String priceBookEntryId) {
        List<QuoteLineItem> oliList = new List<QuoteLineItem>();
        
        for( Integer i = 0; i < numOfRec; i++ ) {
            
            QuoteLineItem oli = new QuoteLineItem( 
                                                quantity = 1, 
                                                UnitPrice = 1,
                                                priceBookEntryId = priceBookEntryId,
                                                quoteId = quoteId
                                                );
            oliList.add(oli);
        }
        
        return oliList;
    }
    
    
    // CREATE CORPORATE OBJECT RECORDS
    public static List<Corporate__c> createCorporate(Integer numOfRec) {
        
        List<Corporate__c> corList = new List<Corporate__c>();
        
         for( Integer i = 0; i < numOfRec; i++ ) {
            Corporate__c cor = new Corporate__c();
            cor.Corporate_Code__c = '120'+i;
            
            corList.add(cor);
        }
        return corList;
    }
    
    
    // CREATE SCHEME MASTER
    public static List<Scheme_Master__c> createSchemeMaster(Integer numOfRec, String recordTypeName) {
        
        string recordTypeId = Schema.SObjectType.Scheme_Master__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        List<Scheme_Master__c> smList = new List<Scheme_Master__c>();
        
         for( Integer i = 0; i < numOfRec; i++ ) {
            Scheme_Master__c sm = new Scheme_Master__c();
            sm.recordTypeId = recordTypeId;
            sm.Discount_Amount__c = 1200;
            sm.Active__c = true;
            sm.status__c = 'A';
            sm.From_Date__c = system.today().addDays(-1);
            sm.To_Date__c = system.today().addDays(1);
            
            smList.add(sm);
        }
        return smList;
    }
    
    
    // CREATE OTHER AMOUNT VALIDATION CUSTOM SETTING
    public static OtherAmountValidation__c createQuoteAmountValidation(Integer Amount) {
        OtherAmountValidation__c oAmount = new OtherAmountValidation__c();
        oAmount.Offer_Discount_Amount__c = Amount;
        oAmount.Accessories_Discount_Amount__c = Amount;
        
        return oAmount;
    }
    
    
    // CREATE CUSTOMER PROFILE
    public static list<Customer_Profile__c> createCustomerProfile(Integer num){
        list<Customer_Profile__c> customerProfileList = new list<Customer_Profile__c>();
        for(integer i = 0 ;i< num ;i++){
            Customer_Profile__c cp = new Customer_Profile__c();
            cp.Preferred_Social_Media__c = 'Facebook';
            cp.Preferred_Video_Content__c = 'Youtube';
            cp.Avg_spend_on_e_commerce_websites_a_month__c = 'Less than 5k';
            cp.Facebook_Handle__c = 'Raj';
            cp.Insta_Handle__c = 'Raj Rockerz';
            cp.Twitter_Handle__c = 'test';
            cp.Degree_of_preference_for_Maruti_car__c = 'High';
            cp.Maruti_service_is_value_for_money__c = 'Yes';
            cp.Preference_for_MGA_or_non_MGA__c= 'MGA';
            cp.Maruti_Insurance_better_than_competition__c = 'Yes';
            cp.Did_you_even_buy_a_Non_Maruti_Insurance__c ='Yes';
            cp.Reason_s_for_churn_out_from_Maruti__c ='Service';
            cp.Personal_Annual_Income_in_Lacs__c = '5 - 10';
            cp.PIN__c = 110086;
            cp.Languages_Known__c = 'HINDI, ENGLISH';
            cp.Year_of_1st_job_after_graduation_YYYY__c = 2017;
            cp.Graduation_year_of_the_individual_YYYY__c = 2008;
            cp.Auto_Journals__c = 'Good';
            cp.Degree_Of__c='Features';
            cp.Parking_Space_at__c = 4;
            cp.Purpose_Of_Vehicle__c ='Long Distance';
            cp.Age_Of_Two_Wheeler_Owned__c = 2;
            cp.Models_Enquired_From_Competitors__c = 'very bad';
            cp.Number_Of_Two_Wheelers_Owned__c = 2;
            cp.Who_drives_the_car__c = 'driver';
            cp.Distance_Of_Home_From_Office_In_Kms__c = 2;
            cp.Average_Household_Savings__c = 'Less than 5';
            cp.Number_Of_Children__c = 2;
            cp.Did_You_Become_A_Parent_In_Last_1_Year__c= 'Yes';
            cp.Date_Of_Birth_Of_Child_1__c = date.valueof(System.today());
            cp.Date_Of_Birth_Of_Child_2__c = date.valueof(System.today());
            cp.Parents_Marriage_Anniversary__c = date.valueOf(System.today());
            cp.Type_Of_Two_Wheeler_Owned__c = 'Bike';
            cp.Has_Anyone_In_The_Family_Of_The_Individu__c= 'Yes';
            cp.Number_Of_Dependents__c =2;
            customerProfileList.add(cp);
        }
        return customerProfileList;
    }
    
    
    // CREATE ENQUIRY ESCALATIONS CUSTOM SETTING
    public static list<Enquiry_Escalations__c> CreateEnqEscalation(String Leadsource,String Dealership,
                                                                   String EscalationType,list<String> notifersList
                                                                  ,list<integer> timeList){
        list<Enquiry_Escalations__c> esclist = new list<Enquiry_Escalations__c>();
        for(integer i =1 ; i<=4; i++){
            Enquiry_Escalations__c esc13= new Enquiry_Escalations__c();
            esc13.Source__c = Leadsource;
            esc13.Name = Dealership+' Level '+i;
            esc13.Type_of_Escalation__c = EscalationType;
            esc13.Level_of_Escalation__c='Level '+i;
            esc13.Time_to_Escalation__c = timeList[i];
            esc13.Notifiers__c =notifersList[i];
            esclist.add(esc13);
            
        }
        return esclist;
    }
    
    
   //CREATE CITY MASTR
   public static List<City__c> createAddressMasterData(Integer count, String obj){
       
       List<City__c> cityList = new list<City__c>();
       for(Integer i=0;i<count;i++){
           City__c cityObj = new City__c();
           cityObj.Name = 'Noida';
           cityObj.City_Code__c = 'ND';
           cityObj.State__c = 'UP';
           cityObj.Region__c = 'N1';
           cityList.add(cityObj);
       }
       return cityList;
   }
    // CREATE SMS URL
    public static List<SMS_URL__c> createSMSURL(Integer smsURLCount)
    {
        List<SMS_URL__c> smsURLList=new List<SMS_URL__c>();
        for(Integer i=0;i<smsURLCount;i++)
        {
            SMS_URL__c sms=new SMS_URL__c();
            sms.Redirect_URL__c='www.salesforce.com';
            sms.Expiry_Date__c=System.today()+1;
            sms.Mobile__c='90909090';
            smsURLList.add(sms);
        }
        return smsURLList;
    }
    
    
    // CREATE CUSTOM VALIDATION EXCEPTION SETTING
     public static Custom_Validation_Exception_Setting__c createCustomValidation(Boolean isInsert){
        Custom_Validation_Exception_Setting__c valid = new Custom_Validation_Exception_Setting__c();
            valid.Name = 'Bypass';
            valid.Bypass_Validation_Rules__c=true;
        If(isInsert){
            insert valid;
            return valid;
        }
        else{
            return valid;
        }
    }
   
   
    // CREATE PRODUCT RECORDS
    public static List<Product2> createProduct2(Integer num)
    {
         List<Product2> productList=new List<Product2>();
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        // Run an update DML on the Pricebook2 record
        // This is the weird workaround that enables IsStandard to become true
        // on the PricebookEntry record
        update standardPricebook;
        
        // Re-Query for the Pricebook2 record, for debugging
        standardPricebook = [SELECT IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        
        // This should return true now
        system.assertEquals(true, standardPricebook.IsStandard, 'The Standard Pricebook should now return IsStandard = true');
        
        // Create the Product
        for(Integer i=0;i<num;i++)
        {
        Product2 testProduct = new Product2();
        testProduct.Name = 'Test Product';
        testProduct.IsActive = true;
        testProduct.Channel__c='EXC';
        testProduct.Fuel_Type__c='Petrol';
        testProduct.Start_Date__c=System.today();
        testProduct.End_Date__c=System.today()+2;
        testProduct.Model__c='test';
        productList.add(testProduct);
        }
        return productList;
        
    }
    
    
    // CREATE PRICEBOOKENTRY
    public static list<PriceBookEntry> createPriceBookEntryList(integer totalNum,string productId){
        list<PriceBookEntry> PriceEntryList = new List<PriceBookEntry>();
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        
        //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id]; 
        
        
        //Create the PricebookEntry
        for(integer i=0; i< totalNum;i++){
            PricebookEntry pbe = new PricebookEntry(
                Pricebook2Id = standardPricebook.Id,
                Product2Id = productId,
                UnitPrice = 1020,
                IsActive = true
            );  
           PriceEntryList.add(pbe); 
        }
       
        return PriceEntryList;
    }
    
    
    // CREATE MC COMMUNICATION
    public static list<MC_Communication__c> createMCCommData(integer totalNum, Id enquiryId){
        list<MC_Communication__c> mcList = new list<MC_Communication__c>();
        
        for(integer i=0; i< totalNum;i++){
            MC_Communication__c mc = new MC_Communication__c();
            mc.Type__c = 'Escalation';
            mc.Escalation_Date_Time__c = DateTime.newInstance(2019, 11, 15, 11, 25, 33);
            mc.General_Field_1__c = 'DSE Allocation Time';
            mc.Enquiry_MD__c = enquiryId;
            mcList.add(mc);
        }
        
        
        return mcList;
    }

    //CREATE PUBLIC GROUP
    public static List<GROUP> createPublicGroup(integer totalNum){
      List<Group> lstGroup=new List<Group>();
      String sGroupNameToken='Grp';
     for(integer i=0; i< totalNum;i++){
            Group grpVar=new Group(Type='Regular');
            grpVar.DeveloperName=sGroupNameToken+i;
            grpVar.Name=sGroupNameToken+i;
            lstGroup.add(grpVar);

        }  
     return lstGroup;
    }
    
    //CREATE CUSTOMER VISIBILITY RECORD FOR GROUP
    public static List<Customer_visibility__c> createCustomerVisibilityRecordsForGroup(integer totalNum,List<Account> lstCustomerAccount){
      List<Customer_visibility__c> lstCV=new List<Customer_visibility__c>();
      String sGroupNameToken='Grp';
      String sInteruserDMSUsernameToken='usr';
     for(integer i=0; i< totalNum;i++){
         for(Account accVar: lstCustomerAccount){
           Customer_visibility__c cvVar=new Customer_visibility__c();
           cvVar.Access_Processing_Status__c='Pending';
           cvVar.Customer_Account__c=accVar.Id;
           cvVar.Dealer_Public_Group_Name__c=sGroupNameToken+i;
           cvVar.End_Datetime__c=System.now().addDays(-2);
          // cvVar.MSIL_User_ID__c=
           cvVar.Start_Datetime__c=System.now();
           lstCV.add(cvVar);
         } 
        }  
     return lstCV;
    }
    //CREATE CUSTOMER VISIBILITY RECORD FOR GROUP
    public static List<Customer_visibility__c> createCustomerVisibilityRecordsForUser(integer totalNum,List<Account> lstCustomerAccount){
      List<Customer_visibility__c> lstCV=new List<Customer_visibility__c>();
     
      String sInteruserDMSUsernameToken='usr';
     for(integer i=0; i< totalNum;i++){
         for(Account accVar: lstCustomerAccount){
           Customer_visibility__c cvVar=new Customer_visibility__c();
           cvVar.Access_Processing_Status__c='Pending';
           cvVar.Customer_Account__c=accVar.Id;
           cvVar.MSIL_User_ID__c=sInteruserDMSUsernameToken+i;
           cvVar.End_Datetime__c=System.now().addDays(-2);
         
           cvVar.Start_Datetime__c=System.now();
           lstCV.add(cvVar);
         } 
        }  
     return lstCV;
    }
    //CREATE DEALER ACCOUNT
    public static List<Account> createDealerAccount(integer totalNum) {
        List<Account> lstAccount=new List<Account>();
        String sGroupNameToken='Grp';
        Id rectypeId=[select Id from Recordtype where DeveloperName='Dealer'].Id;
        for(integer i=0; i< totalNum;i++){
            Account accVar=new Account();
            accVar.Name='test'+i;
            accVar.recordTypeId=rectypeId;
            accVar.Parent_Group__c=sGroupNameToken+i;
            lstAccount.add(accVar);

        }
        return lstAccount;
    }
    //CREATE DEALER CONTACT
    public static List<Contact> createDealerContact(integer totalNum,List<Account> lstAccount ){
        List<Contact> lstContact=new List<Contact>();
       
        for(Account accVar:lstAccount){
            for(integer i=0; i< totalNum;i++){
                Contact conVar=new Contact();
                conVar.FirstName='test';
                conVar.LastName='test'+i;
                conVar.accountId=accVar.Id;
                
                lstContact.add(conVar);

            }
        }
        return lstContact;
    }
}