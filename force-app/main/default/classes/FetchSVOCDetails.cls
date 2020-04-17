/**
 * @File Name          : FetchSVOCDetails.cls
 * @Description        : This class fetches details from SVOC Maruti DB and displays in Salesforce in multiple components.
 * @Author             :
 * @Group              :
 * @Last Modified By   : Prabhat Sharma
 * @Last Modified On   : 7/31/2019, 01:05:33 AM
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
* 1.0    7/05/2019, 9:14:54 PM      Prabhat Sharma                Initial Version
  1.1    9/09/2019, 4:14:54 PM      Sunit Kumar Chand             getCustomerDetails method added
**/

public with sharing class FetchSVOCDetails {
   
    private static final List<String> CAR_SVOC_DETAILS = new List<String>{
        'Car_Details',
        'Insurance_History',
        'Service_History',
        'EW',
        'MCP'
    };    

    /**
        Author: Prabhat Sharma
        Company: Techmatrix
        Description: This method will return based on the passed in argument (e.g. Loyalty, Referral etc.)
        Inputs: Search string
        Returns: List of wrapper class including details of field label and value
        History:
        ================
        1.0     05 Jul 2019      Prabhat     Initial Version
    */
    @AuraEnabled(continuation=true cacheable=true)
    public static Object fetchSelectedSVOCDetails(String svocDetail,String svocId,String vin) {
        System.debug('Inside fetchSelectedSVOCDetails');
        //Custom metadata developer name
        BasicReturn br=new BasicReturn();
        try{
            String svocDetailName = svocDetail.replaceAll(' ','_');
            svocDetail = CAR_SVOC_DETAILS.contains(svocDetailName) ? 'Car_Details' : svocDetailName;
            //Map to store the Mulesoft API details
            Map<string, MuleSoft_API_Details__mdt> svocApiDetailMap= new Map<string, MuleSoft_API_Details__mdt>();
            for(MuleSoft_API_Details__mdt apiDetail : [SELECT DeveloperName,DealerMapCode__c,Endpoint__c, LocationCode__c,UserType__c,TimeOut_Value__c,x_channel_id__c,x_channel_token__c,Parameters__c,Parameter_API_Keys__c,Authorization__c,x_transaction_id__c,Api_Name__c FROM MuleSoft_API_Details__mdt WHERE DeveloperName=:svocDetail]){
                svocApiDetailMap.put(apiDetail.DeveloperName,apiDetail);                                                    
            }
            //This will have the end point of the request
            String apiEndPoint;
            //If the map has end point details, construct the end point
            if(svocApiDetailMap.containsKey(svocDetail) && String.isNotBlank(svocApiDetailMap.get(svocDetail).Endpoint__c)){
               String[] reqParametersAPIKey=svocApiDetailMap.get(svocDetail).Parameter_API_Keys__c.split(',');
               BasicReturn apiRequestData=getCustomerDetails(svocApiDetailMap.get(svocDetail).Parameters__c,reqParametersAPIKey);
               //System.debug(svocDetail);
               apiEndPoint = svocApiDetailMap.get(svocDetail).Endpoint__c+'/'+svocId+'/'+svocApiDetailMap.get(svocDetail).Api_Name__c;
               if(svocDetail==ConstantsUtility.CUSTOMER_VEHICLE_HISTORY && svocId!=null && svocId!='')
               {
                   apiEndPoint = svocApiDetailMap.get(svocDetail).Endpoint__c+'='+svocId;
                   
               }
                else if(svocDetail==ConstantsUtility.CUSTOMER_VEHICLE_HISTORY && vin!=null && vin!='')
                {
                    apiEndPoint = svocApiDetailMap.get(svocDetail).Endpoint__c+'='+vin;
                    apiEndPoint=apiEndPoint.replace('customerId','vin');
                }
               
                br=apiRequestData;
                if(apiRequestData.status=='Success'){
                    for(String apiKey: apiRequestData.getStringMap.keySet()){
                        if(apiEndPoint.contains('?')){
                            apiEndPoint += '&'+apiKey+'='+apiRequestData.getStringMap.get(apiKey);
                        }
                        else{
                            apiEndPoint += '?'+apiKey+'='+apiRequestData.getStringMap.get(apiKey);
                        }
                    }
                }
            }
            system.debug('>>>apiEndPoint>>>'+apiEndPoint);
            if(String.isNotBlank(apiEndPoint) && svocApiDetailMap.containsKey(svocDetail)){
                
                //Timeout for Continuation object
                Integer timeOut = svocApiDetailMap.get(svocDetail).TimeOut_Value__c!=null ? Integer.valueOf(svocApiDetailMap.get(svocDetail).TimeOut_Value__c) : ConstantsUtility.DEFAULT_TIMEOUT_CONST;
                //Initializing continuation object
                Continuation con= new Continuation(timeOut);
                //Callback function
                con.continuationMethod='processResponse';
                //System.debug('apiEndPoint'+ apiEndPoint);
                //API Request
                HttpRequest request= new HttpRequest();
                request.setEndpoint(apiEndPoint);
                request.setMethod('GET');
                request.setHeader(ConstantsUtility.CHANNEL_TRANSACTION_ID_CONST, svocApiDetailMap.get(svocDetail).x_transaction_id__c);
                request.setHeader(ConstantsUtility.CHANNEL_TOKEN_CONST, svocApiDetailMap.get(svocDetail).x_channel_token__c);
                request.setHeader(ConstantsUtility.CHANNEL_ID_CONST, svocApiDetailMap.get(svocDetail).x_channel_id__c);
                request.setHeader('Content-Type', 'application/json');            
                request.setHeader('Authorization', svocApiDetailMap.get(svocDetail).Authorization__c);
                request.setHeader('Accept', 'application/json');
                System.debug('API Start Time'+ DateTime.now().millisecond());
                //Add api request to continuation object
                con.addHttpRequest(request);
                con.state = svocDetailName;
                System.debug('API End Time'+ DateTime.now().millisecond());
                //Updating cunter of SVOC accessed by DSE on its account
              /*  Profile p = [Select Id from profile where Name =: 'Dealer Sales Executive'];
                User u = [select Id from user where id=:userinfo.getuserid() and ProfileId =: p.Id Limit 1];
                if(u != null)
                {
                    Account acc = [Select Id,No_of_Times_SVOC_Accessed__c from Account where User__c !=: u.Id];
                    if(acc != null)
                    {
                        Integer num;
                        if(acc.No_of_Times_SVOC_Accessed__c == null) 
                               num =0;
                        else
                            num = Integer.valueOf(acc.No_of_Times_SVOC_Accessed__c);
                                   
                        num +=1;       
                        acc.No_of_Times_SVOC_Accessed__c = String.valueOf(num);
                        update acc;
                    }
                }*/
                //Return continuation object
                return con;
                //br.data=con;
            }
        }
        catch(Exception e)
        {
            br.code=1;
            br.message=e.getMessage();
            br.status='error';
        }
        System.debug(br);
        return br;
    }


    /**
        Author: Prabhat Sharma
        Company: Techmatrix
        Description: This method will receive the API response as a callback function
        Inputs: List of string and Object defining continuation state
        Returns: A wrapper object
        History:
        ====================================================
        1.0     30 Jul 2019      Prabhat     Initial Version
    */
    @AuraEnabled(cacheable=true)
    public static Object processResponse(List<String> labels, Object state){
       
        System.debug('Inside processResponse');
        //Get the selected svoc from Continuation state attribute
        String selectedSvocDetail = (String)state;
       
        //Create metadata developer name
        selectedSvocDetail = selectedSvocDetail.replaceAll(' ','_');
       
       
        //This will contain the tabel headers
        list<string> fieldlist = new list<string>();
        //This will contain the response keys
        list<string> keyslist = new list<string>();
        //svoc type of data and the keu map
        map<string,string> svocDetailmap = new map<string,string>();
       
        //Loop through SVOC detail metadata type
        for(SVOC_Details__mdt svocdetailss : [SELECT Fields__c,keys__c,DeveloperName,API_Data_Key__c FROM SVOC_Details__mdt WHERE DeveloperName=: selectedSvocDetail]){
            keyslist.addAll(svocdetailss.keys__c.split(';'));
            fieldlist.addAll(svocdetailss.Fields__c.split(';'));
            svocDetailmap.put(svocdetailss.DeveloperName,svocdetailss.API_Data_Key__c);
        }


        //Map for putting the response key headers to be replaced with actual headers
        map<string,string> responseHeaderLabelmap = new map<string,string>();

        //Fill the map to hold API response keys and actual labels as headers
        if(keyslist.size()>0 && fieldlist.size()>0){
            for(integer i=0;i<fieldlist.size();i++){
                responseHeaderLabelmap.put(keyslist[i],fieldlist[i]);
            }
        }

        System.debug('API Start Time'+ DateTime.now().millisecond());
        // Get the API response by using the unique label
        HttpResponse response= Continuation.getResponse(labels[0]);
        System.debug('API End Time'+ DateTime.now().millisecond());
        System.debug(response.getStatusCode());
        System.debug(response.getBody());
        //Master wrapper to hold the labels and the list of values
        FetchSVOCDetails.SVOCMasterWrapper masterWrap = new FetchSVOCDetails.SVOCMasterWrapper();
        //Parse the response as an untyped JSON object
        Map<String, Object> resultMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        if(response.getStatusCode() == 200 && String.isNotBlank(response.getBody())){
            //Check if the mulesoft response is success
            if(resultMap.get('status')=='Success' && resultMap.containskey(ConstantsUtility.API_STATUS_CONST) && resultMap.get(ConstantsUtility.API_STATUS_CONST)==ConstantsUtility.API_RESPONSE_CONST){
                //Unique key for each API response recieved
                String dataKey = svocDetailmap.containsKey(selectedSvocDetail) ? svocDetailmap.get(selectedSvocDetail) : '';
                //Get all the details in list of object
                List<Object> resultObjlist = (List<Object>)resultmap.get(dataKey);
               
                //system.debug('resultObjlist--->'+resultObjlist);
               
                //To store all keys as recived in the response
                set<String> tableHeaders = new set<String>();
                list<FetchSVOCDetails.FieldValueWrapper> fwrapList = new list<FetchSVOCDetails.FieldValueWrapper>();
                //Loop through the list of object to get the
                for(Object obj : resultObjlist){
                    //Create a map of key attributes and their values
                    Map<String, Object> objectAttributes = (Map<String, Object>)obj;

                    //Add all te keys to get the actual headers
                    tableHeaders.addAll(objectAttributes.keySet());
                    //Create a wrapper instance to add all response values in a list of object
                    FetchSVOCDetails.FieldValueWrapper fwrap = new FetchSVOCDetails.FieldValueWrapper();
                    fwrap.svocFieldValue = new list<Object>();
              //Commented by Sunit on 2019-09-27 for dynamic label fixing
                    /*for(Object newObj : objectAttributes.values()){
                        fwrap.svocFieldValue.add(newObj);
                    }*/
              //Added by Sunit on 2019-09-27 for dynamic label fixing
                    for(String key : keyslist){
                        fwrap.svocFieldValue.add(getValue(objectAttributes, key));
                    }
                    fwrapList.add(fwrap);
                }
               // System.debug(fwrapList);
              //Added by Sunit on 2019-09-27 for dynamic label fixing
              if(!fwrapList.isEmpty()){
                  masterWrap.svocFielLabelList=fieldlist;
              }
               
             //Commented by Sunit on 2019-09-27 for dynamic label fixing
                //Loop through
                /*for(String headers : tableHeaders){
                    if(responseHeaderLabelmap.containsKey(headers)){
                        String columnLabel = responseHeaderLabelmap.get(headers);
                        masterWrap.svocFielLabelList.add(columnLabel);
                    }
                }*/

                //Add all the values to master wrapper
                masterWrap.fieldValueWrapList = fwrapList;
                masterWrap.rawResponse=response.getBody();
                masterWrap.keys=keyslist;
                }
            }
       /* else
        {
          ExceptionHandler.stackTrace ehst=new ExceptionHandler.stackTrace();
          ehst.componentName='FetchSVOCDetails';
          ehst.userId=UserInfo.getUserId();
          ExceptionHandler.LogError('FetchSVOCDetails',response.getStatusCode()+':'+System.label.UI_Error_Message , selectedSvocDetail, '', ehst);
        }*/
        System.debug(response.getStatus());
        BasicReturn br=new BasicReturn();
        br.code=response.getStatusCode();
       
        if(response.getStatusCode()==200)
        {
            br.status=String.valueof(resultMap.get('status'));
        }
        else
        {
            br.status='error';
        }
       
        br.data=masterWrap;
        //br.message=response.g
        System.debug(masterWrap);
        return br;
    }

    /**
        Author: Sumit Gupta
        Company: Salesforce
        Description: parse response value
        History:
        ====================================================
        1.0     09 Sep 2019      Sunit     Initial Version
    */
    private static String getValue(Map<String, Object> data, String key){
        String value = '';
        try{
            if(key.contains('.')){
                List<String> keys = key.split('\\.');
                key = keys.get(0);
                if(data.containsKey(key)){
                    keys.remove(0);
                    value = getValue((Map<String, Object>) data.get(key), String.join(keys, '.'));
                }
            } else if(key.contains('+')){
                List<String> keys = key.split('\\+');
                List<String> values = new List<String>();
                for(String key2 : keys){
                    if(data.containsKey(key2)){
                        values.add(String.valueOf(data.get(key2)));
                    }
                }
                value = String.join(values, ' ');
            } else if(data.containsKey(key)){
                value = String.valueOf(data.get(key));
            }
        } catch(Exception ex){
            System.debug('Could not parse value');
        }
        return value;
    }

    /**
        Author: Sunit Kumar Chand
        Company: Techmatrix
        Description: This method is used to get Account detail of delear for API request
        Inputs:
        Returns:
        History:
        ====================================================
        1.0     09 Sep 2019      Sunit     Initial Version
    */
    public static BasicReturn getCustomerDetails(String parameters,String[] apiKeys)
    {
        //System.debug('Inside getCustomerDetails');
        User user;
        BasicReturn br= new BasicReturn();
        Map<String,String> apiRequestData= new Map<String,String>();
        try
        {
          //System.debug('Inside getCustomerDetails 1');
          String query='Select ';
          String userId=UserInfo.getUserId();
          userId=String.escapeSingleQuotes(userId);
          Map<String, Object> parametersMap=(Map<String, Object>)JSON.deserializeUntyped(parameters);
          if(apiKeys.size()>0){
               for(integer i=0;i<apiKeys.size();i++)
              {
                  if(String.valueOf(parametersMap.get(apiKeys[i])).contains('$user')){
                      query+=String.escapeSingleQuotes(String.valueOf(parametersMap.get(apiKeys[i])).split('user.')[1])+', ';  
                  }
              }
              query=query.substring(0,query.length()-2)+' from User where Id=\''+userId+'\'';
          }
            //System.debug(query);
            user=Database.query(query);
          //user=[Select AccountId,ContactId,contact.account.Dealer_Map_Code__c from User where Id=:UserInfo.getUserId()];
             if(user !=null ){
                Map<String, Object> userData = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(user));
                //System.debug(userData);
                for(String apiKey: apiKeys)
                {
                    if(apiKey=='UserType' && String.valueOf(userData.get(apiKey))=='PowerPartner'){
                         apiRequestData.put(apiKey,'E');
                    }
                    else if(apiKey=='UserType' && String.valueOf(userData.get(apiKey))!='PowerPartner'){
                        //System.debug('Inside else IF');
                        apiRequestData.put(apiKey,'I');
                    }
                    if(apiKey!='UserType' && apiKey!='SVOCID' && String.valueOf(userData.get('UserType'))=='PowerPartner'){
                        String tempApiKey=String.valueOf(parametersMap.get(apiKey)).split('user.')[1];
                        String[] tempApiKeyArray=tempApiKey.split('.');
                        Map<String, Object> finalVal= (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(userData.get('Contact'))) ;
                        System.debug(finalVal.get('Account'));
                        Map<String, Object> finalMap= (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(finalVal.get('Account'))) ;
                        apiRequestData.put(apiKey,String.valueOf(finalMap.get(String.valueOf(parametersMap.get(apiKey)).split('user.contact.account.')[1]))==null?'':String.valueOf(finalMap.get(String.valueOf(parametersMap.get(apiKey)).split('user.contact.account.')[1])));
                    }
                   
                }
               
               
            }
            br.code=200;
            br.message='';
            br.status='Success';
            br.getStringMap=apiRequestData;
        }
        catch(Exception e)
        {
          System.debug(e.getMessage());
          //e.getStackTraceString();
          //ExceptionHandler.stackTrace ehst=new ExceptionHandler.stackTrace();
          //ehst.componentName='FetchSVOCDetails';
          //ehst.userId=UserInfo.getUserId();
          //ExceptionHandler.LogError('FetchSVOCDetails', e.getMessage(), 'getCustomerDetails', '', ehst);
          br.code=1;
          br.message=e.getMessage();
          br.status='error';
         
        }
        //System.debug(apiRequestData);
        return br;
    }
    //Master wrapper class
    public class SVOCMasterWrapper{
        //This will store all the values
        @AuraEnabled public List<FetchSVOCDetails.FieldValueWrapper> fieldValueWrapList;
        //This will store all the labels
        @AuraEnabled public List<String> svocFielLabelList;
        //This will store raw response of API
        @AuraEnabled public String rawResponse;
        @AuraEnabled public List<String> keys;

        public SVOCMasterWrapper(){
            fieldValueWrapList = new list<FetchSVOCDetails.FieldValueWrapper>();
            svocFielLabelList = new list<String>();
        }
    }
    //Wrapper Class for holding the field values
    public class FieldValueWrapper{
        //Variable to store field value
        @AuraEnabled public List<Object> svocFieldValue;
    }
    
    @AuraEnabled
    public static void updateDSEAccountForSVOCCounter()
    {
                system.debug('417 ');
                 //Updating cunter of SVOC accessed by DSE on its account
                Profile p = [Select Id from profile where Name =: 'Dealer Sales Executive'];
                system.debug('417 '+p);
                User u = [select Id from user where id=:userinfo.getuserid() and ProfileId =: p.Id Limit 1];
                system.debug('417 '+u);
                if(u != null)
                {
                    Account acc = [Select Id,No_of_Times_SVOC_Accessed__c from Account where User__c =: u.Id limit 1];
                    system.debug('417 '+acc);
                    if(acc != null)
                    {
                        system.debug('417 '+acc);    
                        Integer num;
                        if(acc.No_of_Times_SVOC_Accessed__c == null) 
                               num =0;
                        else
                            num = Integer.valueOf(acc.No_of_Times_SVOC_Accessed__c);
                                   
                        num +=1;       
                        acc.No_of_Times_SVOC_Accessed__c = String.valueOf(num);
                        system.debug('417 '+acc);
                        update acc;
                    }
                }
    }
}