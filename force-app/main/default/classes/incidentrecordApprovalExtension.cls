global with sharing class incidentrecordApprovalExtension {
    public final Incident_Record__c incidentrec;
    public String RecodeId=ApexPages.currentPage().getParameters().get('id');
    private final Contact con;
    public incidentrecordApprovalExtension(ApexPages.StandardController controller) {
      this.incidentrec = (Incident_Record__c)controller.getRecord();
      //this.con=(Contact)controller.getRecord();
    } 
    public incidentrecordApprovalExtension(){
       // this.RecodeId=ApexPages.currentPage().getParameters().get('id');
    }
    /*public Id SiteInfoId;
    public void sitedata(){
    List<Incident_Record__c> incidentData = new List<Incident_Record__c>();
    incidentData = [SELECT Name,Nexeo_Location_Associated_with_incident__c,Type_of_Incident__c,Root_Cause_Analysis_Site_Info__c,DateRCADue__c FROM Incident_Record__c WHERE Id =:RecodeId];
        system.debug('incidentData '+incidentData[0].Nexeo_Location_Associated_with_incident__c);
        //SiteInfoId.add(incidentData[0].Nexeo_Location_Associated_with_incident__c); 
        SiteInfoId = incidentData[0].Nexeo_Location_Associated_with_incident__c;
        system.debug('SiteInfoId '+SiteInfoId);
    }
              public Decimal sum1=0.0;
    public String getchemical() {
        List<Spill_Release_Details__c> spill1 = new List<Spill_Release_Details__c>();        
        spill1 = [SELECT Incident_Record__r.Type_of_Incident__c ,Over_EHS_RQ_Limit__c FROM Spill_Release_Details__c where Incident_Record__c=:RecodeId ];
        for(integer i=0;i<spill1.size();i++){
            sum1=sum1+spill1[i].Over_EHS_RQ_Limit__c;
            }
           
           if(sum1 ==1.0)     
             return 'Yes' ; 
      
        return 'No';
    }
      public Decimal sum2=0.0;
    public String getflam() {
        List<Spill_Release_Details__c> spill2 = new List<Spill_Release_Details__c>();        
        spill2 = [SELECT Incident_Record__r.Type_of_Incident__c ,PoundsFlammable__c FROM Spill_Release_Details__c where Incident_Record__c=:RecodeId ];
        for(integer i=0;i<spill2.size();i++){
            sum2=sum2+spill2[i].PoundsFlammable__c;
            }
           
           if(sum2 ==1.0)     
             return 'Yes' ; 
      
        return 'No';
    }
    public Decimal sum=0.0;
    public String getACCrep() {
        List<Spill_Release_Details__c> spill6 = new List<Spill_Release_Details__c>();        
        spill6 = [SELECT Incident_Record__r.Type_of_Incident__c ,Frac_of_TQ_Released__c FROM Spill_Release_Details__c where Incident_Record__c=:RecodeId ];
        for(integer i=0;i<spill6.size();i++){
            sum=sum+spill6[i].Frac_of_TQ_Released__c;
            }
            for(integer i=0;i<spill6.size();i++){
           if(spill6[i].Incident_Record__r.Type_of_Incident__c.contains('Release/Spill')&& sum >=1.0)     
             return 'Yes' ; 
      }
        return 'No';
    }
        public Decimal sum4=0.0;
    public String getpoten() {
        List<Spill_Release_Details__c> spill3 = new List<Spill_Release_Details__c>();        
        spill3 = [SELECT Incident_Record__r.Type_of_Incident__c ,Frac_of_TQ_Released__c FROM Spill_Release_Details__c where Incident_Record__c=:RecodeId ];
        for(integer i=0;i<spill3.size();i++){
            sum4=sum4+spill3[i].Frac_of_TQ_Released__c;
            }
            
           if(sum4<=1&&sum4>3)     
             return 'Release between 1 and 3 times the TQ (L4)' ;
              if(sum4<=3&&sum4>9)     
             return 'Release between 3 and 9 times the TQ (L3)' ;
                if(sum4<=9&&sum4>20)     
             return 'Release between 9 and 20 times the TQ (L2)' ;
                if(sum4>20)     
             return 'Release greater than 20 times the TQ (L1).' ; 
      
        return null;
    }
    public Decimal sum5=0.0;
      public Integer getpoten1() {
        List<Spill_Release_Details__c> spill4 = new List<Spill_Release_Details__c>();        
        spill4 = [SELECT Incident_Record__r.Type_of_Incident__c ,Frac_of_TQ_Released__c FROM Spill_Release_Details__c where Incident_Record__c=:RecodeId ];
        for(integer i=0;i<spill4.size();i++){
            sum5=sum5+spill4[i].Frac_of_TQ_Released__c;
            }
            
           if(sum5<=1&&sum5>3)     
             return 1 ;
              if(sum4<=3&&sum4>9)     
             return 3 ;
                if(sum4<=9&&sum4>20)     
             return 9;
                if(sum4>20)     
             return 27 ; 
      
        return 0;
    }
*/
      public String getlevel() {
        List<Incident_Record__c> incidenttot1 = new List<Incident_Record__c>();
        incidenttot1 = [SELECT Safety_Human_Health__c,Fire_Explosion_Overpressure__c,Community_Environment_Impact__c FROM Incident_Record__c where ID =:RecodeId ];

            if (incidenttot1[0].Safety_Human_Health__c==27 || incidenttot1[0].Fire_Explosion_Overpressure__c==27 || incidenttot1[0].Community_Environment_Impact__c==27 )
            {return 'Level 1';}            
            else if (incidenttot1[0].Safety_Human_Health__c==9||incidenttot1[0].Fire_Explosion_Overpressure__c==9 || incidenttot1[0].Community_Environment_Impact__c==9 )
            {return 'Level 2';}       
            else if (incidenttot1[0].Safety_Human_Health__c==3 || incidenttot1[0].Fire_Explosion_Overpressure__c==3 || incidenttot1[0].Community_Environment_Impact__c==3 )
             {return 'Level 3';}
            else if (incidenttot1[0].Safety_Human_Health__c==1 || incidenttot1[0].Fire_Explosion_Overpressure__c==1 || incidenttot1[0].Community_Environment_Impact__c==1 )
            {return 'Level 4';}
            else
            return null;
    }
    
    public Decimal gettotal() {
        List<Incident_Record__c> incidenttot = new List<Incident_Record__c>();
        incidenttot = [SELECT ACC_PSI_Override__c,Safety_Human_Health__c,Fire_Explosion_Overpressure__c,Community_Environment_Impact__c FROM Incident_Record__c where ID =:RecodeId ];
        //for(integer i=0;i<incident1.size();i++){
            if (incidenttot[0].ACC_PSI_Override__c=='No'){
            Decimal j=incidenttot[0].Safety_Human_Health__c+incidenttot[0].Fire_Explosion_Overpressure__c+incidenttot[0].Community_Environment_Impact__c;
            return j;
            }else{
       // }
        return 0;}
    }
List<String> emailIds1 = new list<String>();
    public String getEHSManager() {
        List<Incident_Record__c> incidentData = new List<Incident_Record__c>();
        incidentData = [SELECT Name,Nexeo_Location_Associated_with_incident__c,Type_of_Incident__c,Root_Cause_Analysis_Site_Info__c,DateRCADue__c FROM Incident_Record__c WHERE Id =:RecodeId];
    
        List<Incident_Approver__c> incident1 = new List<Incident_Approver__c>();
        incident1 = [SELECT User_Email_Id__c FROM Incident_Approver__c where Site_Information__c =:incidentData[0].Nexeo_Location_Associated_with_incident__c And Division__c='EH&S Manager'];
        for(integer i=0;i<incident1.size();i++){
            emailIds1.add(incident1[i].User_Email_Id__c); 
        }
        return emailIds1+' ';
    }

List<String> emailIds2 = new list<String>();
         
    public String getEHSManagerBackups() {
    
        List<Incident_Record__c> incidentData = new List<Incident_Record__c>();
        incidentData = [SELECT Name,Nexeo_Location_Associated_with_incident__c,Type_of_Incident__c,Root_Cause_Analysis_Site_Info__c,DateRCADue__c FROM Incident_Record__c WHERE Id =:RecodeId];
        
        List<Incident_Approver__c> incident2 = new List<Incident_Approver__c>();
        incident2 = [SELECT User_Email_Id__c FROM Incident_Approver__c where Site_Information__c =:incidentData[0].Nexeo_Location_Associated_with_incident__c And Division__c='EH&S Manager Backups'];
        for(integer i=0;i<incident2.size();i++){
            emailIds2.add(incident2[i].User_Email_Id__c); 
        }
        return emailIds2+' ';
    }

List<String> emailIds3 = new list<String>();
    public String getPersonswhotranslate() {
    
        List<Incident_Record__c> incidentData = new List<Incident_Record__c>();
        incidentData = [SELECT Name,Nexeo_Location_Associated_with_incident__c,Type_of_Incident__c,Root_Cause_Analysis_Site_Info__c,DateRCADue__c FROM Incident_Record__c WHERE Id =:RecodeId];
        
        List<Incident_Approver__c> incident3 = new List<Incident_Approver__c>();
        incident3 = [SELECT User_Email_Id__c FROM Incident_Approver__c where Site_Information__c =:incidentData[0].Nexeo_Location_Associated_with_incident__c And Division__c='Persons who translate/provide follow-up information'];
        for(integer i=0;i<incident3.size();i++){
            emailIds3.add(incident3[i].User_Email_Id__c); 
        }
        return emailIds3+' ';
    }
    List<String> emailIds31 = new list<String>();
    public String getPersonswhotranslateName() {
    
        List<Incident_Record__c> incidentData = new List<Incident_Record__c>();
        incidentData = [SELECT Name,Nexeo_Location_Associated_with_incident__c,Type_of_Incident__c,Root_Cause_Analysis_Site_Info__c,DateRCADue__c FROM Incident_Record__c WHERE Id =:RecodeId];
        
        List<Incident_Approver__c> incident31 = new List<Incident_Approver__c>();
        incident31 = [SELECT Approver__r.Name FROM Incident_Approver__c where Site_Information__c =:incidentData[0].Nexeo_Location_Associated_with_incident__c And Division__c='Persons who translate/provide follow-up information'];
        for(integer i=0;i<incident31.size();i++){
            emailIds31.add(incident31[i].Approver__r.Name); 
        }
        return emailIds31+' ';
    }

List<String> emailIds4 = new list<String>();
    public String getinitiateReliabilityIncident() {
    
        List<Incident_Record__c> incidentData = new List<Incident_Record__c>();
        incidentData = [SELECT Name,Nexeo_Location_Associated_with_incident__c,Type_of_Incident__c,Root_Cause_Analysis_Site_Info__c,DateRCADue__c FROM Incident_Record__c WHERE Id =:RecodeId];
        
        List<Incident_Approver__c> incident4 = new List<Incident_Approver__c>();
        incident4 = [SELECT User_Email_Id__c FROM Incident_Approver__c where Site_Information__c =:incidentData[0].Nexeo_Location_Associated_with_incident__c And Division__c='Persons who can initiate a Reliability Incident'];
        for(integer i=0;i<incident4.size();i++){
            emailIds4.add(incident4[i].User_Email_Id__c); 
        }
        return emailIds4+' ';
    }

List<String> emailIds5 = new list<String>();
    public String getperformRootCauseAnalysis() {
    
        List<Incident_Record__c> incidentData = new List<Incident_Record__c>();
        incidentData = [SELECT Name,Nexeo_Location_Associated_with_incident__c,Type_of_Incident__c,Root_Cause_Analysis_Site_Info__c,DateRCADue__c FROM Incident_Record__c WHERE Id =:RecodeId];
        
        List<Incident_Approver__c> incident5 = new List<Incident_Approver__c>();
        incident5 = [SELECT User_Email_Id__c FROM Incident_Approver__c where Site_Information__c =:incidentData[0].Nexeo_Location_Associated_with_incident__c And Division__c='Persons who can perform Root Cause Analysis'];
        for(integer i=0;i<incident5.size();i++){
            emailIds5.add(incident5[i].User_Email_Id__c); 
        }
        return emailIds5+' ';
    }
    List<String> emailIds51 = new list<String>();
    public String getperformRootCauseAnalysisName() {
    
        List<Incident_Record__c> incidentData = new List<Incident_Record__c>();
        incidentData = [SELECT Name,Nexeo_Location_Associated_with_incident__c,Type_of_Incident__c,Root_Cause_Analysis_Site_Info__c,DateRCADue__c FROM Incident_Record__c WHERE Id =:RecodeId];
        
        List<Incident_Approver__c> incident51 = new List<Incident_Approver__c>();
        incident51 = [SELECT Approver__r.Name FROM Incident_Approver__c where Site_Information__c =:incidentData[0].Nexeo_Location_Associated_with_incident__c And Division__c='Persons who can perform Root Cause Analysis'];
        for(integer i=0;i<incident51.size();i++){
            emailIds51.add(incident51[i].Approver__r.Name); 
        }
        return emailIds51+' ';
    }

List<String> emailIds6 = new list<String>();
    public String getfinalizecloseincidents() {
    
        List<Incident_Record__c> incidentData = new List<Incident_Record__c>();
        incidentData = [SELECT Name,Nexeo_Location_Associated_with_incident__c,Type_of_Incident__c,Root_Cause_Analysis_Site_Info__c,DateRCADue__c FROM Incident_Record__c WHERE Id =:RecodeId];
        
        List<Incident_Approver__c> incident6 = new List<Incident_Approver__c>();
        incident6 = [SELECT User_Email_Id__c FROM Incident_Approver__c where Site_Information__c =:incidentData[0].Nexeo_Location_Associated_with_incident__c And Division__c='Persons who can finalize and/or close incidents'];
        for(integer i=0;i<incident6.size();i++){
            emailIds6.add(incident6[i].User_Email_Id__c); 
        }
        return emailIds6+' ';
    }
List<String> emailIds61 = new list<String>();
    public String getfinalizecloseincidentsName() {
    
        List<Incident_Record__c> incidentData = new List<Incident_Record__c>();
        incidentData = [SELECT Name,Nexeo_Location_Associated_with_incident__c,Type_of_Incident__c,Root_Cause_Analysis_Site_Info__c,DateRCADue__c FROM Incident_Record__c WHERE Id =:RecodeId];
        
        List<Incident_Approver__c> incident61 = new List<Incident_Approver__c>();
        incident61 = [SELECT Approver__r.Name FROM Incident_Approver__c where Site_Information__c =:incidentData[0].Nexeo_Location_Associated_with_incident__c And Division__c='Persons who can finalize and/or close incidents'];
        for(integer i=0;i<incident61.size();i++){
            emailIds61.add(incident61[i].Approver__r.Name); 
        }
        return emailIds61+' ';
    }
List<String> emailIds7 = new list<String>();
    public String getSiteDistribution() {
    
        List<Incident_Record__c> incidentData = new List<Incident_Record__c>();
        incidentData = [SELECT Name,Nexeo_Location_Associated_with_incident__c,Type_of_Incident__c,Root_Cause_Analysis_Site_Info__c,DateRCADue__c FROM Incident_Record__c WHERE Id =:RecodeId];
        
        List<Incident_Approver__c> incident7 = new List<Incident_Approver__c>();
        incident7 = [SELECT User_Email_Id__c FROM Incident_Approver__c where Site_Information__c =:incidentData[0].Nexeo_Location_Associated_with_incident__c And Division__c='Site Distribution'];
        for(integer i=0;i<incident7.size();i++){
            emailIds7.add(incident7[i].User_Email_Id__c); 
        }
        return emailIds7+' ';
    }
    
    public String toemailaddress{ get; set; }
   @RemoteAction 
   //public String Subject='GIR Incident Follow-up Information Entered'+ '{!Incident_Record__c.Name}';
     global static void getSendingEmail(String toemailaddress,String templateName, Id id) {
     String IncidentURL = URL.getSalesforceBaseUrl().toExternalForm() +'/' + id;
        String Subject,Body;
        List<Incident_Record__c> incidentData = new List<Incident_Record__c>();
        incidentData = [SELECT Name,Nexeo_Location_Associated_with_incident__r.Name,Type_of_Incident__c,Root_Cause_Analysis_Site_Info__c,DateRCADue__c FROM Incident_Record__c WHERE Id =:id];
        system.debug('name is '+incidentData[0].Name);
        system.debug('toemailaddress0 is : ' +toemailaddress); 
        if(templateName=='GIR_Incident_Follow_up_Information_Entered'){
        
        Subject='GIR Incident Follow-up Information Entered '+incidentData[0].Name;
        Body='This is to notify you the above incident has been updated. You will be informed again when the incident has been closed out. You may click on the link below to the Global Incident Reporting Tool to see any details. Thanks for your involvement in identifying and resolving Nexeo safety, health, environmental, and security incidents.\n'+IncidentURL+'\nNexeo HSSE Organization';
        
        }else if(templateName=='GIR_Notification_Conduct_Document_RCA'){
        
        Subject='GIR Notification : Conduct / Document RCA-'+incidentData[0].Nexeo_Location_Associated_with_incident__r.Name+','+incidentData[0].Type_of_Incident__c;
        Body='The site/sales region is performing a Root Cause Analysis (RCA) on the above incident. It is assigned to '+incidentData[0].Root_Cause_Analysis_Site_Info__c+' and should be conducted and documented in the Global Incident Reporting Tool by '+incidentData[0].DateRCADue__c+' \nThis is to notify you that you are responsible to make sure the RCA document and the resulting action items have been posted into the Global Incident Reporting tool (if by chance, the actions have all been completed, you may show that in lieu of entering completed actions).\nWhen the RCA is completed, please make sure you have documented it in the Final Report/Plan Approver Information section of the incident. ';
        
        }else if(templateName=='GIR_Notification_Root_Cause_Completed_Posted'){
        
        Subject='GIR Notification : Root Cause Completed/Posted'+incidentData[0].Nexeo_Location_Associated_with_incident__r.Name+','+incidentData[0].Type_of_Incident__c;
        Body='This is to notify you that the RCA for the above incident has been posted in the Global Incident Reporting Tool.\n '+IncidentURL+'\nYou may click on the link above to see the assessment, the causes, or other incident details';
        
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        EmailTemplate emailTemplate; 
        emailTemplate = [SELECT id FROM EmailTemplate WHERE developerName =:templateName];//'GIR_Incident_Follow_up_Information_Entered'];
        system.debug('toemailaddress is : ' +toemailaddress); 
        list<String> toemailaddresses = new list<String>();
        toemailaddresses.add(toemailaddress);
        mail.setSubject(Subject);
        mail.setPlainTextBody(Body);
        mail.setToAddresses(toemailaddresses); 
        mail.setTargetObjectId(UserInfo.getUserId()); 
        //mail.setWhatId('a4qL00000004C9X');
        mail.setSaveAsActivity(false); 
        //mail.setTemplateId(emailTemplate.id); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}