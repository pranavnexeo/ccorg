trigger updatePriceProtectionChange on Price_Request_Transaction__c (before update, before insert) {

    List<String> PRTId = new List<String>();
    Map<Id, String> PRTandProtectionFlag= new  Map<Id, String> ();
    set<id> amids = new set<id>();
     
    for(Integer i=0; i< Trigger.new.size(); i++) 
    {
        
        if(trigger.isUpdate)
            PRTId.add(Trigger.new[i].id);
        if(Trigger.new[i].Account_Material__c != null)
            amids.add(Trigger.new[i].Account_Material__c);   
    }


Map<Id, Account_Material__c> amsmap = new Map<Id, Account_Material__c>();

if(trigger.isinsert)
  amsmap = new Map<Id, Account_material__c>([select id from Account_material__c where id in :amids]);

else //Retrieve the associated SAP Price Tier records where SAP Price Tier Type='Requested'
    for(SAP_Price_Tier__c spt:[select id, SAP_Price__c, tpi__c, sap_price__r.price_request_transaction__c, 
                                Price_Protection_Code__c, Price_Protection_Desc__c from SAP_Price_Tier__c 
                               where sap_price__r.type__c = 'CSP' 
                               and SAP_Price__r.price_request_Transaction__c IN :PRTId])
        {
          if(!PRTandProtectionFlag.containskey(spt.sap_price__r.price_request_Transaction__c))
            PRTandProtectionFlag.put(spt.sap_price__r.price_request_Transaction__c,spt.Price_Protection_Code__c+' - '+spt.Price_Protection_Desc__c);
          
       }    
     
     for(Integer i=0; i<Trigger.new.size(); i++)
     {
      if(amsmap.containskey(Trigger.new[i].Account_material__c) && trigger.isinsert)
         amsmap.get(Trigger.new[i].Account_material__c).Competitor__c = Trigger.new[i].Competitor__c;
      string ra = Trigger.new[i].id;
      string PRTPriceProt = Trigger.new[i].Requested_Price_Protection__c;
      system.debug('PRTandProtectionFlag.get(ra)'+PRTandProtectionFlag.get(ra));
      system.debug('PRTPriceProt'+PRTPriceProt);
      system.debug('Value is : '+!((PRTandProtectionFlag.get(ra) == '' || PRTandProtectionFlag.get(ra) == null) && PRTPriceProt == 'Z0 - No Protection'));
      
         if(trigger.isupdate)
            if(PRTandProtectionFlag.containskey(ra)){
            system.debug('****************1111111111');
              if((PRTPriceProt != PRTandProtectionFlag.get(ra)) && !((PRTandProtectionFlag.get(ra) == '' || PRTandProtectionFlag.get(ra) == null || PRTandProtectionFlag.get(ra) == 'null - null') && PRTPriceProt == 'Z0 - No Protection')){
                  system.debug('****************2');
                  Trigger.new[i].price_protection_changed__c = True;
              }else{
                  system.debug('****************3');
                  Trigger.new[i].price_protection_changed__c = False;
              }
            }else if(PRTPriceProt != 'Z0 - No Protection'){
                system.debug('****************4');
                Trigger.new[i].price_protection_changed__c = True;
            }else{
                system.debug('****************5');
                Trigger.new[i].price_protection_changed__c = False;
            }
     }
     
     update amsmap.values();
  
}