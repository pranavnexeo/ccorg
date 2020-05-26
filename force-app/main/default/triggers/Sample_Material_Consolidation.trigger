trigger Sample_Material_Consolidation on Sample_Material__c (after insert, after update, after delete) {

if (Trigger.isInsert || Trigger.isUpdate)
     {
         try{
             set<id> oppId = new set<id>();
             for(Sample_Material__c cr : trigger.new){
                if(cr.Opportunity__c != null)
                oppId.add(cr.Opportunity__c);
              }
                List<opportunity> opp = [select id,name,All_Sample_Materials__c from Opportunity where id in : oppId];
                Map<id,Sample_Material__c> cnMap = new Map<id,Sample_Material__c>();
                List<Sample_Material__c> crn = new List<Sample_Material__c>([select id,SAP_Material_MSD2__r.Name,Material_Status__c, Opportunity__c, CreatedDate from Sample_Material__c where Opportunity__c in : oppId ORDER BY CreatedDate DESC]);
                system.debug('@@ crn '+crn);
                if(crn.size()>0){
                    for(opportunity opt: opp){
                        string Temp = '';
                        for(Sample_Material__c c : crn){
                           if(c.Opportunity__c == opt.id){ // && (Temp + c.SAP_Material_MSD2__r.Name + c.Material_Status__c.trim()).length() < 131071){
                                Date myDate = date.newinstance(c.CreatedDate.year(), c.CreatedDate.month(), c.CreatedDate.day());
                                String x=myDate.format();
                                if(c.SAP_Material_MSD2__r.Name != null && c.SAP_Material_MSD2__r.Name!= ''){
                                    if(c.Material_Status__c != '' && c.Material_Status__c != null)
                                   {
                                           Temp  = Temp + '`' + x + ': ' + c.SAP_Material_MSD2__r.Name +'/'+c.Material_Status__c;
                                   }
                                    else{
                                   Temp  = Temp + '`' + x + ': ' + c.SAP_Material_MSD2__r.Name;                    
                                   }
                                }
                               
                              
                                System.debug('@@temp length '+Temp);
                            }
                        }
                        opt.All_Sample_Materials__c = Temp.abbreviate(35000);
                    }
                update opp;
                }
            }
            catch(exception e){}
       }
       if (Trigger.isDelete){
     
         try{
             set<id> oppId = new set<id>();
             for(Sample_Material__c cr : trigger.old){
                if(cr.Opportunity__c != null)
                oppId.add(cr.Opportunity__c);
              }
                List<opportunity> opp = [select id,name,All_Sample_Materials__c from Opportunity where id in : oppId];
                
                List<Sample_Material__c> crn = new List<Sample_Material__c>([select id,SAP_Material_MSD2__r.Name,Material_Status__c, Opportunity__c, CreatedDate from Sample_Material__c where Opportunity__c in : oppId ORDER BY CreatedDate DESC]);
                system.debug('@@ crn '+crn);
                if(crn.size()>0){
                    for(opportunity opt: opp){
                        string Temp = '';
                        for(Sample_Material__c c : crn){
                           if(c.Opportunity__c == opt.id){ // && (Temp + c.SAP_Material_MSD2__r.Name + c.Material_Status__c).length() < 131071)
                                Date myDate = date.newinstance(c.CreatedDate.year(), c.CreatedDate.month(), c.CreatedDate.day());
                                String x=myDate.format();
                                  if(c.SAP_Material_MSD2__r.Name != null && c.SAP_Material_MSD2__r.Name!= ''){
                                        if(c.Material_Status__c != '' && c.Material_Status__c != null){
                                            Temp  = Temp + '`' + x + ': ' + c.SAP_Material_MSD2__r.Name +'/'+c.Material_Status__c;
                                        }
                                        else{
                                        Temp  = Temp + '`' + x + ': ' + c.SAP_Material_MSD2__r.Name;  
                                            }
                                }
                                System.debug('@@temp  '+Temp);
                            }
                        }
                        opt.All_Sample_Materials__c = Temp.abbreviate(35000);
                    }
                
                }
                else if(crn.size()==0){
                    for(opportunity opt: opp){
                        string Temp = '';
                        opt.All_Sample_Materials__c = Temp;
                    }
                        
                }
                update opp;
            }
            catch(exception e){}
       }     
    
}