/**
* @File Name          : LeadTrigger.cls
* @Description        : Lead Trigger
* @Author             : Mahith Madwesh
* @Group              : 
* @Last Modified By   : 
* @Last Modified On   : 
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author                 Modification
*==============================================================================
* 1.0         17/01/2020               Mahith Madwesh         Initial Version
*/
trigger LeadTrigger on Lead (after insert, before update) {
    new LeadTriggerHandler().run(); 
}