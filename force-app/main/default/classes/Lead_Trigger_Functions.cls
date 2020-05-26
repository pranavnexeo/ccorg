public with sharing class Lead_Trigger_Functions {


    
    public static void processBeforeUpdate(List<Lead> alist) {
        Lead_Processing(alist); 
        Map<String, Schema.RecordTypeInfo> RTMap = getLeadRTMap();
        //CreateCSRequestFromLead(alist, RTMap);
    }
    
    public static void processBeforeInsert(List<Lead> alist) {
        Lead_Processing(alist); 
        Map<String, Schema.RecordTypeInfo> RTMap = getLeadRTMap();
        Lead_Process_Carbrite_WebtoLead(alist, RTMap);    
    }
    
    public static void processAfterUpdate(List<Lead> alist, Map<ID, Lead> oldmap)  {
        Map<String, Schema.RecordTypeInfo> RTMap = getLeadRTMap();
        LeadOnConvert(alist);
        CreateConsumptionFromLead(alist, RTMap, oldmap);
    }
    
    public static void processOnLeadConvert(List<Lead> alist)  {
    system.debug('-----rrrr----------'+alist);
        List<String> leadCompany = new List<String>();
        Map<id,id> leadcamp = new Map<id,id>();
        List<CampaignMember> cms = [Select leadId,CampaignId FROM CampaignMember WHERE Campaign.isActive=true AND LeadID IN: alist];
        system.debug('---------------'+cms);
            for(CampaignMember c:cms ){
                 leadcamp.put(c.leadId,c.CampaignId );
                  system.debug('---------------'+leadcamp);
            }
        Map<String, Schema.RecordTypeInfo> RTMap = getLeadRTMap();
        Map<String,String> leadStreet = new Map<String,String>();
        Map<String,String> leadCity = new Map<String,String>();
        Map<String,String> leadState = new Map<String,String>();
        Map<String,String> leadZip = new Map<String,String>();
        Map<String,String> leadCountry = new Map<String,String>();
        Map<String,id> leadCampaign = new Map<String,id>();
        
        for(Lead leadToConv: alist) {
        
            if(leadToConv.IsConverted){
            
                if(leadToConv.recordtypeid == RTMap.get('Distribution Plastics').getrecordtypeid()||leadToConv.recordtypeid == RTMap.get('ES Lead').getrecordtypeid()){
                    
                    leadCompany.add(leadToConv.Company);
                    leadStreet.put(leadToConv.Company,leadToConv.Street);
                    leadCity.put(leadToConv.Company,leadToConv.City);
                    leadState.put(leadToConv.Company,leadToConv.State);
                    leadZip.put(leadToConv.Company,leadToConv.PostalCode);
                    leadCountry.put(leadToConv.Company,leadToConv.Country);
                    leadCampaign.put(leadToConv.Company,leadcamp.get(leadToConv.id));
                     system.debug('---------------'+leadcamp.get(leadToConv.id));
                    
                    
                }
                else{
                    leadCompany.add(leadToConv.Company);
                }
           }
        }
        if(leadCompany.size()>0 && leadCompany!=null){
        List<Account> acc = [SELECT Id,SAP_Street__c,Name,Campaign__c FROM Account where Name in: leadCompany];
        
        
        for(Account account :acc ){
            account.SAP_Street__c = leadStreet.get(account.Name);
            account.SAP_City__c = leadCity.get(account.Name);
            account.SAP_State__c = leadState.get(account.Name);
            account.SAP_Zip_Code__c = leadZip.get(account.Name);
            account.SAP_Country__c = leadCountry.get(account.Name);
            account.Campaign__c = leadCampaign.get(account.Name);
            system.debug('---------------'+leadCampaign.get(account.Name));
                    }
       
        update acc;
        } 
    }
    
    
    
    private static Map<String, Schema.RecordTypeInfo> getLeadRTMap(){
        return Lead.sObjectType.getDescribe().getRecordTypeInfosByName();
    }
/*
    private static Set<ID> getIDSet(List<Lead> alist)  {
      Set<ID> leadidset = new set<ID>();
      for(Lead l:alist){
         if(l.id != null){
         leadidset.add(l.id);}
      }
      return leadidset;  
    }

    private static void CreateCSRequestFromLead(List<Lead> alist, Map<String, Schema.RecordTypeInfo> RTMapLead){   
           
         List<Customer_Service_request__c> CSRs = new list<Customer_Service_Request__c>();
         Map<String, Schema.RecordTypeInfo> RTMapCSR = Customer_Service_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
         
           for(lead l:alist){
             if(l.status == 'Sent to Customer Service' && l.Customer_Service_Request__c == null){          
                 
                 Customer_Service_Request__c csr = new customer_service_request__c();
                 csr.recordtypeid = RTMapCSR.get('New Customer Service Request').getrecordtypeid();
                 
                   CSR.Commercial_Unit__C = l.Commercial_Unit__c;
                   CSR.Contact__c = l.Company +'\n';
                   CSR.Contact__c += l.firstname + ' ' + l.lastname +'\n';
                   if(l.phone != null){
                   CSR.Contact__c += 'Phone: ' + l.phone + '\n';
                   }
                   if(l.fax != null){
                     CSR.Contact__c += 'Fax: ' + l.fax + '\n';
                   }
                   if(l.street != null){
                     CSR.contact__c += l.street + '\n';
                   } 
                   if(l.city != null){
                     CSR.contact__c += l.city;
                   }
                   if(l.state != null){
                     CSR.Contact__C += ', ' + l.state + ' ';
                   }  
                   if(l.postalcode != null){
                     CSR.Contact__c += l.postalcode;
                   } 
                   if(l.Country != null){
                     CSR.Contact__C += '\n'+ l.Country;
                   }
                   
                   csr.subject__c = '';
                   if(l.Customer_number__c != null){
                   csr.subject__c += l.Customer_Number__c;}
                   if(l.Company != null){
                      if(l.Customer_Number__c != null){
                         csr.subject__c += ' - ';
                      }
                   csr.subject__c += l.company;}
                   csr.description__c = '';                    
                   if(l.Order_Number__c != null){
                   csr.description__c = 'Order Number: ' + l.order_number__c; }               
                   if(l.description != null){ csr.description__c += '\n\n' + 'Lead Description: ' + l.description;}
                   if(l.product__c != null){
                   csr.description__c += '\n\n' + 'Product: ' + l.Product__c; }
                   if(l.lead_Market__c != null){
                   csr.description__c += '\n\n' + 'Market: ' + l.lead_market__c; }
                   if(l.MSDS_Format__c != null){
                   csr.description__c += '\n\n' + 'MSDS Format: ' + l.MSDS_Format__c; }
                   if(l.Payment_Type__c != null){
                   csr.description__c += '\n\n' + 'Payment Type: ' + l.Payment_type__c; }
                   if(l.seminar_venue__c != null){
                   csr.description__c += '\n\n' + 'Seminar Venue: ' + l.seminar_venue__c; }
                   if(l.Seminar_Date__c != null){
                   csr.description__c += '\n\n' + 'Seminar Date: ' + l.Seminar_Date__c; }
                   if(l.Referer__c != null){
                   csr.description__c += '\n\n' + 'Referer: ' + l.referer__c;  }
                   if(l.Environment_Services__c != null && l.Environment_Services__c != '' && l.environment_services__c != 'null'){
                   csr.description__c += '\n\n' + 'Environment Services: ' + l.Environment_Services__c;  }
                   csr.status__c = 'New';
                   insert csr;
                   csrs.add(csr);
                   l.customer_service_request__c = csr.id;
                  
            
            }//end if
         }//end for
         
         if(csrs.size() != 0){
         Customer_Service_Request_Functions.sendCSRequestEmail(csrs);}

    }
    
    private static string addleadingzeros(String datain){
       String returnstring = '';
       returnstring = datain;
       for(integer i=returnstring.length(); i<10; i++){
          returnstring = '0' + returnstring;
       }
       return returnstring;
    }
 */
    
    
    private static void Lead_Process_Carbrite_WebtoLead(List<Lead> alist, Map<String, Schema.RecordTypeInfo> RTMap){
    

  String carbriteLeadRecordType = RTMap.get('Car Brite Web to Lead').getRecordTypeID();
    if (carbriteLeadRecordType == null || carbriteLeadRecordType == '') {return;}

  Map<String, Schema.RecordTypeInfo> AccountRTMap = Account.sObjectType.getDescribe().getRecordTypeInfosByName();
  String valvolineCustomerRecordType = AccountRTMap.get('Valvoline Customer').getRecordTypeID();
    if (valvolineCustomerRecordType == null || valvolineCustomerRecordType == '') {return;}

    Set<String> distributorAccountNumbers = new Set<String>();
    Set<String> carbriteTBMs = new Set<String>();
    Set<String> employeeIds = new Set<String>();
    for(Lead l : alist){
        if (l.RecordTypeId == carbriteLeadRecordType)
          {
           //distributorAccountNumbers.add(String_Functions.Right('0000000000' + l.Distributor_Account_Number__c,10));
           //carbriteTBMs.add(String_Functions.Right('0000000000' + l.car_brite_tbm__c,10));
           /*if (l.car_brite_tbm__c != null)
             {
             employeeIds.add(l.car_brite_tbm__c.toUpperCase());
             }*/
          }
       }

//s = s.toUpperCase();

    List<Account> distributorAccounts = [SELECT Id, SAP_Customer_Number__c FROM Account 
                                          WHERE SAP_Customer_Number__c IN :distributorAccountNumbers
                                            AND RecordTypeId = :valvolineCustomerRecordType
                                        ];

    List<User> TBMUsers = [SELECT Id, SAP_Cust_Num__c FROM User 
                            WHERE SAP_Cust_Num__c  IN :carbriteTBMs AND IsActive = true
                          ];

    List<User> TBMUsers_EmployeeId = [SELECT Id, Ashland_Employee_Number__c FROM User 
                                       WHERE Ashland_Employee_Number__c IN :employeeIds AND IsActive = true
                                     ];


                                        
  System.debug('distributorAccountNumbers = ' + distributorAccountNumbers);                                        
  System.debug('distributorAccounts = ' + distributorAccounts);                                        
  System.debug('carbriteTBMs = ' + carbriteTBMs);                                        
  System.debug('TBMUsers = ' + TBMUsers);                                        
  System.debug('TBMUsers_EmployeeId = ' + TBMUsers_EmployeeId);                                        
                                        
    Map<String,Id> distributorAccountMap = new Map<String,Id>();
    for(Account a: distributorAccounts) {distributorAccountMap.put(a.SAP_Customer_Number__c,a.Id);}
  System.debug('distributorAccountMap = ' + distributorAccountMap);                                        

    Map<String,Id> TBMUserMap = new Map<String,Id>();
    for(User u: TBMUsers) {TBMUserMap.put(u.SAP_Cust_Num__c,u.Id);}
  System.debug('TBMUserMap = ' + TBMUserMap);                                        

    Map<String,Id> TBMUserMap_EmployeeId = new Map<String,Id>();
    for(User u: TBMUsers_EmployeeId) {TBMUserMap_EmployeeId.put(u.Ashland_Employee_Number__c.toUpperCase(),u.Id);}
  System.debug('TBMUserMap_EmployeeId = ' + TBMUserMap_EmployeeId);                                        

    for(Lead l : alist)
     {
   if (l.RecordTypeId == carbriteLeadRecordType)
      {
      
      try {
         //l.Distributor_Account__c = distributorAccountMap.get(String_Functions.Right('0000000000' + l.Distributor_Account_Number__c,10));           
        }
        catch (Exception e) {System.debug('An Error occurred assigning the account: ' + e);}

      try {
         Id TBMUserId = TBMUserMap.get(String_Functions.Right('0000000000' ,10));//TBMUserMap.get(String_Functions.Right('0000000000' + l.car_brite_tbm__c,10));

       //System.debug('Searching TBMUserMap for /' + String_Functions.Right('0000000000' + l.car_brite_tbm__c,10) + '/ = ' + TBMUserId);

         if(TBMUserId == null) 
           {
           //TBMUserId = TBMUserMap_EmployeeId.get(l.car_brite_tbm__c.toUpperCase());
          //System.debug('Searching TBMUserMap_EmployeeId for /' + l.car_brite_tbm__c + '/ = ' + TBMUserId);
           }            

         if(TBMUserId != null) 
           {
           System.debug('TBMUserId = ' + TBMUserId);
           System.debug(TBMUserId);
           l.OwnerId = TBMUserId;
           System.debug('OwnerId set Successfully!');
           }            
        }
        catch (Exception e) {System.debug('An Error occurred assigning the lead: ' + e);}

     System.debug('Lead Owner Id = ' + l.OwnerId);                                        
     }
     }  

    

}
    
    public static void CreateConsumptionFromLead(List<Lead> alist, Map<String, Schema.RecordTypeInfo> RTMapLead, Map<ID, Lead> OldMap){

         Map<String, Schema.RecordTypeInfo> RTMapCon = Consumption__c.sObjectType.getDescribe().getRecordTypeInfosByName();
      
      for(Lead l : alist){
        Lead oldLead = oldMap.get(l.Id);

        if(/*commented as part of Enh Res-3795
        l.RecordTypeID == RTMapLead.get('Distribution Chemicals').getRecordTypeId() ||*/
           l.RecordTypeID == RTMapLead.get('Distribution Plastics').getRecordTypeId() ||
           l.RecordTypeID == RTMapLead.get('Distribution Composites Lead').getRecordTypeId() )
        {
            if (oldLead.isConverted == false && l.isConverted == true) {
               Consumption__c newcon = createConsumptionFromLead(l, RTMapLead, RTMapCon); 
            }              
        }
      }
    }


    public static Consumption__c createConsumptionFromLead(Lead l,
                          Map<String, Schema.RecordTypeInfo> RTMapLead, 
                          Map<String, Schema.RecordTypeInfo> RTMapCon) {
               Consumption__c newcon = new Consumption__c(); 
               
            /* Chemicals */
            /* commented as part of Enh Res-3795 by Annes
                if(l.recordtypeID == RTMapLead.get('Distribution Chemicals').getRecordTypeId()){
                newcon.recordtypeID = RTMapCon.get('Distribution Chemicals').getRecordTypeId();
                newcon.Distribution_Volume__c = l.Distribution_Volume__c;
                newcon.Direct_Volume__c = l.Direct_Volume__c;
                } */
            
            /* Plastics NA*/
                if (l.recordtypeID == RTMapLead.get('Distribution Plastics').getRecordTypeId()){
                newcon.recordtypeID = RTMapCon.get('Distribution Plastics').getRecordTypeId();
                newcon.Distribution_Volume__c = l.Distribution_Volume__c;
                //newcon.Direct_Volume__c = l.Direct_Volume__c;
                }
                
            /* Plastics EMEA*/
                else if (l.recordtypeID == RTMapLead.get('Distribution Plastics EMEA').getRecordTypeId()){
                newcon.recordtypeID = RTMapCon.get('Distribution Plastics EMEA').getRecordTypeId();
                newcon.Distribution_Volume__c = l.Distribution_Volume__c;
                //newcon.Direct_Volume__c = l.Direct_Volume__c;
                }
            /* Composites */
                else if (l.recordtypeID == RTMapLead.get('Distribution Composites Lead').getRecordTypeId() || l.recordtypeID == RTMapLead.get('ES IRM Lead').getRecordTypeId() ){
                newcon.recordtypeID = RTMapCon.get('Distribution Composites').getRecordTypeId();
                Decimal d = 0;
                if(l.distribution_volume__c != null){d = d + l.distribution_volume__c;}
                /*if(l.direct_volume__c != null){d = d + l.direct_volume__c;}*/
                newcon.annual_volume__c = d;
                
                }
                
                newcon.created_from_Lead__c = true;
                newcon.Account_Name__c = l.convertedAccountID;
                newcon.SAP_Material__c = l.SAP_Material__c;
                newcon.base_code_other__c = l.base_code_other__c;
                newcon.marketing_code__c = l.marketing_code__c;
                 
                newcon.unit_of_measure__c = l.T_unit_of_measure__c;
 
                //newcon.Nexeo_Competitor__c = l.Nexeo_Competitor__c;
                //newcon.Distributor__c = l.Distributor__c;
                newcon.Current_Supplier_Producer__c = l.Approved_Product__c;
                newcon.description__c = '';
                
                //if(l.Top_Products__c != null){
                //newcon.description__c = 'Top Products:\n' + l.top_products__c + '\n\n'; }

                if(l.annual_volumes__c != null){
                    if(newcon.description__c != null){
                        newcon.description__c = newcon.description__c + l.annual_volumes__c + '\n\n';
                    } else {
                        newcon.description__c = l.annual_volumes__c + '\n\n'; }
                }
                 
                /*if(l.details__c != null){
                    if(newcon.description__c != null){
                        newcon.description__c = newcon.description__c + 'Details:\n' + l.details__c + '\n\n';
                    } else {
                        newcon.description__c = 'Details:\n' + l.details__c + '\n\n'; }
                }*/
                
                if(l.description != null){
                    if(newcon.description__c != null){
                        newcon.description__c = newcon.description__c + 'Description:\n' + l.description + '\n\n';
                    } else {
                        newcon.description__c = 'Description:\n' + l.description + '\n\n'; }
                }
                
                //newcon.Channel_to_Market__c = l.Channel_to_Market__c;

                system.debug('NewConAccont: ' + newcon.Account_Name__c);
                insert newcon;
                
             
                system.debug('NewConID: ' + newcon.id);
                
        return newcon;
    }
    
    
    public static void LeadOnConvert(List<Lead> alist){
   
    Set<ID> convertedAccountIDSet = new set<ID>();
    Set<ID> LeadIDset = new set<ID>();
    Map<String, Schema.RecordTypeInfo> CaseRTMap = Case.sObjectType.getDescribe().getRecordTypeInfosByName();
    Map<String, Schema.RecordTypeInfo> LeadRTMap = Lead.sObjectType.getDescribe().getRecordTypeInfosByName();
    Map<ID, Case> CaseMap = new Map<ID, Case>();
    

    for(lead l:alist){
      convertedAccountidset.add(l.convertedAccountID);
      LeadIDset.add(l.id);
    }

    List<Case> Cases = [select id, Related_Lead__c, Contactid from Case where Related_Lead__c in :LeadIDSet];
    Set<ID> ContactIDs = new set<ID>();
    List<Account> ConvertedAccountsList = [select id from Account where id in :convertedAccountIDset];
    Map<id, Account> amap = new map<id, Account>();
    

    for(Account a:ConvertedAccountsList){
     amap.put(a.id, a);
    }
    
    for(Case c:Cases){
     CaseMap.put(c.Related_Lead__c, c);
     ContactIDs.add(c.ContactID);
    }
    
    List<Contact> Contacts = [select id, accountid from Contact where id in :ContactIDs];
    Map<ID, Contact> ContactMap = new map<ID, Contact>();
    
    for(Contact c:Contacts){
      Contactmap.put(c.id, c);
    }
    
    for(lead l:alist){

       if(amap.containskey(l.convertedAccountID))
       {
        Account a = amap.get(l.convertedAccountID);
        a.lead_created_Date__c = l.createddate.date();
        update a;      
       }
       
       if(l.recordtypeid == LeadRTMap.get('Ashland Website Lead').getrecordtypeid() && l.isconverted == true){
             if(CaseMap.containskey(l.id)){
                 Case c = new Case();
                 c = CaseMap.get(l.id);
                 c.accountid = l.convertedaccountid;
                 c.contactid = l.convertedcontactid;
                 c.recordtypeid = CaseRTMap.get('Ashland Website Case with Account').getrecordtypeid();
                 update c;
            }//end if
       }//end if
    }//end for
    
     
  }
    
  @testvisible  private static void Lead_Processing(List<Lead> alist){
    
    //list to hold custom street field values
    List<String> addressLines;
    //String variable to have all the custom street values to one
    String oneStreetVal = '';
    //list to hold four custom field values separated from one standard street field
    List<String> street = new List<String>();
    
    //Processing all Leads
    for(Lead l : alist)
    {      
        //Condition to check custom address field values and add those values to standard address fields
        if(/*(l.Lead_Street__c != null || l.Lead_Street_1__c != null || l.Lead_Street_2__c != null || l.Lead_Street_3__c != null  || l.Lead_State__c != null || l.Lead_Zip_Code__c != null || l.Lead_Country__c != null) && */(!Trigger.IsUpdate))
        {
            //Adding custom street field values to list
            addressLines = new List<String>();
            /*addressLines.add(l.Lead_Street__c);
            addressLines.add(l.Lead_Street_1__c);
            addressLines.add(l.Lead_Street_2__c);
            addressLines.add(l.Lead_Street_3__c);*/
            oneStreetVal = Address_Functions.convert4LineAddressto1(addressLines);
            
            //Copying custom address field values to standard address fields
            l.Street = oneStreetVal;
            //l.City = l.Lead_City__c;
            //l.State = l.Lead_State__c;
            //l.PostalCode = l.Lead_Zip_Code__c;
            //l.Country = l.Lead_Country__c;
        }
       else 
        {
            //Separating one standard street field value into four custom street field values and copying the values into lead custom street fields
           /*street = Address_Functions.convert1LineAddressto4(l.Street);
            if(street.size()>0) l.Lead_Street__c = street[0];
            else l.Lead_Street__c = '';
            if(street.size()>1) l.Lead_Street_1__c = street[1];
            else l.Lead_Street_1__c = '';
            if(street.size()>2) l.Lead_Street_2__c = street[2];
            else l.Lead_Street_2__c = '';
            if(street.size()>3) l.Lead_Street_3__c = street[3];
            else l.Lead_Street_3__c = '';
            
            //Copying other standard field values to custom address fields
            l.Lead_City__c = l.City;
            l.Lead_State__c = l.State;
            l.Lead_Zip_Code__c = l.PostalCode;
            l.Lead_Country__c = l.Country;  */          
        }  
      }
    }
}