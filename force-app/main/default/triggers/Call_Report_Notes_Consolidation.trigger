trigger Call_Report_Notes_Consolidation on Opportunity_Call_Report__c (after insert, after update, after delete) {

 if (Trigger.isInsert || Trigger.isUpdate)
     {
         try{
             set<id> oppId = new set<id>();
             for(Opportunity_Call_Report__c cr : trigger.new){
                if(cr.Opportunity__c != null)
                oppId.add(cr.Opportunity__c);
              }
                List<opportunity> opp = [select id,name,All_Call_Report_Notes__c from Opportunity where id in : oppId];

                List<Opportunity_Call_Report__c> crn = new List<Opportunity_Call_Report__c>([select id, Opportunity__c,Call_Report_Number__c,Status_Update__c,CreatedDate from Opportunity_Call_Report__c where Opportunity__c in : oppId ORDER BY CreatedDate DESC]);
                system.debug('@@ crn '+crn);
                if(crn.size()>0){
                    for(opportunity opt: opp){
                        string Temp = '';
                        for(Opportunity_Call_Report__c c : crn){
                        if (c.Status_Update__c !='' && c.Status_Update__c!= null){
                            string t = c.Status_Update__c;
                          if(c.Opportunity__c == opt.id && (Temp + t.deleteWhitespace()).length() < 131071){
                              
                                Date myDate = date.newinstance(c.CreatedDate.year(), c.CreatedDate.month(), c.CreatedDate.day());
                                String x=myDate.format();
                                
                                Temp  = Temp + '`' + x + ': ' + t;
                               
                                System.debug('@@temp length '+Temp.length());
                                }
                            }
                        }
                        opt.All_Call_Report_Notes__c = Temp.abbreviate(35000);
                        
                    }
                update opp;
                }
            }catch(exception e){}
       }
     
    if (Trigger.isDelete){
        try{
             set<id> oppId = new set<id>();
             for(Opportunity_Call_Report__c cr : trigger.old){
                if(cr.Opportunity__c != null)
                oppId.add(cr.Opportunity__c);
              }
                List<opportunity> opp = [select id,name,All_Call_Report_Notes__c from Opportunity where id in : oppId];
                List<Opportunity_Call_Report__c> crn = new List<Opportunity_Call_Report__c>([select id, Opportunity__c,Call_Report_Number__c,Status_Update__c,CreatedDate from Opportunity_Call_Report__c where Opportunity__c in : oppId ORDER BY CreatedDate DESC]);
                
                if(crn.size()>0){   
                    for(opportunity opt: opp){
                        string Temp = '';
                        for(Opportunity_Call_Report__c c : crn){
                         if (c.Status_Update__c !='' && c.Status_Update__c!= null){
                            string t = c.Status_Update__c;
                            if(c.Opportunity__c == opt.id && (Temp + t.trim()).length() < 131071){
                                Date myDate = date.newinstance(c.CreatedDate.year(), c.CreatedDate.month(), c.CreatedDate.day());
                                String x=myDate.format();
                                Temp  = Temp + '`' + x + ': ' + t.trim();
                                System.debug('@@temp '+Temp.length());
                            }
                          }
                        }
                        opt.All_Call_Report_Notes__c = Temp.abbreviate(35000);
                    }
                    
                }
                else if(crn.size() == 0){
                    for(opportunity opt: opp){
                        string Temp = '';
                        
                        opt.All_Call_Report_Notes__c = Temp;
                    }
                    
                }
                
                update opp;
        }catch(exception e){}
     
     }
}