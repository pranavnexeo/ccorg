Public Class Price_Request_Email_Template{

public Id recordid{get; set;}
Public String AppComments{Get; Set;} 

Public Price_Request_Transaction__c trans = new Price_Request_Transaction__c();
Public List<Price_Request_Transaction__c> trans1 = new List<Price_Request_Transaction__c>();
List<String> sapPayer = new List<String>();
List<String> sapSoldToPayer = new List<String>();
Public List<SAP_Price_Support__c> priceSupports = new List<SAP_Price_Support__c>();
Public List<SAP_Price_Tier__c> Requested_Tiers = new List<SAP_Price_Tier__c>();
Public List<SAP_Price_Tier__c> Requested_History = new List<SAP_Price_Tier__c>();
Public List<SAP_Price_Tier__c> CSP_Tiers = new List<SAP_Price_Tier__c>();
Public List<SAP_Price_Tier__c> CSP_History = new List<SAP_Price_Tier__c>();
Public List<SAP_Price_Tier__c> Target_Tiers = new List<SAP_Price_Tier__c>();
Public List<SAP_Price_Tier__c> Target_History = new List<SAP_Price_Tier__c>();

Public List<SAP_Price_Tier__c> alternate_tiers = new List<SAP_Price_Tier__c>();

Public Price_Request_Transaction__c gettrans(){
trans = [select id, createddate,name, corporate_account__c, Corporate_Account__r.accountnumber, corporate_Account__r.name, corporate_account__r.sap_sales_org__c, corporate_account__r.SAP_DistChannel__c,
                                sold_to__c, Sold_To__r.accountnumber, Sold_To__r.name, sold_to__r.sap_sales_org__c, sold_to__r.SAP_DistChannel__c,
                                ship_to__c, ship_To__r.accountnumber, ship_To__r.name, ship_to__r.sap_sales_org__c, ship_to__r.SAP_DistChannel__c,
                                Requested_Price_Protection__c, Requested_Drum_Deposit__c, sap_material__r.name, Requested_Effective_Date__c, Requested_Expiration_Date__c, Approval_Rejection_Comments__c,
                                Material_Cost__c, Variable_Warehouse__c, Variable_Delivery__c, CM_Value__c, Unit_Contribution_Margin__c, Unit_Material_Cost__c, Unit_Warehouse_Charge__c, Unit_Freight_Charge__c   
                                from price_request_transaction__c where id = :recordid limit 1];

return trans;
}


Public List<SAP_Price_Support__c> getPriceSupports(){
    
    

        trans1 = [select id,account_material__r.material_base__c, createddate,name, corporate_account__c, Corporate_Account__r.accountnumber, corporate_Account__r.name, corporate_account__r.sap_sales_org__c, corporate_account__r.SAP_DistChannel__c,
                                    sold_to__c, ship_to__r.SAP_DivisionCode__c,ship_to__r.SAP_ShippingPlant__c,Sold_To__r.accountnumber, ship_to__r.SAP_Payer_Account_Id__c,ship_to__r.SAP_Sold_To_Account_Id__c,Base_Code__c,Sold_To__r.name, sold_to__r.sap_sales_org__c, sold_to__r.SAP_DistChannel__c,
                                    ship_to__c, ship_To__r.accountnumber, ship_To__r.name, ship_to__r.sap_sales_org__c, ship_to__r.SAP_DistChannel__c,
                                    Requested_Price_Protection__c, Requested_Drum_Deposit__c, sap_material__r.name, Requested_Effective_Date__c, Requested_Expiration_Date__c, Approval_Rejection_Comments__c, prospect_material__c 
                                    from price_request_transaction__c where id = :recordid limit 1];
        
        if(trans1.size() > 0){
            if(trans1[0].ship_to__r.SAP_Payer_Account_Id__c != '' && trans1[0].ship_to__r.SAP_Payer_Account_Id__c != null)
                sapPayer = (trans1[0].ship_to__r.SAP_Payer_Account_Id__c).split(',');
        
            String PlantDiv = trans1[0].ship_to__r.SAP_ShippingPlant__c + trans1[0].ship_to__r.SAP_DivisionCode__c ;
            String region = '';
            List <SAP_Plant_Region__c> PlantRegion = [Select Id,Division_Code__c,Plant_Division__c, SAP_Plant__r.Plant_Code__c, Region__r.Region_Code__c, Region__r.Region_Description__c  from SAP_Plant_Region__c where Plant_Division__c  =:PlantDiv];
            if(PlantRegion.size()>0)
                region = PlantRegion[0].Region__r.Region_Code__c;
            
            List<Account> soldToAcctList = [select SAP_Payer_Account_Id__c from account where Id =: trans1[0].ship_to__r.SAP_Sold_To_Account_Id__c];
            if(soldToAcctList.size()>0)
                if(soldToAcctList[0].SAP_Payer_Account_Id__c != '' && soldToAcctList[0].SAP_Payer_Account_Id__c != null)
                    sapSoldToPayer = (soldToAcctList[0].SAP_Payer_Account_Id__c).split(',');
            if(!trans1[0].prospect_material__c)
                priceSupports = [select id,Supplier_Supported_Price__c,X1st_Discount_Sell__c,Region_Code__c,
                                Effective_Date__c ,Expiration_Date__c , name,Agreement_Number__c,Supplier_Name__c,
                                Supplier_Number__c from SAP_Price_Support__c where 
                                     ((Customer_Name__c =: trans1[0].ship_to__c And Material_Buying__c =: trans1[0].sap_material__c)  
                                     OR (Customer_Name__c =: trans1[0].ship_to__r.SAP_Sold_To_Account_Id__c And Material_Buying__c =: trans1[0].sap_material__c) 
                                     OR (Customer_Name__c IN: sapSoldToPayer And Material_Buying__c =: trans1[0].sap_material__c and(region_code__c = 'ALL' OR region_code__c =:region)) 
                                     OR (Customer_Name__c IN :sapPayer And Material_Buying__c =: trans1[0].sap_material__c and(region_code__c = 'ALL' OR region_code__c =:region) ) 
                                     OR (Customer_Name__c =: trans1[0].ship_to__c And Base_Material_Code_Buying__c =: trans1[0].account_material__r.material_base__c )  
                                     OR (Customer_Name__c =: trans1[0].ship_to__r.SAP_Sold_To_Account_Id__c And Base_Material_Code_Buying__c =: trans1[0].account_material__r.material_base__c ) 
                                     OR (Customer_Name__c IN: sapSoldToPayer And Base_Material_Code_Buying__c =: trans1[0].account_material__r.material_base__c  and(region_code__c = 'ALL' OR region_code__c =:region)) 
                                     OR (Customer_Name__c IN :sapPayer And Base_Material_Code_Buying__c =: trans1[0].account_material__r.material_base__c and(region_code__c = 'ALL' OR region_code__c =:region) ))
                                     and Effective_Date__c <=: trans1[0].Requested_Effective_Date__c and 
                                     (Expiration_Date__c >=: trans1[0].Requested_Effective_Date__c OR Expiration_Date__c = null) ];
                                 
         }  
        
        
    
    return priceSupports;
}

Public List<SAP_Price_Tier__c> getRequested_Tiers(){
system.debug('recordid: ' + recordid);
Requested_Tiers = [select id,createddate, name, sap_price__r.type__c, sap_price__c, Drum_Deposit_Code__c, CurrencyIsoCode, Condition_Number__c, effective_date__c, expiration_date__c, 
                                     price__c, price_protection_code__c, price_protection_desc__c, price_unit__c, price_uom__c, target_tier_price__c, target_tier_price_Unit__c,
                                     target_tier_Price_uom__c, tpi__c, volume__c, volume_uom__c,exception_1_price__c, Exception_2_Price__c, exception_1_percent__c, exception_2_percent__c 
                                     from SAP_Price_Tier__c where sap_price__r.price_request_Transaction__c = :recordid and SAP_Price__r.type__c = 'Requested' ORDER BY effective_date__c ASC, volume__c ASC];

return requested_tiers;
}

Public List<SAP_Price_Tier__c> getRequested_History(){
system.debug('recordid: ' + recordid);
Requested_Tiers = [select id,createddate, name, sap_price__r.type__c, sap_price__c, Drum_Deposit_Code__c, CurrencyIsoCode, Condition_Number__c, effective_date__c, expiration_date__c,
                                     price__c, price_protection_code__c, price_protection_desc__c, price_unit__c, price_uom__c, target_tier_price__c, target_tier_price_Unit__c,
                                     target_tier_Price_uom__c, tpi__c, volume__c, volume_uom__c,exception_1_price__c, Exception_2_Price__c, exception_1_percent__c, exception_2_percent__c 
                                     from SAP_Price_Tier__c where sap_price__r.price_request_Transaction__c =: recordid and SAP_Price__r.type__c = 'Requested History' ORDER BY effective_date__c ASC, volume__c ASC];

return requested_tiers;
}

Public List<SAP_Price_Tier__c> getCSP_Tiers(){
CSP_Tiers = [select id, createddate, name, sap_price__r.type__c, sap_price__c, Drum_Deposit_Code__c, CurrencyIsoCode, Condition_Number__c, effective_date__c, expiration_date__c, 
                                     price__c, price_protection_code__c, price_protection_desc__c, price_unit__c, price_uom__c, target_tier_price__c, target_tier_price_Unit__c,
                                     target_tier_Price_uom__c, tpi__c, volume__c, volume_uom__c,exception_1_price__c, Exception_2_Price__c, exception_1_percent__c, exception_2_percent__c 
                                     from SAP_Price_Tier__c where sap_price__r.price_request_transaction__c = :recordid and SAP_Price__r.type__c = 'CSP' ORDER BY effective_date__c ASC, volume__c ASC];
return CSP_Tiers;
}

Public List<SAP_Price_Tier__c> getCSP_History(){
system.debug('recordid: ' + recordid);
Requested_Tiers = [select id, createddate, name, sap_price__r.type__c, sap_price__c, Drum_Deposit_Code__c, CurrencyIsoCode, Condition_Number__c, effective_date__c, expiration_date__c, 
                                     price__c, price_protection_code__c, price_protection_desc__c, price_unit__c, price_uom__c, target_tier_price__c, target_tier_price_Unit__c,
                                     target_tier_Price_uom__c, tpi__c, volume__c, volume_uom__c,exception_1_price__c, Exception_2_Price__c, exception_1_percent__c, exception_2_percent__c 
                                     from SAP_Price_Tier__c where sap_price__r.price_request_Transaction__c = :recordid and SAP_Price__r.type__c = 'CSP History' ORDER BY effective_date__c ASC, volume__c ASC];

return requested_tiers;
}


Public List<SAP_Price_Tier__c> getTarget_Tiers(){
system.debug('recordid: ' + recordid);
Requested_Tiers = [select id, createddate, name, sap_price__r.type__c, sap_price__c, Drum_Deposit_Code__c, CurrencyIsoCode, Condition_Number__c, effective_date__c, expiration_date__c, 
                                     price__c, price_protection_code__c, price_protection_desc__c, price_unit__c, price_uom__c, target_tier_price__c, target_tier_price_Unit__c,
                                     target_tier_Price_uom__c, tpi__c, volume__c, volume_uom__c,exception_1_price__c, Exception_2_Price__c, exception_1_percent__c, exception_2_percent__c 
                                     from SAP_Price_Tier__c where sap_price__r.price_request_Transaction__c = :recordid and SAP_Price__r.type__c = 'Target' ORDER BY effective_date__c ASC, volume__c ASC];

return requested_tiers;
}


Public List<SAP_Price_Tier__c> getTarget_History(){
system.debug('recordid: ' + recordid);
Requested_Tiers = [select id, createddate, name, sap_price__r.type__c, sap_price__c, Drum_Deposit_Code__c, CurrencyIsoCode, Condition_Number__c, effective_date__c, expiration_date__c, 
                                     price__c, price_protection_code__c, price_protection_desc__c, price_unit__c, price_uom__c, target_tier_price__c, target_tier_price_Unit__c,
                                     target_tier_Price_uom__c, tpi__c, volume__c, volume_uom__c,exception_1_price__c, Exception_2_Price__c, exception_1_percent__c, exception_2_percent__c 
                                     from SAP_Price_Tier__c where sap_price__r.price_request_Transaction__c = :recordid and SAP_Price__r.type__c = 'Target History' ORDER BY effective_date__c ASC, volume__c ASC];

return requested_tiers;
}








Public List<SAP_Price_Tier__c> getAlternate_Tiers(){
system.debug('recordid: ' + recordid);
alternate_tiers = [select id, createddate, name, sap_price__r.type__c, sap_price__c, Drum_Deposit_Code__c, CurrencyIsoCode, Condition_Number__c, effective_date__c, expiration_date__c, 
                                     price__c, price_protection_code__c, price_protection_desc__c, price_unit__c, price_uom__c, target_tier_price__c, target_tier_price_Unit__c,
                                     target_tier_Price_uom__c, tpi__c, volume__c, volume_uom__c,exception_1_price__c, Exception_2_Price__c, exception_1_percent__c, 
                                     exception_2_percent__c, SAP_Price__r.Quantity__c, SAP_Price__r.Estimated_Order_Qty_UoM__c, sap_price__r.price_request_Transaction__r.Approval_Rejection_Comments__c
                                     from SAP_Price_Tier__c where sap_price__r.price_request_Transaction__c = :recordid and SAP_Price__r.type__c = 'Alternate' ORDER BY effective_date__c ASC, volume__c ASC];

for(SAP_Price_Tier__c p: alternate_tiers){
    AppComments = p.sap_price__r.price_request_Transaction__r.Approval_Rejection_Comments__c;
}
return alternate_tiers;
}
   
}