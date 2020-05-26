/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        2/28/2017
*    Author:             Shwetha Suvarna, Sneha Likhar
*   Last Modified:       Shwetha Suvarna, Sneha Likhar
*   Last Modified By:    2/28/2017
*
*   Short Description:  Update resource names on Enhancement .
*   **********************************************************************************************************************/

trigger PopulateResourceName on Enhancement_Resource__c (after insert, after update, after delete) {

    list<Enhancement__c> listEnhancementUpdate = new list<Enhancement__c>();  
    map<id,list<String>> enMap = new map <id,list<String>>();
    map<id,Enhancement__c> enMapParent = new map <id,Enhancement__c>();
    set<Id> setOfids = new set<Id>();
    
    if(!trigger.isDelete){
    for(Enhancement_Resource__c er :trigger.new){
     if(er.Assigned_To__c!=null){
            setOfids.add(er.Enhancement__c);
            
     }
    }
       
    
   if(!setOfids.isEmpty()) {
                list <Enhancement_Resource__c> ERList = [select id, Enhancement__c,Assigned_to__c, Assigned_To__r.name from Enhancement_Resource__c where Enhancement__c =:setOfids];
                list<Enhancement__c> listOfEnhancement = [select id,Resource_Name__c from Enhancement__c where Id =: setOfids];
                
                for(Enhancement__c par: listOfEnhancement ){ 
                enMapParent.put(par.id, par);
                }
                
                               
                    
                        for(Enhancement_Resource__c child: ERList){ 
                           List<Enhancement_Resource__c> clist = new list<Enhancement_Resource__c>();
                           list<string> cnamelist = new list<string>();
                           clist=[select id,Assigned_to__c, Assigned_To__r.name from Enhancement_Resource__c where Enhancement__c =:child.Enhancement__c];           
                           for(Enhancement_Resource__c erc: clist){
                           cnamelist.add(erc.Assigned_To__r.name);
                           }
                        enMap.put(Child.Enhancement__c,cnamelist);                      
                          }                      
                        }
                        
                        For(string enh: enMap.keyset()){
                        Enhancement__c temp=  enMapParent.get(enh);
                        string concate;
                        for(string name : enMap.get(enh)) 
                        if(concate == null){
                            concate = name;
                            }
                            else{                        
                            concate = concate + ';'+name;
                            }
                            
                        temp.Resource_Name__c = concate;                                                                                        
                        listEnhancementUpdate.add(temp);
                        }
             
                if(listEnhancementUpdate.size()>0)
            Update listEnhancementUpdate;
}
 else{
        for(Enhancement_Resource__c er :trigger.old){
         if(er.Assigned_To__c!=null){
                setOfids.add(er.Enhancement__c);
                
         }
        }
        
        if(!setOfids.isEmpty()) {
                list <Enhancement_Resource__c> ERList = [select id, Enhancement__c,Assigned_to__c, Assigned_To__r.name from Enhancement_Resource__c where Enhancement__c =:setOfids];
                list<Enhancement__c> listOfEnhancement = [select id,Resource_Name__c from Enhancement__c where Id =: setOfids];
                
                for(Enhancement__c par: listOfEnhancement ){ 
                enMapParent.put(par.id, par);
                }
                
                               
                    if(ERList.size()>0){
                        for(Enhancement_Resource__c child: ERList){ 
                           List<Enhancement_Resource__c> clist = new list<Enhancement_Resource__c>();
                           list<string> cnamelist = new list<string>();
                           clist=[select id,Assigned_to__c, Assigned_To__r.name from Enhancement_Resource__c where Enhancement__c =:child.Enhancement__c];           
                           for(Enhancement_Resource__c erc: clist){
                           cnamelist.add(erc.Assigned_To__r.name);
                           }
                        enMap.put(Child.Enhancement__c,cnamelist);                      
                          }                      
                        }
                        else{
                        
                        List<Enhancement__c> elist = new list<Enhancement__c>();
                            elist = [select id,Resource_Name__c from Enhancement__c where Id =: setOfids];
                             for(Enhancement__c enhs: elist){                             
                             if(enhs.Resource_Name__c!='' || enhs.Resource_Name__c!=null){
                             enhs.Resource_Name__c = '';
                             listEnhancementUpdate.add(enhs);
                             
                             }
                             
                             }
                             if(listEnhancementUpdate.size()>0)
                             update listEnhancementUpdate;
                        }
                        
                        }
                      
                        For(string enh: enMap.keyset()){
                        Enhancement__c temp = enMapParent.get(enh);
                        string concate;
                        for(string name : enMap.get(enh)) 
                        if(concate != null){
                            concate = concate + ';'+name;
                            }
                            else{                        
                            concate = name;
                            }
                            
                        temp.Resource_Name__c = concate;                                                                                        
                        listEnhancementUpdate.add(temp);
                        }
                        
                        
             
                if(listEnhancementUpdate.size()>0)
            Update listEnhancementUpdate;
    }
}