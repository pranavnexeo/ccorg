public with sharing class CISRelationships_Functions {
    public static final String PRSPCT = 'Prospect';
    public static final String SHIPTO = 'Ship To';
    public static final String SOLDTO = 'Sold To';
    public static final String CHERKY = 'Corp Acct';
    public static final String DELIM = ':';
    public static final String NEXEO_DC = '30';
//    public static final String NEXEO_G2 = 'G2';
    public static final List<String> ACCOUNT_TYPES = new List<String>{CHERKY, SOLDTO, SHIPTO};
    
    private static final Integer MAX_RECS = 1000;
    
   @TestVisible private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'CISRelationships_Functions : ' + s);
    }
    
    public static String getDefaultPaymentTerms (Id accountId){
        List <Account> acc = [Select SAP_Payment_Terms__c from Account where Id = :accountId];
        Id returnedID;
        
        if(acc[0].SAP_Payment_Terms__c==null)
        {
            returnedID=Lookup_Related_Sold_To(accountId);
            if(returnedID==null)
            return('');
            else
            return returnedID;
        }
        else
        return (acc[0].SAP_Payment_Terms__c);
       
    }
    
    // Map<Id, Map<PartnerType, List<Id>>>
    public static Map<Id, Map<String, List<Id>>> getPartnerIds(Set<Id> accountIds) {
        Map<Id, Map<String, List<Id>>> amap = getCHerkyPartnerIds(accountIds);
        if (amap == null || amap.isEmpty()) {
            amap = getPartnerIdMap(accountIds);
        }
        return amap;
    }
    
   @TestVisible private static Map<Id, Map<String, List<Id>>> getCHerkyPartnerIds(Set<Id> cherkyIds) {
        Map<Id, Map<String, List<Id>>> amap = new Map<Id, Map<String, List<Id>>>();
        Set<Id> accountIds = new Set<Id>();
        try {
            for (Account a : [select Id, AccountNumber from Account where ParentId in :cherkyIds]) {
                if (a.AccountNumber != null && !a.AccountNumber.startswith('P')) {accountIds.add(a.Id);}
            }
            if (!accountIds.isEmpty()) {amap = getPartnerIdMap(accountIds);}
        } catch(Exception e) {}
        return amap;
    }

    // Map<Id, Map<PartnerType, List<Id>>>
   @TestVisible private static Map<Id, Map<String, List<Id>>> getPartnerIdMap(Set<Id> accountIds) {
        Map<Id, Map<String, List<Id>>> amap = new Map<Id, Map<String, List<Id>>>();
        Map<String, List<Id>> smap = new Map<String, List<Id>>();
        Map<String, List<Id>> tmap = new Map<String, List<Id>>();
        Map<Id, Map<String, Set<String>>> pnmap = new Map<Id, Map<String, Set<String>>>();
        Map<String, Set<String>> ptmap = new Map<String, Set<String>>();
        Set<String> cnset = new Set<String>();
        //debug('getPartnerIdMap : ' + accountIds);
        for (CISRelationships__c cr : [select Customer_Number__c,
                                              Customer_Type__c,
                                              Ext_Unique_ID_c__c,
                                              Source_Customer__c,
                                              Source_Customer_AccountNumber__c,
                                              Source_Customer_ParentId__c,
                                              Source_Customer_SAP_Dist_Channel__c,
                                              Source_Customer_SAP_Division_Code__c,
                                              Source_Customer_SAP_Partner_Functions__c,
                                              Source_Customer_SAP_Sales_Org__c,
                                              Target_Customer__c,
                                              Target_Customer_AccountNumber__c,
                                              Target_Customer_ParentId__c,
                                              Target_Customer_SAP_Dist_Channel__c,
                                              Target_Customer_SAP_Division_Code__c,
                                              Target_Customer_SAP_Sales_Org__c
                                         from CISRelationships__c
                                        where Customer_Type__c in :ACCOUNT_TYPES
                                          and (Source_Customer__c in :accountIds or
                                               Target_Customer__c in :accountIds)
                                     order by Source_Customer_AccountNumber__c,
                                              Target_Customer_AccountNumber__c
                                      ]) {
            //debug('getPartnerIdMap : ' + cr);

            setPartnerNums(cr, cnset, pnmap, ptmap, cr.Source_Customer__c);
            setPartnerNums(cr, cnset, pnmap, ptmap, cr.Target_Customer__c);
        }
        amap = getPartnerIdMap(cnset, pnmap);
        // Prospects
        Set<Id> pset = getProspectIds(accountIds);
        for (Id accId : accountIds) {
            if (!amap.containsKey(accId) && pset.contains(accId)) {
                smap = new Map<String, List<Id>>();
                setPartnerId(PRSPCT, accId, smap);
                amap.put(accId, smap);
            }
        }
        return amap;
    }
    
    public static Map<String, Map<String, String>> Lookup_Related_Accounts(Set<String> accids) {

         Set<String> aids = new set<String>();
         aids.addall(accids);
           
         Map<String, Map<String, String>> amap = new Map<String, Map<String, String>>();
         Set<String> corpIds = new set<String>();
         Set<String> SoldTos = new set<String>();
         Set<String> ShipTos = new set<String>();
         Map<String, String> corpmap = new map<String, String>();
         Map<String, String> soldmap = new map<string, string>();
      
         system.debug('Start: ' + aids.size());
         for(Account a:[select id, parentid, SAP_Partner_Functions__c from Account
                           where id IN :aids
                           AND  SAP_Partner_Functions__c LIKE '%SOLD%'
                           AND (NOT Name like '%DO NOT USE%')])
         {
                SoldTos.add(a.id);
                SoldMap.put(a.id, a.id);
         }
         
         
         for(CISRelationships__c crs :[SELECT Customer_Type__c,
                          Source_Customer__c,
                          Source_Customer__r.parentid,
                          Target_Customer__c,
                          Target_Customer__r.parentid
                     FROM CISRelationships__c
                    WHERE Source_Customer__c IN :aids
                      AND Target_Customer__r.SAP_Partner_Functions__c LIKE '%Sold%'
                      AND (NOT Target_Customer__r.Name like '%DO NOT USE%')
                          
                ])         
        {   
            if(crs.Target_Customer__r.parentid != null)
            {   CorpIds.add(crs.Target_Customer__r.parentid);
                CorpMap.put(crs.Target_Customer__c, crs.target_customer__r.parentid);
                aids.add(crs.target_customer__r.parentid);
            }
            if(crs.source_Customer__r.parentid != null)
            {   CorpIds.add(crs.source_Customer__r.parentid);
                CorpMap.put(crs.source_Customer__c, crs.source_customer__r.parentid);
                aids.add(crs.source_customer__r.parentid);
            }
            if(CRS.target_customer__c  != null)
            {   aids.add(crs.target_customer__c);
                SoldTos.add(crs.Target_customer__c);
                SoldMap.put(crs.source_customer__c, crs.target_customer__c);
            }
        }
        
         
         system.debug('After SoldTos: ' + aids.size() + 'CorpIds: ' + corpIds.size());
         for(Account a:[select id, parentid, SAP_Partner_functions__c from Account where ((parentid IN :corpIds) or (parentid IN :aids)) and SAP_Partner_Functions__c != '' AND (NOT Name like '%DO NOT USE%') LIMIT 5000 ])
         {
           aids.add(a.id);
           corpIds.add(a.parentid);
           if(a.SAP_partner_functions__c.contains('Sold'))
           {     SoldTos.add(a.id);
                 corpmap.put(a.id, a.parentid);
           }
                
         }
         
         system.debug('After Corporate: ' + aids.size() + 'CorpIds: ' + corpIds.size());
         for(CISRelationships__c crs :[SELECT Customer_Type__c,
                          Source_Customer__c,
                          Source_Customer__r.parentId,
                          Target_Customer__c,
                          Target_Customer__r.parentid
                     FROM CISRelationships__c
                   WHERE Source_Customer__c IN :SoldTos                   
                        AND Customer_Type__c = :SHIPTO                   
                        
                                       AND (NOT Target_Customer__r.Name like '%DO NOT USE%')
                ])
        {   
            if(crs.Target_customer__c != null)
            {
              ShipTos.add(crs.Target_customer__c);
              SoldTos.add(crs.Source_customer__c);
              SoldMap.put(crs.Target_customer__c, crs.Source_customer__c);
            }
        
              
            if(crs.Target_Customer__r.parentid != null)
            {   CorpIds.add(crs.Target_Customer__r.parentid);
                CorpMap.put(crs.Target_Customer__c, crs.target_customer__r.parentid);
            }
            if(crs.Source_Customer__r.parentid != null)
            {   CorpIds.add(crs.Source_Customer__r.parentid);
                CorpMap.put(crs.Source_Customer__c, crs.SOurce_customer__r.parentid);
            }
              
        }  
        system.debug('End: ' + aids.size()+ 'CorpIds: ' + corpIds.size() + ' SoldTos: ' + SoldTos.size() + ' ShipTos: ' + shipTos.size());
        amap.put('CorpIds', corpmap);
        amap.put('SoldTos', SoldMap);
        return amap;           
    }
    
   @TestVisible private static Set<Id> getProspectIds(Set<Id> accountIds) {
        Set<Id> pset = new Set<Id>();
        try {
            for (Account a : [select Id, AccountNumber from Account where Id in :accountIds]) {
                if (a.AccountNumber.startsWith('P')) {pset.add(a.Id);}
            }
        } catch(Exception e) {}
        return pset;
    }

   @TestVisible private static void setPartnerId(String ptype, Id pid, Map<String, List<Id>> pmap) {
        Set<Id> pset = new Set<Id>();
        if (pmap.containsKey(ptype)) {pset.addAll(pmap.get(ptype));}
        pset.add(pid);
        List<Id> plist = new List<Id>();
        plist.addAll(pset);
        //debug('setPartnerId : ' + ptype + ':' + pid);
        pmap.put(ptype, plist);
    }

   @TestVisible private static void setPartnerNums(CISRelationships__c cr,
                                       Set<String> cnset,
                                       Map<Id, Map<String, Set<String>>> pnmap, 
                                       Map<String, Set<String>> ptmap, 
                                       String pid) {
        if (pid != null) {
            if (pnmap.containsKey(pid)) {
                ptmap = pnmap.get(pid);
            } else {
                ptmap = new Map<String, Set<String>>();
                pnmap.put(pid, ptmap);
            }
            Set<String> pnset; String ptype = cr.Customer_Type__c;
            if (ptmap.containsKey(ptype)) {
                pnset = ptmap.get(ptype);
            } else {
                pnset = new Set<String>();
                ptmap.put(ptype, pnset);
            }
            String s;
            if (cr.Source_Customer__c != null && cr.Source_Customer__c == pid) {
                s = getCustomerNumber(cr) + cr.Source_Customer_SAP_Sales_Org__c +
                    cr.Source_Customer_SAP_Dist_Channel__c + cr.Source_Customer_SAP_Division_Code__c;
//                if (cr.Source_Customer_SAP_Dist_Channel__c == NEXEO_DC) {s += NEXEO_G2;}
            } else 
            if (cr.Target_Customer__c != null && cr.Target_Customer__c == pid) {
                s = getCustomerNumber(cr) + cr.Target_Customer_SAP_Sales_Org__c +
                    cr.Target_Customer_SAP_Dist_Channel__c + cr.Target_Customer_SAP_Division_Code__c;
//                if (cr.Target_Customer_SAP_Dist_Channel__c == NEXEO_DC) {s += NEXEO_G2;}
            }
            cnset.add(s); pnset.add(s);
            //debug('setPartnerNums : ' + pid + ' : ' + ptype + ' : ' + s); 
        }
    }
    
   @TestVisible private static String getCustomerNumber(CISRelationships__c cr) {
        String s = cr.Customer_Number__c; Integer n;
//      if (s != null && s.endsWith(NEXEO_G2)) {n = s.length(); s = s.substring(0, n-2);}
        return s;
    }
    
   @TestVisible private static Map<Id, Map<String, List<Id>>> getPartnerIdMap(Set<String> cnset,Map<Id, Map<String, Set<String>>> pnmap) {
        Map<Id, Map<String, List<Id>>> pimap = new Map<Id, Map<String, List<Id>>>();
        if (pnmap.isEmpty() || cnset.isEmpty()) {return pimap;}
        Map<String, Id> anmap = new Map<String, Id>(); // account number, id
        Map<String, Id> apmap = new Map<String, Id>(); // account number, parentId
        setAccountNumberIdMaps(cnset, anmap, apmap);
        Map<String, Set<String>> ptnmap;
        Map<String, List<Id>> ptimap;
        Set<String> pnset; List<Id> plist, pilist; Set<Id> piset; Id acId, chId;
        for (Id pid : pnmap.keySet()) {
            ptnmap = pnmap.get(pid);
            ptimap = new Map<String, List<Id>>();
            piset = new Set<Id>();
            pilist = new List<Id>();
            for (String pt : ptnmap.keySet()) {
                pnset = ptnmap.get(pt);
                plist = new List<Id>();
                for (String pn : pnset) {
                    if (anmap.containsKey(pn)) {
                        acId = anmap.get(pn);
                        plist.add(acId);
                        if (apmap.containsKey(pn)) {
                            chId = apmap.get(pn);
                            //debug('getPartnerIdMap : ' + pid + ' : ' + pt + ' : ' + pn + ' : ' + chId);
                            piset.add(chId);
                        }
                    }
                }
                if (!plist.isEmpty()) {ptimap.put(pt, plist);}
            }
            if (!piset.isEmpty()) {
                pilist.addAll(piset);
                ptimap.put(CHERKY, pilist);
            }
            if (!ptimap.isEmpty()) {pimap.put(pid, ptimap);}
        }
        return pimap;
    }
    
   @TestVisible private static void setAccountNumberIdMaps(Set<String> cnset,
                                               Map<String, Id> anmap,
                                               Map<String, Id> apmap) {
        if (cnset == null || cnset.isEmpty()) {return;}
        for (Account a : [select Id, ParentId, Account_Number__c 
                            from Account
                           where Account_Number__c in :cnset]) {
            //debug('setAccountNumberIdMaps : ' + a.Account_Number__c + ' : ' + a.Id + ' : ' + a.ParentId);
            anmap.put(a.Account_Number__c, a.Id);
            if (a.ParentId != null) {
                apmap.put(a.Account_Number__c, a.ParentId);
            }
        }
    }
    
    public static Map<String, List<Id>> getPartnerIds(Id accountId) {
        Set<Id> accountIds = new Set<Id>{accountId};
        Map<Id, Map<String, List<Id>>> partnerIds = getPartnerIds(accountIds);
        if (partnerIds.containsKey(accountId)) {
            return partnerIds.get(accountId);
        }
        return null;
    }
    
    public static String getAccountType(Id accountId) {
        return '';
    }
    
    public static Id Lookup_Related_Sold_To(Id accountId) {
        id result;
        CISRelationships__c crs;
        try {       
            crs = [SELECT Customer_Type__c,
                          Source_Customer__c,
                          Target_Customer__c
                     FROM CISRelationships__c
                    WHERE Source_Customer__c = :accountId
                      AND Customer_Type__c = :SOLDTO
                     LIMIT 1
                ];
            } catch(Exception e) {}
        
        if (crs != null)
            {
            result = crs.Target_Customer__c;
            }
            
        return result;
    }
    
    public static Map<Id, Account> getAccountsMap(Map<Id, Map<String, List<Id>>> partnerIds) {
        Set<Id> accountIds = new Set<Id>();
        for (Map<String, List<Id>> m : partnerIds.values()) {
            for (List<Id> s : m.values()) {
                accountIds.addAll(s);
            }
        }
        Map<Id, Account> amap = new Map<Id, Account>();
        if (!accountIds.isEmpty()) {
            for (Account a : [
                select Id, Name, AccountNumber, Active_Account__c,
                       BillingCity, BillingCountry, BillingPostalCode, 
                       BillingState, BillingStreet, Inactive_Account__c, 
                       Owner.Id, Owner.Name, ParentId,
                       SAP_Account_Name_2__c, SAP_Country__c, 
                       SAP_Customer_Group_1_Desc__c, SAP_Customer_Group__c, 
                       SAP_Customer_Group_Desc__c, SAP_Customer_Number__c, 
                       SAP_DistChannel__c, SAP_Dist_Channel_Desc__c, 
                       SAP_DivisionCode__c, SAP_Division_Desc__c, 
                       SAP_Partner_Functions__c, SAP_Sales_District_Desc__c, 
                       SAP_Sales_Group_Desc__c, SAP_Sales_Office_Desc__c, 
                       SAP_Sales_Org__c, SAP_Sales_Org_Desc__c
                  from Account
                 where Id in :accountIds]) {
                amap.put(a.Id, a);
            }
        }
        return amap;
    }

}