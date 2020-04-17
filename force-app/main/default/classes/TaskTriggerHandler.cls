/**
* @Autho:- Nishant Prajapati
* @Company-: Techmatrix Consulting
* @Description-: APEX Trigger Handler class of TaskTrigger
* =============================================================
* Version   Date            Author      Modification
* =============================================================
* 1.0       23 Sept 2019    Nishant     Intial Version
**/
public class TaskTriggerHandler extends TriggerHandler{
    
    private list<Task> taskItems;
    public TaskTriggerHandler() {
        this.taskItems= (list<Task>) Trigger.new;
    }
    
    public override void beforeDelete(){
        restrictUser2DelTask(this.taskItems);
    }
    
    public override void afterInsert(){
        captureClosedGeneralTaskDetailOnEnquiry(this.taskItems);
        SendBrochure(this.taskItems);
    }
    
    public override void afterUpdate(){
        captureClosedGeneralTaskDetailOnEnquiry(this.taskItems);
    }
    public override void beforeInsert(){
        validateLoanAppliedEnquiry(this.taskItems);
    }
    
    /**
    @Author:                  Nishant Prajapati
    @Created Date :           23/09/2019
    @Discription:             Restrict users to delete task from UI, other than System Admin and Integration Users.
    @Date Of Modification :   23/09/2019
    */
    public static void restrictUser2DelTask(List<Task> tasks){
        
        List<User> currentUser= [Select Id, Profile.Name from User where Id=: UserInfo.getUserId()];
        if(currentUser.size() > 0){
            Boolean isAdminOrIntegrationUser= (currentUser[0].Profile.Name == ConstantsUtility.PROFILE_SYSTEM_ADMIN ||  currentUser[0].Profile.Name == ConstantsUtility.PROFILE_INTEGRATION_USER) ? true : false;
            if(isAdminOrIntegrationUser == false){
                for(Task item : tasks){
                    item.addError('You can only cancel or update this Task, Deletion is not allowed');
                }
            }
        }
        
    }
    
    
    /**
    @Author:                  Anuj Kumar
    @Created Date :           25/10/2019
    @Discription:             Hold Details of closed, General Follow Up RecordType Task at Enquiry level and used this to show in Closed FollowUp.
    @Date Of Modification :   25/10/2019
    */
    public static void captureClosedGeneralTaskDetailOnEnquiry(List<Task> tasks){
        
        List<Task> closedGeneralTask = new List<Task>();
        
        Map<String, User> userIdWithObjMap = new Map<String, User>();
        Map<String, Opportunity> opportunityIdWithObjMap = new Map<String, Opportunity>();
        Map<String, List<ClosedFollowUps_JSON_STRUCTURE>> enquiryWithClosedGeneralTaskInfoMap = new Map<String, List<ClosedFollowUps_JSON_STRUCTURE>>();
        
        
        for(Task tsk : tasks){
            string taskRecordTypeName  = tsk.recordTypeId != Null ? Schema.sobjectType.Task.getRecordTypeInfosById().get(tsk.recordTypeId).getName() : Null;
            
            if(tsk.recordTypeId != Null && taskRecordTypeName != Null && 
               tsk.Status == ConstantsUtility.STATUS_COMPLETED &&
               taskRecordTypeName == ConstantsUtility.GENERAL_FOLLOW_UP_TASK_REC_TYPE &&
               String.valueOf(tsk.whatId).startsWith(ConstantsUtility.OPPORTUNITY_KEY_PREFIX)){
                   
                   closedGeneralTask.add(tsk);
                   userIdWithObjMap.put(tsk.OwnerId, new User());
                   opportunityIdWithObjMap.put(tsk.whatId, new Opportunity());
               }
        }
        
        if(opportunityIdWithObjMap != Null && opportunityIdWithObjMap.size() > 0){
            
            opportunityIdWithObjMap = new Map<String, Opportunity>([Select Id, Name, Closed_General_FollowUp_Details__c, 
                                                                    DMS_Enquiry_Name__c, StageName
                                                                    From Opportunity 
                                                                    Where Id IN: opportunityIdWithObjMap.keySet()]);        
        }
        
        if(userIdWithObjMap != Null  && userIdWithObjMap.size() > 0){
            
            userIdWithObjMap = new Map<String, User>([Select Id, Name from User Where Id IN: userIdWithObjMap.keySet()]);
            
        }
        
        for(Task tsk : closedGeneralTask){
            
            Opportunity opp = opportunityIdWithObjMap.containsKey(tsk.whatId) ? opportunityIdWithObjMap.get(tsk.whatId) : new Opportunity();
            
            User usr = userIdWithObjMap.containsKey(tsk.OwnerId) ? userIdWithObjMap.get(tsk.OwnerId) : new User();
            
            List<ClosedFollowUps_JSON_STRUCTURE> existingFollowUpDetails = new List<ClosedFollowUps_JSON_STRUCTURE>();
            ClosedFollowUps_JSON_STRUCTURE general = generateFollowUpData(tsk, opp, usr);
            
            if(!enquiryWithClosedGeneralTaskInfoMap.containsKey(tsk.whatId)){
                enquiryWithClosedGeneralTaskInfoMap.put(tsk.whatId, existingFollowUpDetails);
            }
            enquiryWithClosedGeneralTaskInfoMap.get(tsk.whatId).add(general);
            
        }
        
        
        List<Opportunity> opportunityList = new List<Opportunity>();
        
        if(enquiryWithClosedGeneralTaskInfoMap != Null && enquiryWithClosedGeneralTaskInfoMap.size() > 0){
            
            for(String enquiryId : enquiryWithClosedGeneralTaskInfoMap.keySet()){
                
                Opportunity opp = opportunityIdWithObjMap.containsKey(enquiryId) ? opportunityIdWithObjMap.get(enquiryId) : new Opportunity();
                opp.Id = enquiryId;
                
                String data = JSON.serialize(enquiryWithClosedGeneralTaskInfoMap.get(enquiryId)).contains('&quot;') ? 
                    JSON.serialize(enquiryWithClosedGeneralTaskInfoMap.get(enquiryId)).replace('&quot;', '"') : 
                JSON.serialize(enquiryWithClosedGeneralTaskInfoMap.get(enquiryId));
                
                opp.Closed_General_FollowUp_Details__c = (opp.Closed_General_FollowUp_Details__c != Null &&
                                                          opp.Closed_General_FollowUp_Details__c != '' ) ? 
                    opp.Closed_General_FollowUp_Details__c + data :
                data;
                
                if(opp.Closed_General_FollowUp_Details__c.contains('][')){
                    opp.Closed_General_FollowUp_Details__c =  opp.Closed_General_FollowUp_Details__c.replace('][', ',');
                }
                
                opportunityList.add(opp);
            }
            
        }
        
        system.debug('== opportunityList '+opportunityList);
        try{
            DataBase.update(opportunityList, false);
        }catch(Exception ex){
            ExceptionHandler.stackTrace ehst = new ExceptionHandler.stackTrace(); 
            ehst.componentName = 'Task Trigger'; ehst.userId=UserInfo.getUserId(); 
            ExceptionHandler.LogError('Task Trigger', ex.getMessage(), 'Task Trigger', '', ehst);
        }
        
        
    }
    
    
    Public Static ClosedFollowUps_JSON_STRUCTURE generateFollowUpData(Task tsk, Opportunity opp, User usr){
        
        ClosedFollowUps_JSON_STRUCTURE general = new ClosedFollowUps_JSON_STRUCTURE();
        general.Remarks = tsk.Description != Null ? tsk.Description : '';
        general.EnquiryNumber = opp.DMS_Enquiry_Name__c != Null ? opp.DMS_Enquiry_Name__c : '';
        general.ReminderDatetime = tsk.ReminderDateTime != Null ? String.valueOf(tsk.ReminderDateTime) : '';
        general.DueDate = tsk.ActivityDate != Null ? string.valueOf(tsk.ActivityDate) : '';
        general.EnquiryStage = opp.StageName != Null ? opp.StageName : '';
        general.Type = ConstantsUtility.GENERAL_FOLLOW_UP_TASK_REC_TYPE;
        general.FollowupStatus = ConstantsUtility.STATUS_COMPLETED;
        general.AssignedTo = usr.Name != Null ? usr.Name : '';
        
        
        return general;
        
    }
    
    
    
    /**
    @Author:                  Nishant Prajapati
    @Created Date :           08/11/2019
    @Discription:             Bank Appointment cannot be created if Loan Applied on Enquiry is not selected.
    */
    public static void validateLoanAppliedEnquiry(List<Task> tasks){
        Id bankAppointmentRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get(ConstantsUtility.BANK_APPOINTMENT).getRecordTypeId();
        List<Task> tasklList = new List<Task>();
        Set<Id> enquiryIdSet = new Set<Id>();
        
        for(Task tsk : tasks){
            if(tsk.whatId != Null && String.valueOf((tsk.whatId).getSobjectType()) == ConstantsUtility.OPPORTUNITY){
                enquiryIdSet.add(tsk.whatId);
                tasklList.add(tsk);
            }
        }
        
        if(enquiryIdSet.size() > 0){
            
            Map<Id, Opportunity> enquiryMap = new Map<Id, Opportunity>(
                [Select id, Loan_Applied__c,Mobile__c, Customer__c, Customer__r.PersonContactId from Opportunity Where Id IN : enquiryIdSet]);
            
            for(Task tsk : tasklList){
                Opportunity opp = enquiryMap.containsKey(tsk.whatId) ? enquiryMap.get(tsk.whatId) : new Opportunity();
                
                if(tsk.recordtypeId == bankAppointmentRecordTypeId && opp.Customer__c != Null && opp.Customer__r.PersonContactId != Null){
                    tsk.whoId = opp.Customer__r.PersonContactId;
                }
                
                if(tsk.recordtypeId == bankAppointmentRecordTypeId && opp.Loan_Applied__c == false){
                    tsk.addError(System.Label.Bank_Appointment_Task_Error_Message);
                }
            }
        }
    }
    
    /**
    @Author:                  Prabhat Sharma
    @Created Date :           08/11/2019
    @Discription:             Brouchure Request task to create MC Communication records
    */
    public static void SendBrochure(List<Task> tasks){
        Id recordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get(ConstantsUtility.SEND_BROCHURE).getRecordTypeId();
        Set<Id> enquiryIdSet = new Set<Id>();
        map<Id,String> taskModelmap = new map<Id,String>();
        map<String,Task> taskPhonemap = new map<String,Task>();
        for(Task tsk : tasks){
            if(tsk.WhatId !=null && tsk.RecordTypeId == recordTypeId && String.ValueOf((tsk.WhatId).getSobjectType())==ConstantsUtility.OPPORTUNITY){
                enquiryIdSet.add(tsk.whatId);
                taskModelmap.put(tsk.whatId,tsk.Model__c);
                taskPhonemap.put(tsk.whatId,tsk);
            }
        } 
         
        if(enquiryIdSet.size()>0){
            OpportunityTriggerHelper.esclationLevels=taskModelmap;
            OpportunityTriggerHelper.sendBrochurePhone=taskPhonemap;
            GenerateFilePublicURL.CreateMCRecord(ConstantsUtility.SEND_BROCHURE_METADATA,enquiryIdSet,ConstantsUtility.OPPORTUNITY,'');
        }
    }
}