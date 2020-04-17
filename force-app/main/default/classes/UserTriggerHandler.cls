/**
* @Autho:- Nishant Prajapati
* @Company-: Techmatrix Consulting
* @Description-: Handler class for User Trigger.
* =============================================================
* Version   Date            Author      Modification
* =============================================================
* 1.0       01 Oct 2019    Nishant     Intial Version
* 1.1       01 Dec 2019    Subhojit    Added logic to add external user to related public group
**/
public without sharing class UserTriggerHandler extends TriggerHandler{
    
    private list<User> newUserList; // Used to store the list of new User
    private Map<Id, User> oldUserMap; // Used to store Map of old User
    public UserTriggerHandler() {
        this.newUserList= (list<User>) Trigger.new;
        this.oldUserMap= (Map<Id, User>) Trigger.oldMap;
    }
    
    public override void beforeInsert() {
    
        check4ProfileUpdate();
        ChecKMobileNumber();
    }
    
    public override void beforeUpdate() {
        check4ProfileUpdate();
        ChecKMobileNumber();
        checkForDMSActive();
    }
    
    public override void afterInsert() {
    /*AU-IM016110824 Changed the sequence for Error:Group member operation already in progress */
        if(!Test.isRunningTest())              
             addUserToDealerMasterPublicGroup();
             
        callScheduleApexJob();
        setPasswordForPartnerUsers();
       
     
    }
    
    public override void afterUpdate() {
        callScheduleApexJob();
        setPasswordForPartnerUsers();
    }
    
    /**
        Author: Nishant Prajapati
        Company: Techmatrix
        Description: record is being inserted or user profile field is being updated, update the profile change flag and capture the old profile.
        Inputs: 
        Returns: void
        History:
        ====================================================
        1.0     01 Oct 2019  Nishant  Initial Version
        
    **/
    public void check4ProfileUpdate(){
        
        Map<Id, string> userProfileMap= new Map<Id, string>();
        Map<Id, Profile> ProfileMap= new Map<Id, Profile>();
        
        // Commented as part of the issue fix where users are not getting added to the public group. On 20/Feb/2020 By Anuj.
        
        //check if any scheduled job already exist before updating user profile update flag
        //Integer jobInfo= [SELECT count() FROM AsyncApexJob WHERE  ApexClass.Name= 'MapProfileToGroupBatchScheduler' AND JobType= 'ScheduledApex' AND Status IN: System.Label.Batch_APEX_Status.split(',')];
        
      // if(jobInfo == 0){
            if(trigger.isUpdate){
                for(User ur : newUserList){
                    if(ur.profileId <> oldUserMap.get(ur.Id).profileId){
                        userProfileMap.put(ur.id, oldUserMap.get(ur.Id).profileId);
                    }
                }
                
                if(userProfileMap.size() > 0){
                    ProfileMap= new Map<Id, Profile>([SELECT Id, Name FROM Profile WHERE Id IN: userProfileMap.values()]);
                }
            }
            
            for(User ur : newUserList){
                Boolean isUpdatedProfile= trigger.isUpdate && ur.profileId <> oldUserMap.get(ur.Id).profileId;
                if(trigger.isInsert || isUpdatedProfile){
                    ur.Profile_Updated__c= true;
                    if(isUpdatedProfile && userProfileMap.containskey(ur.Id) && String.isBlank(ur.Previous_Profile_Name__c)){
                        ur.Previous_Profile_Name__c= ProfileMap.get(userProfileMap.get(ur.Id)).Name;
                    }
                    
                }
            }
      //  }
    }
    
   public  void callScheduleApexJob(){
        boolean callScehdular= false;
        boolean callScehdular1= false;
        Profile p = [Select Id from Profile where Name =: 'Dealer TV Evaluator'];
        for(User ur : newUserList){
            if(ur.ProfileId ==  p.Id && (ur.IsActive == true || ur.DMS_Active__c == false)){
                callScehdular1= true;
                break;
            }
        }
        for(User ur : newUserList){
            if(ur.Profile_Updated__c){
                callScehdular= true;
                break;
            }
        }
        if(callScehdular){
            Schedule_Apex_Job_Time__c mc = Schedule_Apex_Job_Time__c.getOrgDefaults();
            
            /*
            *  Comment : Logic added to add the bulk user records to public groups.
            *  Added By : Anuj 
            *  Date : 20/feb/2020
            */
            
             /*
            *  Comment : logic added to run schedule for 20 mins from start of user creation
            *  Added By : Rahul Sharma - MSIL
            *  Date : 21/mar/2020
            */
            //check if any scheduled job already exist before updating user profile update flag
            Integer jobInfo= [SELECT count() FROM AsyncApexJob WHERE  ApexClass.Name= 'MapProfileToGroupBatchScheduler' AND JobType= 'ScheduledApex' AND Status IN: System.Label.Batch_APEX_Status.split(',')];
            if(jobInfo == 0){
            DateTime currentInstance = System.Now().addMinutes(20);
        
                //Construct the Cron String
                String crn = '00 '+ currentInstance.minute()+' '+ currentInstance.hour()+' '+currentInstance.day()+' '+currentInstance.Month()+' ? '+currentInstance.year();
                
                MapProfileToGroupBatchScheduler sch = new MapProfileToGroupBatchScheduler();
                //schedule job for 20 mins from now
                system.schedule('MapProfileToGroupBatchScheduler'+string.valueof(currentInstance)+':'+string.valueof(currentInstance.millisecond()),crn,sch);
               // ScheduleApexJob.findBatchApex(ConstantsUtility.ASYNC_APEX_BATCH, 'MapProfileToGroupBatchScheduler',Integer.valueof(mc.Time_in_minutes__c));
                TriggerHandler.bypass('UserTriggerHandler');
                TriggerHandler.clearBypass('UserTriggerHandler');
            }
        }
        if(callScehdular1){
            Schedule_Apex_Job_Time__c mc = Schedule_Apex_Job_Time__c.getOrgDefaults();
            ScheduleApexJob.findBatchApex(ConstantsUtility.ASYNC_APEX_BATCH1, 'inActiveTVEvaluatorSchedule',Integer.valueof(mc.Time_in_minutes__c));
            TriggerHandler.bypass('UserTriggerHandler');
            TriggerHandler.clearBypass('UserTriggerHandler');
        }
     }
    
    
    /**
        Author: Nishant Prajapati
        Company: Techmatrix
        Description: Method to append 91 in user's mobile phone
        Returns: void
        History:
        ====================================================
        1.0     01 Oct 2019  Nishant  Initial Version
        
    **/
    public void ChecKMobileNumber(){
        for(user u: this.newUserList){

            if(u.Phone != null && u.MobilePhone == null){
                u.MobilePhone = u.Phone;
            }
                        
            if((trigger.isInsert && (u.MobilePhone != null && u.MobilePhone.length()==10)) || (trigger.isUpdate && (u.MobilePhone != null && u.MobilePhone != this.oldUserMap.get(u.Id).MobilePhone &&
                                                                                                                      u.MobilePhone.length()==10)))
                u.MobilePhone = ConstantsUtility.COUNTRY_CODE+ u.MobilePhone;
        }
    }
    
    
    /**
        Author: Nishant Prajapati
        Company: Techmatrix
        Description: Method to set partner user's password
        Returns: void
        History:
        ====================================================
        1.0     03 Dec  Nishant  Initial Version
        
    **/
    public void setPasswordForPartnerUsers(){
        try{
            //Set to store the User Ids for which password needs to be reset
            set<Id> userIds = new set<Id>();

            //number to track number of users being created or updated in this trigger transaction
            Integer i = 0;
            for(user u: this.newUserList){
                if(u.ContactId!=null && u.IsActive && (trigger.isInsert || (trigger.IsUpdate && !oldUserMap.get(u.Id).IsActive && u.IsActive))){
                     i++;
                    
                    if (i < 50){
                        //Add the users to the userIds list if the list size is less than 50
                         userIds.add(u.Id);
                    }else{
                        //ENque the job for the users and then reset the users.
                         userIds.add(u.Id);
                         //System.enqueueJob(new PasswordService(userIds));
                         scheduleSetPassword(userIds);
                         i = 0;
                         userIds.clear();
                    }
                }
            }


            //schedule the job if any pending users are present.
            if(userIds.size() > 0){
                //System.enqueueJob(new PasswordService(userIds));
                scheduleSetPassword(userIds);
                i = 0;

            }

        }catch(Exception e){ 
           ExceptionHandler.LogError_Future('UserTriggerHandler SetPassword', e.getStackTraceString()+e.getMessage(),'User', '', null);
        }
    }
     /**
        Author: Subhojit Chakraborty
        Company: Salesforce
        Description: Method to add external users to oublic group
        Returns: void
        History:
        ====================================================
        1.0     01 Ded 2019  Nishant  Initial Version
        
    **/
    public void addUserToDealerMasterPublicGroup(){
        CustomerRecordVisibilityUtility.addUserToParentPublicGroup(newUserList);
    }    

     /**
        Author: Rahul Raghunathan
        Company: Salesforce
        Description: Method to schedule the password service for every half an hour
        Returns: void
        History:
        ====================================================
        1.0     28 Jan 2020  Rahul  Initial Version
        
    **/
    public void scheduleSetPassword(set<id> userIds){
        // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        
        DateTime currentInstance = System.Now().addMinutes(30);
        
        //Construct the Cron String
        String sch = '00 '+ currentInstance.minute()+' '+ currentInstance.hour()+' '+currentInstance.day()+' '+currentInstance.Month()+' ? '+currentInstance.year();
        
        //schedule job for 30 mins from now
        system.schedule('PasswordService'+string.valueof(currentInstance)+':'+string.valueof(currentInstance.millisecond()),sch,new PasswordService(userIds));

    }
    
    /**
        Author: Rahul Sharma
        Company: MSIL
        Description: method to check if user active in DMS or not , specially for evaluator
        Returns: void
          
    **/
     public void checkForDMSActive(){
       Profile p = [Select Id from Profile where Name =: 'Dealer TV Evaluator'];  
      for(User ur : newUserList){
              if(ur.ProfileId ==p.Id || oldUserMap.get(ur.Id).IsActive != ur.IsActive)
                ur.DMS_Active__c = ur.IsActive;
            }
        }
    
    
}