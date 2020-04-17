/**
* @File Name          : MCCommunicationTriggerHandler.cls
* @Description        : Trigger handler class for MC COmmunication
* @Author             : 
* @Group              : 
* @Last Modified By   : Rajesh Ramachandran
* @Last Modified On   : 1/10/2020, 1:55:22 AM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author                 Modification
*==============================================================================
* 1.0    14/11/2019, 3:12:16 PM                              Initial Version 
**/

//CODE REVIEWED BY: Prabhat Sharma

public without sharing class MCCommunicationTriggerHandler extends TriggerHandler {
  
    private Map<Id, MC_Communication__c > newMcComMap;
    private List<MC_Communication__c > newMcComList;
    private Map<Id,MC_Communication__c > oldMcComMap;
      
    //constructor
    public MCCommunicationTriggerHandler() {
        this.newMcComMap = (Map<Id, MC_Communication__c >) Trigger.newMap;
        this.newMcComList = (list<MC_Communication__c >) Trigger.New;
        this.oldMcComMap = (Map<Id,MC_Communication__c >) Trigger.oldMap;
    }
    
    //Method for before insert
    public override void beforeInsert(){
        updateCustomerOnMCCommunication();
        updateBrochureURLs();
    }
    
    //Method for before insert
    public override void afterInsert(){
        chatterPostToNotifyDSE();
    }
    
    //Method for after update 
    public override void afterUpdate(){
        updateEscalationFlagOnEnquiry();
    }
 
    /**
        Author: Rajesh Ramachandran
        Description: Method to update the Brochure URLs in URL field.
        Inputs: None
        Returns: void
        History:
        ====================================================
        1.0  10/01/2020, 3:12:16 PM  Rajesh Ramachandran  Initial Version
    **/    
    public void updateBrochureURLs(){
        List<BrochureURL__mdt> brUrl = [select id,MasterLabel, DeveloperName, Brochure_URL__c from BrochureURL__mdt];
        if (brUrl == null || brUrl.size() == 0)
            return;
        Map<String,String> mapModelToURl = new Map<String,String>();
        for (BrochureURL__mdt br : brUrl){
            mapModelToURl.put(br.masterLabel, br.Brochure_URL__c);
        }
        for(MC_Communication__c mc : newMcComList){
            if (mc.type__c == 'Send Brochure' && mc.General_Field_2__c != null){
                mc.URL_1__c = mapModelToURl.get(mc.General_Field_2__c);
            }
        }
    }

    /**
        Author: Anuj Kumar
        Company: Techmatrix
        Description: Method to update the Customer from Related enquiry.
        Inputs: None
        Returns: void
        History:
        ====================================================
        1.0  18/12/2019, 3:12:16 PM  Anuj Kumar  Initial Version
    **/
    public void updateCustomerOnMCCommunication(){
        
        Map<String, String> enquiryIdWithCustomerMap = new Map<String, String>();
        
        //Loop through MC Communication
        for(MC_Communication__c mc : newMcComList){
            if(mc.Enquiry_MD__c != null){
                enquiryIdWithCustomerMap.put(mc.Enquiry_MD__c, null);
            }
        }
        
        //Loop through Enquiries
        for(Opportunity opp : [Select id, customer__c from Opportunity Where Id IN: enquiryIdWithCustomerMap.keySet()]){
            if(opp.customer__c != null)
                enquiryIdWithCustomerMap.put(opp.Id, opp.customer__c);
        }
        
        //Assign Customer field
        if(enquiryIdWithCustomerMap != Null && enquiryIdWithCustomerMap.size() > 0){
            for(MC_Communication__c mc : newMcComList){
                if(mc.Enquiry_MD__c != null && enquiryIdWithCustomerMap.containsKey(mc.Enquiry_MD__c)){
                    mc.Customer__c = enquiryIdWithCustomerMap.get(mc.Enquiry_MD__c);
                }
            }
        }
        
    }
    
    
    /**
        Author: Prabhat Sharma
        Company: Techmatrix
        Description: Method to update the Escalation flag to true once the Escaltion message is sent for a level
        Inputs: None
        Returns: void
        History:
        ====================================================
        1.0  14/11/2019, 3:12:16 PM  Prabhat Sharma  Initial Version
    **/
    public void updateEscalationFlagOnEnquiry(){
        try{
            //set to store the enqiuiry Ids
            set<Id> enquiryIds = new set<Id>();
            list<MC_Communication__c> validMCComms = new list<MC_Communication__c>();
            for(MC_Communication__c  mcCom : this.newMcComList){
                //Check if type is Escalation and SFMC Flag is set to true
                if(mcCom.Type__c==ConstantsUtility.ESCALATION_MC_TYPE && mcCom.SFMC_Flag__c && !this.oldMcComMap.get(mcCom.Id).SFMC_Flag__c){
                    enquiryIds.add(mcCom.Enquiry_MD__c);
                    validMCComms.add(mcCom);
                }
            }
            
            //Only if the above criteria is true mark the Escalation flag to true 
            if(enquiryIds.size()>0){
                list<Opportunity> oppToUpdate = new list<Opportunity>();
                map<Id,Opportunity> enquiryMap = new map<Id,Opportunity>([SELECT Id,Type_of_Escalation__c,Time_for_Next_Escalation__c FROM Opportunity WHERE Id in: enquiryIds]);
                
                for(MC_Communication__c  mcCom : validMCComms){
                    if(String.isNotBlank(mcCom.General_Field_1__c) && mcCom.Escalation_Date_Time__c!=null && mcCom.Enquiry_MD__c!=null){
                        if(enquiryMap.containsKey(mcCom.Enquiry_MD__c) && enquiryMap.get(mcCom.Enquiry_MD__c).Type_of_Escalation__c==mcCom.General_Field_1__c && 
                           enquiryMap.get(mcCom.Enquiry_MD__c).Time_for_Next_Escalation__c==mcCom.Escalation_Date_Time__c){
                               Opportunity opp = new Opportunity();
                               opp.Escalated__c = true;
                               opp.Id = mcCom.Enquiry_MD__c;
                               oppToUpdate.add(opp);
                           }
                    }  
                }
                
                if(oppToUpdate.size()>0){
                    update oppToUpdate;
                }
            }
        }catch(Exception e){
            ExceptionHandler.LogError('MCCommunicationTrigger',e.getMessage(),'MC Communication',null,null);
        }        
        
    }
    
    /**
        Author: Prabhat Sharma
        Company: Techmatrix
        Description: Method to create chatter post when hostess clicks on Notify DSE button
        Inputs: None
        Returns: void
        History:
        ====================================================
        1.0  03/02/2020, 3:12:16 PM  Prabhat Sharma  Initial Version
    **/
    public void chatterPostToNotifyDSE(){
        
        map<Id,Id> enquirySalesUsersMap = new map<Id,Id>();
        //Loop through MC Communication
        for(MC_Communication__c mc : newMcComList){
            if(mc.Type__c==ConstantsUtility.SHOWROOM_WELCOME && mc.Enquiry_MD__c!=null && mc.Internal_User__c!= null){
                enquirySalesUsersMap.put(mc.Enquiry_MD__c,mc.Internal_User__c);
            }
        }
        
        //Create Chatter Post
        if(enquirySalesUsersMap.keySet().size()>0){
            //For bulk chatter post
            List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
            
            for(Id enquiryId : enquirySalesUsersMap.keySet()){
                //Create chatter message body
                ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                //Create text message for chatter
                ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                //Feed element input
                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                
                String messageBody=label.Notify_DSE_Chatter_Message ;
                
                //Add the message body in body input of feedElement
                textSegmentInput.text = messageBody+' ';
                messageBodyInput.messageSegments.add(textSegmentInput);
                
                //Add all the users id to receive chatter post and notification
                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                mentionSegmentInput.id = enquirySalesUsersMap.get(enquiryId);
                messageBodyInput.messageSegments.add(mentionSegmentInput);
                
                
                //Add the complete body along with @mentioned users in feed body
                feedItemInput.body = messageBodyInput;
                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                //Chatter post against enquiry
                feedItemInput.subjectId = enquiryId;
                //Make it visible to internal and external users
                feedItemInput.visibility = ConnectApi.FeedItemVisibilityType.AllUsers;
                //Create a batch of inputs for bulk chatter post
                ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
                batchInputs.add(batchInput);
            }
            //Post to chatter
            if(!test.isRunningTest()){
                ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);
            }
        }
        
    }
    
    
}