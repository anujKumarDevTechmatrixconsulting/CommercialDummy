/**
 * @File Name          : ConstantsUtility.cls
 * @Description        : This class will have all the constants defined to be used in various other classes
 * @Author             : 
 * @Group              : 
 * @Last Modified By   : Rajesh Ramachandran
 * @Last Modified On   : 10/12/2019, 8:18:06 AM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
* 1.0    7/31/2019, 9:14:54 PM      Prabhat Sharma                Initial Version
**/



public with sharing class ConstantsUtility {
    
    /**
    * Mulesoft API Headers and Keys to be used during api callouts
    **/
    public static final String DEALERMAP_CODE_CONST = 'DealerMapCode';

    public static final String LOCATION_CODE_CONST = 'LocationCode';

    public static final String USER_TYPE_CONST = 'UserType';

    public static final String CHANNEL_ID_CONST = 'x-channel_id';

    public static final String CHANNEL_TOKEN_CONST = 'x-channel_token';
    
    //Added By-: Nishant Prajapati    7/31/2019
    public static final String CHANNEL_TRANSACTION_ID_CONST= 'x-transaction_id';
    
    public static final Integer DEFAULT_TIMEOUT_CONST = 40;

    public static final String API_STATUS_CONST = 'status';

    public static final String API_RESPONSE_CONST = 'Success';

    public static final String POST_REQUEST = 'POST';
    public static final String PUT_REQUEST = 'PUT';
    public static final String GET_REQUEST = 'GET'; 
    public static final String GET_TEST_DRIVE_SLOTS = 'Get Test Drive Slots'; 
    public static final String CREATE_DRIVE_SLOTS = 'Test Drive'; 
    public static final String CREATE_BOOKING = 'Create Booking'; 
    public static final String STOCK_CHECK = 'StockCheck'; 
    public static final String ASSET_PURCHASED = 'P'; 
    
    
    public static final String PROCESS_CALLBACK = 'processResponse'; 
    public static final String MOCK_CALLBACK = 'mockResponse'; 
    public static final String FORWARD_SLASH = '/'; 
    public static final String QUESTION_MARK = '?'; 
    public static final String ACCEPT_HEADER_LABEL = 'Accept'; 
    public static final String ACCEPT_HEADER_VALUE = 'application/json'; 
    public static final String AUTH_HEADER_LABEL = 'Authorization'; 
    public static final String CONTENT_TYPE_HEADER_LABEL = 'Content-Type';
    public static final String POWER_PARTNER = 'PowerPartner';
    
    public static final String VIN_NO = 'vin';
    public static final String DATE_RANGE = 'dateRange';
    public static final String MSPIN = 'mspin';
    public static final String ENQUIRY_ID = 'enquiryId';
    public static final String ORG_ID = 'orgId';
    public static final String EQUALS = '=';
    public static final String AMPERSAND = '&'; 
    public static final String M_ALPHABET = 'M';
    public static final String CONTACT_OBJ = 'Contact';
    public static final String IGNORE_CASE='__TD__';
    public static final String A_ALPHABET = 'A';
    public static final String I_ALPHABET = 'I'; 
    public static final String IS_CHECKED = 'isChecked';
    public static final String LABEL = 'label';
    
    
    public static final String PROFILE_NAME = 'Dealer Team Leads/Managers';
    public static final String DSE_PROFILE_NAME = 'Dealer Sales Executive';
    
    // This variable is used in Change Owner Functionality to check restricted profile
    public static final String OWNER_CHANGE_RESTRICTED_PROFILE_NAME = 'Dealer Sales Executive';
    
    
    public static final String API_TYPE='apiType';
    public static final String VARIANT_CODE='variantCode';
    public static final String COLOR_CODE = 'colorCode';
    public static final String DEALER_MAP_CODE = 'dealerMapCode';
    public static final String LOCATION_CODE = 'locationCode';
    public static final String PARENT_CODE = 'parentCode';
    public static final String PRODUCT_TYPE = 'productType';
    public static final String CONSINGNEE_CODE = 'consingneeCode';
    public static final String USER_TYPE = 'userType';
    public static final String PRODUCT_OBJ='Product2';
    public static final String FUEL_TYPE_FIELD = 'fuel_type__c';
    public static final String SCHEME_MASTER = 'Scheme_Master__c';
    public static final String FAMILY = 'family';
    public static final String DISCOUNT_AMT_FIELD = 'discount_amount__c';
    
    
    //Added By-: Anuj    7/31/2019  
    /*******     START HERE     *******/
    
    public static String IsAccessible = 'isAccessible';
    public static String IsCreateable = 'isCreateable';
    public static String IsUpdateable = 'isUpdateable';
    
    public static final String YES = 'Yes';
    
    public static final String GENERAL_FOLLOW_UP_TASK_REC_TYPE = 'General Follow-up';
    
    public static final String PRE_BOOKING_FOLLOWUP = 'Pre Booking Follow-up';
    public static final String POST_BOOKING_FOLLOWUP = 'Post Booking Follow-up';
    
    public static final String SALES_EXECUTIVE = 'Sales Executive';
    public static final String TEAM_LEADER = 'Team Leader';
    public static final String SHOWROOM_MANAGER = 'Showroom Manager';
    public static final String CEO = 'CEO';
    public static final String GM = 'GM';
    
    public static final String BLANK_VALUE = '';
    public static final String DOUBLE_BACK_SLASH = '\\';
    public static final String BACK_SLASH_DOUBLE_QUOTE = '\"';
    
    public static final String OPEN_DOUBLE_QUOTE_CURLY_BRACES = '"{';
    public static final String OPEN_CURLY_BRACES = '{';
    
    public static final String CLOSE_DOUBLE_QUOTE_CURLY_BRACES = '}"';
    public static final String CLOSE_CURLY_BRACES = '}';
    
    public static final String OPEN_DOUBLE_QUOTE_SQUARE_BRACKET = '"[';
    public static final String OPEN_SQUARE_BRACKET = '[';
    
    public static final String CLOSE_DOUBLE_QUOTE_SQUARE_BRACKET = ']"';
    public static final String CLOSE_SQUARE_BRACKET = ']';
    
    public static final String STDPRICEBOOK = 'Standard Price Book';
    
    public static final String CLOSED_FOLLOW_UP_METADATA = 'Closed_Follow_Up_Field_Label_Info';
    
    public static final String ACCESSORIES_SALES_CONST = 'Accessories Sales';
    
    public static final String ACCESSORIES_DISCOUNT_CONST = 'Accessory Discount';
    
    public static final String DEALER_RECORDTYPE = 'Dealer';
    public static final String OPPORTUNITY_VEHICLE_SALES_RECORDTYPE = 'Vehicle Sales';
    public static final String RETAIL_NAME = 'Retail';
    public static final String DEL_CLOSED_WON_NAME = 'Delivery/Closed Won';
    
    public static final String STAGE_NEW = 'New';
    public static final String STAGE_CLOSELOST = 'Closed Lost';
    public static final String STAGE_PREBOOKING = 'Pre-Booking';
    
    public static final String OPPORTUNITY = 'Opportunity';
    public static final String QUOTE = 'Quote';
    public static final String TEST_DRIVE = 'Test_Drive__c';
    public static final String TEST_DRIVE_SUCCESS_MESSAGE='Test Drive created Successfully';
    public static final String LINE_ITEM_SUMMARY_FIELD = 'Line_Item_Summary__c';
    
    public static final String STATUS_OPEN = 'Open';
    public static final String STATUS_COMPLETED = 'Completed';
    public static final String STATUS_APPROVED = 'Approved';
    public static final String STATUS_PENDING = 'Pending';
    public static final String STATUS_REJECTED = 'Rejected';
    
    public static final String FIELD_ENQUIRYSCORING = 'Enquiry_Scoring__c';
    public static final String FIELD_REASON = 'Reason__c';
    public static final String FIELD_SUBREASON = 'SubReason__c';
    
    public static final String FIELD_DEALERSHIP_CHANNEL = 'Dealership_Channel__c';
    public static final String FIELD_ENQ_MODEL = 'Model_Code__c';
    
    public static final String FIELD_VALUE_REQUESTTOLOST = 'F';
    public static final String FIELD_VALUE_ORDERBOOKING = 'Order booking';
    
    public static final String APPROVAR_COMMENTS = 'Submitting request for approval';
    
    public static final String TASK_SUBJECT = 'Request to Lost Rejected - Contact the Customer';
    
    public static final set<String> portalUserTitleSet = new set<String>{SALES_EXECUTIVE, TEAM_LEADER, SHOWROOM_MANAGER};
    public static final set<String> userTitleCEOGMSet = new set<String>{CEO, GM};
    public static final set<String> userTitleTSMSet = new set<String>{'TSM'};
    public static final String TSM_ROLE = 'TSM';
    
    /**
    * Below constants referred in JSON Wrapper Used In Quote/Pre Booking 
    **/
    public static final String EX_SHOWROOM_VARIANT_KEY = 'exShowRoomVariant';
    public static final String OPPORTUNITY_ID_KEY = 'opporrtunityId';
    public static final String OPPORTUNITY_INFO_KEY = 'opportunityInfo';
    public static final String SELECTED_VARIANT_KEY = 'selectedVariant';
    public static final String ADD_SCHEMES_KEY = 'addSchemes';
    public static final String EXCHANGE_BONUS_KEY = 'exchangeBonusValue';
    public static final String EXCHANGE_BONUS_DATA_KEY = 'exchangeBonusData';
    
    public static final String CORPORATE_DIS_VALUE_KEY = 'corporateDiscountValue';
    public static final String CORPORATE_DIS_DATA_KEY = 'corporateDiscountData';
    
    public static final String RURAL_OFFER_VALUE_KEY = 'ruralOffersValue';
    public static final String RURAL_DIS_DATA_KEY = 'ruralDiscountData';
    
    
    public static final String SCHEME_CODE_KEY = 'schemeCode';
    
    public static final String NAME_CONST = 'Name';
    public static final String PRICEBOOK2_ID_CONST = 'Pricebook2Id';
    public static final String PRICEBOOKENTRY_ID_CONST = 'priceBookEntryId';
    public static final String EMAIL_CONST = 'Email__c';
    public static final String Mobile_CONST = 'Mobile__c';
    public static final String ACCESSORIES_CREATION_CONST = 'Accessories Creation';
    
    public static final String OPPORTUNITY_KEY_PREFIX = '006';
    public static final String QUOTE_KEY_PREFIX = '0Q0';
    public static final String TASK_KEY_PREFIX='00T';
    /*******     END HERE     *******/
    
    
    public static final string MARUTI_MANAGEMENT = 'Maruti_Management';


    /**
    * Below constants referred in Opportunity Trigger Handler
    **/
    
    public static final String RESIDENCE = 'Residence';
    public static final String OFFICE = 'Office';
    public static final String BILL_TO = 'Bill To';
    public static final String SHIP_TO = 'Ship To';
    
    
    
    public static final String USER_ACCT_RECORDTYPE = 'User_Account';
    public static final String OPPSHARE_CONST = 'Read';
    public static final String DOUBLE_QUOTES = '"';
    public static final String COLON = ':';
    public static final String COMMA = ',';
    public static final map<string,String> channelModelMap = new map<string,String>{'EXC'=>'Nexa','NRM'=>'Arena'};
    
    
    
    /**
    * Below constants referred in Signature LWC 
    **/
    public static final String SIGNATURE_LABEL = 'Signature';

    /**
    * Below constants referred in Generate OTP LWC 
    **/
    public static final String OTPBASEVALUE_CONST = 'OTP_Base_Value__c';
    public static final String OTPGENERATED_CONST = 'OTP_Generated_Time__c';
    public static final String RECORDID_CONST = 'Id';
    public static final String TASKSUBJ_CONST = 'OTP Generated is ';
    public static final String TASKSTATUS_CONST = 'Completed'; 
    public static final String OTP_MC_TYPE = 'PRE-BOOKING OTP'; 
    
    

    /**
    * Below constants referred in Customer Profile Trigger Handler
    **/
    public static final String PICKLIST_DEFAULT_VALUE = 'Please Select'; 
    public static final String ID_CONST = 'Id'; 
    public static final String GENDER_CONST = 'Gender__pc'; 
    public static final String AADHAR_CONST = 'Aadhaar__pc'; 
    public static final String PAN_CONST = 'PAN__pc';  
    public static final String BIRTHDATE_CONST = 'PersonBirthdate';
    
    //Customer Profile object fields
    public static final String CUSTOMER_FIELDCONST = 'Customer__c'; 
    public static final String GENDER_FIELDCONST = 'Gender__c'; 
    public static final String AADHAR_FIELDCONST = 'Aadhaar__c'; 
    public static final String PAN_FIELDCONST = 'PAN__c';  
    public static final String BIRTHDATE_FIELDCONST = 'date_of_birth__c';
    
    
    public static final String OPPSTAGECHECKPREBOOKING_CONST='Pre-Booking';// This variable is used to check if Opp stage is Pre booking or not
    
    
    /**
    * Below constants referred in Opportunity Trigger Handler in SVOC Search logic
    **/
    public static final String CUSTOMER_RECORDTYPE = 'Customer'; 
    public static final String PROSPECT_CUSTOMER = 'Prospect'; 
    public static final String DUPLICATE_CUSTOMER = 'Duplicate'; 
    public static final String DOT_OPERATOR = '.';
    public static final String DMS_USER = 'DMS Admin';

    /**
    * Below constants referred in Opportunity Trigger Handler to set Last Modified Details in setStageTime Method
    **/
    public static final String STAGE_LABEL = 'Stage'; 
    public static final String DEALERMAPCODE_LABEL = 'Dealer_Map_Code'; 
    public static final String DEALERPARENTGROUP_LABEL = 'Parent_Group';
    public static final String FORCODE_LABEL = 'For_Code';  
    public static final String TIMESTAMP_LABEL = 'Time_Stamp';
    public static final String PRE_BOOKING_LABEL = 'Pre_Booking_Number';
    public static final String COLOR_LABEL = 'Color_Code';   
    public static final String DEALER_CODE = 'Mul_Dealer_Code';
    public static final String DMS_ENQUIRY_NUM = 'DMS_Enquiry_Name';
    public static final String RECORD_TYPE_CONST = 'Record_Type';
    public static final String DEALERLOCATIONCODE_LABEL = 'Dealer_Location_Code';
    public static final String DEALER_COMP_FA = 'Dealer_COMP_FA';
    public static final String BOOKING_NUMBER = 'Booking_Number';
    public static final String IS_FOLLOW_UP_UPDATE = 'Is_FollowUP_Update';
    public static final String DEALER_FIELD = 'Dealership__c';
   
    /**
    * Below constants referred in Opportunity Trigger Handler while create Pre Booking Follow Ups
    **/
    public static final String PREBOOKING_FOLLOWUP_PRIORITY = 'Normal'; 
    public static final Integer PREBOOKING_REMINDER_TIME = 30; 
    public static final String PREBOOKING_FOLLOWUP_TYPE = 'T'; //Changes by Rahul to update the type field 
    public static final String GENERAL_FOLLOWUP_TYPE = 'E';
    
    
    /**
    * Below constants referred in Opportunity Trigger Handler 
    **/
    public static final String NEXA_LINEOFBUSINESS = 'Nexa';
    public static final String ARENA_LINEOFBUSINESS = 'Arena';
    public static final String ISL_LINEOFBUSINESS = 'ISL';
    public static final String RURAL_LINEOFBUSINESS = 'Rural';
    public static final String ACCESSORIES_LINEOFBUSINESS = 'Accessories';
    public static final string STAGE_BOOKING= 'Booking';
    public static final string DSE_ALLOCATION= 'DSE Allocation';
    public static final string DSE_UNTAGGED= 'DSE Untagged'; 
    public static final string SPOC_TO_ALLOT_DSE= 'SPOC To Allot DSE';
    public static final string TD_SURVEY_FEEDBACK = 'Test Drive Feedback';
    
    public static final string BILL_To_ADDRESS_LINE_FIELD = 'BillTo_Address_Line__c';
    public static final string ADDRESS_LINE_FIELD = 'Address_Line__c';
    
    //TEST DRIVE AND DELIVERY CHECKLIST CHECKLIST   
    public static final String SCHEDULE_START = 'Scheduled_Start__c';   
    public static final String SCHEDULE_END = 'Old_Scheduled_Start_Date_Time__c';   
    public static final String INVOICE_DATE = 'Invoice_Date__c';
    
    public static final Integer ZERO = 0;
    public static final Integer THIRTY = 30;
    public static final Integer FIFTY = 50;
    public static final Integer SIXTY = 60;
    
    public static final String CORP_GRP_LINE_ITEM_FIELD = 'Corporate_Group_Line_Items__c';
    
    //Primary TSM field API Name from Account
    public static final String PRIMARY_TSM = 'Territory_Sales_Manager__c';
    public static final String FINANCE_MANAGER = 'Finance_Manager__c';
    public static final String TSM_ISL = 'TSM_ISL__c';
    public static final String TSM_RURAL = 'TSM_Rural__c';
    public static final String TSM_MGA = 'TSM_MGA__c';
    public static final String ACCESSORIES_SPOC_1 =  'Accessories_SPOC_1__c';
    public static final String ACCESSORIES_SPOC_2 =  'Accessories_SPOC_2__c';
    
    //Field to add Enquiry Team Member
    public static final String ACCESSORIES_DSE = 'Accessories_DSE1__c';
    public static final String ACCESSORIES_DSE_DESIGNATION = 'MSE';
    
    /*
    * Below constants referred in Booking BCR PDF 
    **/
    public static final String BCR_FORM = 'Booking Confirmation Report';
    public static final String TERMS_N_CONDITIONS = 'Terms & Conditions';
    public static final String CUSTOMER_UNDERTAKING = 'Customer Undertaking';
    
    public static final String VARIANT_CONST = 'Variants';
    public static final String ACCESSORIES_CONST = 'Accessories';
    public static final String COMPONENT_CONST = 'Component';
    public static final String OFFER_CONST = 'Offer';
    
    public static final String REGISTRATION_CONST = 'Registration';
    
    public static final String REGISTRATION_AMOUNT_CONST = 'Registration Amount';
    
    public static final String EX_WARRANTY_CONST = 'Extended Warranty';
    public static final String MCP_CONST = 'MCP';
    public static final String INSURANCE_CONST = 'Maruti Insurance';
    public static final String EX_WARRANTY_1_YR = 'Extended_Warranty_1_year__c';
    public static final String EX_WARRANTY_2_YR = 'Extended_Warranty_2_year__c';
    public static final String EX_WARRANTY_3_YR = 'Extended_Warranty_3_year__c';
    public static final String LOYALTY_AMT = 'Loyalty_Amount__c';
    public static final String ADD_COMPONENT = 'addComponent';
    public static final String YEAR_CONST = 'year';
    public static final String ADD_ACCESSORIES = 'addAccessories';
    
    
    
    public static final String LOYALTY_CONST = 'Loyalty';
    public static final String INSURANCE_CONT = 'Insurance';
    
    public static final String MUNICIPAL_CH_CONST = 'Municipal Charges';
    public static final String NUM_PLATE_CONST = 'Number Plate Charges';
    public static final String SCHEMES_CONST = 'Schemes';
    public static final String CORP_SCHEME = ';0.0';
    public static final String SEMI_COLON = ';';
    
    
    public static final String CORPORATE_DISCOUNT_CONST = 'Corporate Discount';
    public static final String EXCH_BONUS_CONST = 'Exchange Bonus';
    public static final String EXCH_VALUE_CONST = 'Exchange Value';
    public static final String OTHER_DISCOUNT_CONST = 'Other Discount';
    public static final String RURAL_OFFER_CONST = 'Rural Offers';
    public static final String EXCH_MODEL = 'Exchange_Model__c';
    public static final String EXCH_FUEL_TYPE = 'Exchange_Fuel_Type__c';
    public static final String FOR_CODE = 'For_Code__c';
    public static final String REGION_CODE = 'Region_Code__c';
    public static final String OTHER_VALUE = 'OTHERS';
    
    
    
    
    public static final String OTH_DISC_CONST = 'Other Discounts';
    public static final String ROAD_TAX_CONST = 'Road Tax';
    public static final String BTN_LABEL_CONST = 'Save & Send';
    public static final String BCR_CONST = 'BCR';
    public static final String BCR_SENT = 'Y';
    
    public static final String OTHER_CHARGES_CONST = 'Other Charges';
    
    /*
     * Below contants are used in TestDriveFunctionality Class
     * */
    public static final String TESTDRIVE_RECORDTYPE = 'Test Drive'; 
    public static final String TESTDRIVE_DEFAULT_STATUS = 'RESERVED';
    public static final String TD_RESCHEDULE = 'TD Reschedule';
    public static final String TD_PRODUCT_VARIANT_RECORDTYPE= 'Variants';


    /*
    * Below contants are used in Account Trigger Handler
    **/
    public static final String SVOCID_CONST = 'SVOCID'; 
    public static final String TIMESTAMP_CONST = 'ModifedTimeStamp';
    public static final String COUNTRY_CODE = '91';
    public static final String DEALER_ADMIN = 'Dealer Admin';
    public static final String EDIT_ACCESS = 'Edit'; 
    public static final String ACCOUNT_OBJ = 'Account';
    public static final String SPOC_FIELDS = 'spoc';
    public static final String BUSINESS_HRS = 'business_hours__c';
    public static final String SVOC_LSTMODIFIED = 'lastmodified_svoc_time_stamp__c';
    public static final String PERMISSION_SET_NAME = 'Dealer Manage SPOC';
    public static final String ERROR_MSG = 'Dealer admin is allowed to update only SPOC and business hours fields';

    /*
    * Below contants are used in Delivery Checklist pdf
    **/
    public static final String DELIVERY_PAGE_CONST = 'DeliveryChecklistPDF';
    public static final String FILE_NAME_CONST = 'Delivery Checklist';  
    public static final String FIELD_CONST = 'Delivery_Checklist_Time__c'; 
    public static final String DELIVERY_CONST = 'Delivery';
    
    public static final String BLANK_SPACE = ' ';
    public static final String OPEN_BRACKET = '(';
    public static final String CLOSE_BRACKET = ')';
    public static final String NEWCAR_ENQ  = 'Car';
    public static final String ACCESSORIES_ENQ  = 'MSGA';
    
     /*
    *Added By-: NISHANT 
    * Below contants are used in Task Trigger Handler Class
    **/
    public static final String PROFILE_SYSTEM_ADMIN= 'System Administrator';
    public static final String PROFILE_INTEGRATION_USER= 'Integrations';
    
    
    /*
    * Below contants are used in Delivery Checklist pdf
    **/
    public static final String CLOSED_FOLLOWUP_APIKEY= 'EnquirynumberFollowupsList';
    
    /*
    * Below contants are used in customer vehicle history
    **/
    public static final String CUSTOMER_VEHICLE_HISTORY= 'Car_Details';
    /*
    * Below contant IS used in UserTriggerHandler
    **/
    public static final string ASYNC_APEX_BATCH= 'MapProfileToGroupBatch';
    public static final string ASYNC_APEX_BATCH1= 'inActiveTVEvaluator';
    public static final Set<String> TSM_RURAL_DESIGNATION = new Set<String> { 'RCS', 'RTL' };
    public static final Set<String> TSM_MGA_DESIGNATION = new Set<String> { 'ACM', 'MSE', 'SMA', 'SSA' };
    public static final Set<String> TSM_ISL_DESIGNATION = new Set<String> { 'CSE', 'CTL', 'NCM', 'NSC' };
     
    /*
    * Below contants are used in Opportunity Trigger Handler
    **/
    public static final string ACCOUNT_MASTERLABEL= 'AccountFields';


    /*
    * Below contants are used in Escalation Service Class
    **/
    public static final string ESCALATION_MC_TYPE= 'Escalation'; 
    public static final string DEALER_ENQUIRY= 'Dealer'; 
    public static final string MARUTI_ENQUIRY= 'Maruti'; 
    public static final string FIRST_LEVEL_ESCALATION= 'Level 1'; 
    public static final string DSE_TYPE_ESCALATION= 'DSE Allocation Time'; 
    public static final string FOLLOWUP_ESCALATION= 'Last Follow Up Update Time'; 
    public static final string FOLLOWUP_CONST= 'Follow Up'; 
    public static final string SE_DESIGNATION= 'SAE'; 
    
    public static final string LEVEL_2= 'Level 2'; 
    public static final string LEVEL_3= 'Level 3'; 
    public static final string LEVEL_4= 'Level 4'; 
    public static final string LEVEL_5= 'Level 5'; 
    public static final String ESCALATION_TIME = 'Time_for_Next_Escalation__c';
    
    
    //Below contents are used in DefaultProductCreationScript class
    public static final String FUEL_TYPE = 'Petrol';
    public static final String CHANNEL_TYPE= 'EXC';
    public static final DATE START_DATE = System.today();
    public static final DATE END_DATE = System.today();
    public static final String MODEL = 'Nexa';
    
    
    //Below contents are used in DefaultProductCreationScript
    public static final map<string,Integer> FromAgeMap = new map<string,Integer>{'A'=>0,'B'=>1,'C'=>2,'D'=>3};
    public static final map<string,Integer> ToAgeMap = new map<string,Integer>{'A'=>1,'B'=>2,'C'=>3,'D'=>100};
    public static final decimal OFFER_DISCOUNT_AMT = 100000.00;
    public static final decimal ACCESSORIES_DISCOUNT_AMT = 100000.00;
    public static final String QUESTION = 'How was your experience of Test Drive';
    public static final String RESPONSE = 'No';
    public static final String SURVEY_NAME = 'Test Drive Feedback'; 
    
    //Below contents are used in Task Trigger Handler
    public static final String BANK_APPOINTMENT = 'Bank_Appointment'; 
    Public static final String SEND_BROCHURE = 'Brochure_Request';
    public static final String SEND_BROCHURE_METADATA = 'Send Brochure';
    
    //Below Contents are used in UserTrigger Handler
    public static final String USER_OBJECT = 'User';
    
    //used in SFMC Real Time API Integration class
    public static final String SUBSCRIBER_KEY= 'TEST-SUB-001';
    
    public static final String Post_Booking_Feedback = 'postBookingFeedback';
    
    public static final String SHOWROOM_WELCOME = 'Showroom Welcome';
    
}