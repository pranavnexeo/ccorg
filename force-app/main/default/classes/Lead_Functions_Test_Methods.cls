@isTest
private class Lead_Functions_Test_Methods {

    static testMethod void myUnitTestFGG() {
   //try{
        //Test.startTest();
        /*Map<String, Schema.RecordTypeInfo> RTMap = Lead.sObjectType.getDescribe().getRecordTypeInfosByName();
        Lead newLead = new Lead();
       
        newLead.FirstName = 'Akansha';
        newLead.LastName = 'Gupta';   
        //-----
        Lead newLeadFGG = new Lead();
       
        newLeadFGG.FirstName = 'Francisco';
        newLeadFGG.LastName = 'Garcia';     
        newLeadFGG.Company='Freudenberg';
        newLeadFGG.RecordTypeId='012E0000000LBiNIAW';
        newLeadFGG.Top_Products__c = 'Test';
        newLeadFGG.Annual_Volumes__c = '524';
        newLeadFGG.Details__c = 'Test data';
        newLeadFGG.description = 'this is test data';
        //newLeadFGG.Lead_Street__c='Street';
        newLeadFGG.Car_Brite_TBM__c ='Cardata';
         
        newLeadFGG.Lead_Street_1__c='Street 1';
       
        newLeadFGG.Lead_Street_2__c='Street 2';
        newLeadFGG.Lead_Street_3__c='Street 3';
        newLeadFGG.Lead_City__c='Houston';
        newLeadFGG.Lead_State__c='TX';
        newLeadFGG.Lead_Zip_Code__c='77045';
        newLeadFGG.Lead_Country__c='USA';
        
        
        insert newLeadFGG;
                Lead newLeadEMEA= new Lead();
       
        newLeadEMEA.FirstName = 'Francisco';
        newLeadEMEA.LastName = 'Garcia';     
        newLeadEMEA.Company='Freudenberg';
        newLeadEMEA.RecordTypeId='012E0000000LBiO';
        
        List<Lead> lList= new List<Lead>();
        Database.LeadConvert lconvert = new database.LeadConvert();
        lconvert.setLeadId(newLeadFGG.id);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
             lconvert.setConvertedStatus('Fit for Business (Converted)');
             Database.LeadConvertResult lcresult = Database.convertLead(lconvert);
        lList.add(newLeadFGG);
        
        //l.Lead_Street__c != null || l.Lead_Street_1__c != null || l.Lead_Street_2__c != null || l.Lead_Street_3__c != null || l.Lead_City__c != null || l.Lead_State__c != null || l.Lead_Zip_Code__c != null || l.Lead_Country__c != null) && (!Trigger.IsUpdate))
        
        Lead_Trigger_Functions.Lead_Processing(lList);
        
    Lead_Trigger_Functions.processOnLeadConvert(lList);
        
        AshlandWebSiteLeadInsertResults result1 = Lead_Functions.createAshlandWebSiteLead(newLead);
        
        newLead.Company = 'ABC Company';
        AshlandWebSiteLeadInsertResults result2 = Lead_Functions.createAshlandWebSiteLead(newLead);
        
        System.assertEquals(result1.result,false);  
        System.assertEquals(result2.result,true);
        
        List<RecordType> RTList = [select id, name, BusinessProcessId from RecordType where name in :RTMap.keyset() and isactive = true];
        System.debug('FGG Num rows list'+RTList.size());
        List<Lead> LeadList = new List<Lead>();
        
        for(RecordType r:RTList)
        {
        Lead NewLead2 = NewLead.clone(false);
        newLead2.recordtypeid = RTMap.get(r.name).getrecordtypeid();   
        system.debug('RecordType: ' + r.name + ' - ' + RTMap.get(r.name).getrecordtypeid());
        LeadList.add(NewLead2);
        }
        
        Lead_Trigger_Functions.processBeforeInsert(LeadList);

        List<LeadStatus> convertedstatuses= [select id, MasterLabel from LeadStatus where IsConverted = true];
        insert LeadList;
        Map<ID, Lead> OldMap = new Map<ID, Lead>();
        Map<String, Schema.RecordTypeInfo> RTMapCon= new Map<String, Schema.RecordTypeInfo>();
        RTMapCon = Consumption__c.sObjectType.getDescribe().getRecordTypeInfosByName();
       Lead_Trigger_Functions.LeadOnConvert(leadlist);
       Try{
       Lead_Trigger_Functions.processBeforeUpdate(LeadList);
       Lead_Trigger_Functions.processAfterUpdate(LeadList,OldMap);
       Lead_Trigger_Functions.processOnLeadConvert(LeadList);
      
       }  
            catch(Exception e) { system.debug('Error: ' + e);}
         
        for(Lead l:leadlist){
          for(LeadStatus LS:convertedstatuses){
              try{    
             Database.LeadConvert lc = new database.LeadConvert();
             lc.setLeadId(l.id);
             lc.setConvertedStatus(LS.MasterLabel);
             Database.LeadConvertResult lcr = Database.convertLead(lc);
             
              Lead_Trigger_Functions.createConsumptionFromLead(LeadList, RTMapCon, OldMap);
             
                   }catch(exception ex){}
                }

//       Test.stopTest();
      //}catch(exception e){}
   }*/
    }
}
        /*static testMethod void myUnitTest() {
   //try{
        Test.startTest();
        Map<String, Schema.RecordTypeInfo> RTMap = Lead.sObjectType.getDescribe().getRecordTypeInfosByName();
        Lead newLead = new Lead();
        newLead.FirstName = 'Akansha';
        newLead.LastName = 'Gupta';       
        AshlandWebSiteLeadInsertResults result1 = Lead_Functions.createAshlandWebSiteLead(newLead);

        newLead.Company = 'ABC Company';
        AshlandWebSiteLeadInsertResults result2 = Lead_Functions.createAshlandWebSiteLead(newLead);
        
        System.assertEquals(result1.result,false);  
        System.assertEquals(result2.result,true);
        
        List<RecordType> RTList = [select id, name, BusinessProcessId from RecordType where name in :RTMap.keyset() and isactive = true];
        List<Lead> LeadList = new List<Lead>();
        
        for(RecordType r:RTList)
        {
        Lead NewLead2 = NewLead.clone(false);
        newLead2.recordtypeid = RTMap.get(r.name).getrecordtypeid();   
        system.debug('RecordType: ' + r.name + ' - ' + RTMap.get(r.name).getrecordtypeid());
        LeadList.add(NewLead2);
        }
        
        Lead_Trigger_Functions.processBeforeInsert(LeadList);

        List<LeadStatus> convertedstatuses= [select id, MasterLabel from LeadStatus where IsConverted = true];
        insert LeadList;
        Map<ID, Lead> OldMap = new Map<ID, Lead>();
        Map<String, Schema.RecordTypeInfo> RTMapCon = Consumption__c.sObjectType.getDescribe().getRecordTypeInfosByName();

       Lead_Trigger_Functions.LeadOnConvert(leadlist);
       Try{
       Lead_Trigger_Functions.processBeforeUpdate(LeadList);
       Lead_Trigger_Functions.processAfterUpdate(LeadList,OldMap);
       Lead_Trigger_Functions.processOnLeadConvert(LeadList);
      
       }  
            catch(Exception e) { system.debug('Error: ' + e);}
            
        for(Lead l:leadlist){
          for(LeadStatus LS:convertedstatuses){
           try{       
             Database.LeadConvert lc = new database.LeadConvert();
             lc.setLeadId(l.id);
             lc.setConvertedStatus(LS.MasterLabel);
             Database.LeadConvertResult lcr = Database.convertLead(lc);
             
             Lead_Trigger_Functions.createConsumptionFromLead(LeadList, RTMapCon, OldMap);
             Lead_Trigger_Functions.createConsumptionFromLead(l, RTMapCon, RTMap);
          }catch(exception e){}
          }
       }
       
       Test.stopTest();
      //}catch(exception e){}
   }
*/