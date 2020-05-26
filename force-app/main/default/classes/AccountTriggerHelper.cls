public class AccountTriggerHelper{     
    
    public static void ContactAddressInsert(set<id> accid){
       
        List<ccrz__E_ContactAddr__c> contAddrList = new List<ccrz__E_ContactAddr__c>();
        string temp;
        map<string,string> accMap_update = new map<string,string>();
        list<Account> updateAccList = new list<Account>();
        List<account> accList = new List<account>();
        list<ccrz__E_ContactAddr__c> contactAdrsList = new List<ccrz__E_ContactAddr__c >(); 
        
        if(accId.size()>0){    
            accList = [select id, BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry, Type,ccrz__UsedByCloudcraze__c from Account where id in : accId];
        }
        
        for(account a : accList){
            string BillingAdd = a.BillingStreet+ a.BillingCity + a.BillingState + a.BillingPostalCode + a.BillingCountry;
            if (BillingAdd != null){
                temp = a.id+'-Billing';
                ccrz__E_ContactAddr__c cab= new ccrz__E_ContactAddr__c(ccrz__AddressFirstline__c=a.BillingStreet, 
                                                        ccrz__City__c=a.BillingCity, 
                                                        ccrz__State__c=a.BillingState,
                                                        ccrz__StateISOCode__c=a.BillingState, 
                                                        ccrz__PostalCode__c=a.BillingPostalCode, 
                                                        ccrz__Country__c=a.BillingCountry, 
                                                        ccrz__CountryISOCode__c=a.BillingCountry, 
                                                        AccountId_Shipping__c=temp,
                                                        Storefront__c='mynexeo');
                contAddrList.add(cab);
            }
            string shippingAdd = a.ShippingStreet + a.ShippingCity + a.ShippingState + a.ShippingPostalCode + a.ShippingCountry;
            if (shippingAdd != null){
                temp = a.id+'-Shipping';
                ccrz__E_ContactAddr__c cas= new ccrz__E_ContactAddr__c(ccrz__AddressFirstline__c=a.shippingStreet, 
                                                        ccrz__City__c=a.ShippingCity, 
                                                        ccrz__State__c=a.ShippingState,
                                                        ccrz__StateISOCode__c=a.ShippingState, 
                                                        ccrz__PostalCode__c=a.ShippingPostalCode, 
                                                        ccrz__Country__c=a.ShippingCountry, 
                                                        ccrz__CountryISOCode__c=a.ShippingCountry, 
                                                        AccountId_Shipping__c=temp,
                                                        Storefront__c='mynexeo');
                contAddrList.add(cas);
            }
        }
        if(contAddrList.size()>0){            
        //upsert the CPI related Price List Item in CPI Price List
        List<Database.Upsertresult> upsertConAddrs =  new List<Database.Upsertresult>();
        upsertConAddrs = Database.upsert(contAddrList, ccrz__E_ContactAddr__c.AccountId_Shipping__c, false);
        
        //Error handling - Store the errors in case of failure
            if(upsertConAddrs.size()>0){
                for(integer i=0; i<upsertConAddrs.size();i++){
                    if (upsertConAddrs.get(i).isSuccess()){
                            upsertConAddrs.get(i).getId();
                        }
                        else if (!upsertConAddrs.get(i).isSuccess()){
                            // Upsert DML operation failed
                            Database.Error error = upsertConAddrs.get(i).getErrors().get(0);
                            String failedDML = error.getMessage();
                            contAddrList.get(i);//failed record from the list
                            system.debug('Failed Material Record Key : '+contAddrList.get(i).AccountId_Shipping__c+': '+failedDML);
            
                        }
                }
            }        
        }
  
    
    
    }


    public static void ToDeleteRelatedAccountGrp(set<id> acId, List<String> acCIS){
    
    set<id> accgrpid = new set<id>(); 
    List<ccrz__E_AccountGroupPriceList__c> accGrpPLList = new List<ccrz__E_AccountGroupPriceList__c>();
    List<ccrz__E_AccountGroup__c> AcGroups = new List<ccrz__E_AccountGroup__c>();
    List<ccrz__E_PriceList__c> PCList = new List<ccrz__E_PriceList__c>();
    
        if(acId.size()>0){
             AcGroups = [select id, name, ccrz__AccountGroupID__c from ccrz__E_AccountGroup__c where ccrz__AccountGroupID__c in : acId];     
         } 
         if(acCIS.size()>0){
             PCList = [select id, name from ccrz__E_PriceList__c where name in :acCIS];
         }
         
         if(AcGroups.size()>0){
             for(ccrz__E_AccountGroup__c acgrp : AcGroups)
             {
                 accgrpid.add(acgrp.id);
             
             }
         }
         
         if(accgrpid.size()>0)
         {
             accGrpPLList = [select id, ccrz__AccountGroup__c from ccrz__E_AccountGroupPriceList__c where ccrz__AccountGroup__c in: accgrpid];
         }
         
         if(accGrpPLList.size()>0)
         {
             delete accGrpPLList;
         }
         
         if(AcGroups.size()>0){
             delete AcGroups;
         }
         
         if(PCList.size()>0){
             delete PCList;
         } 
        
    
    
    }

}