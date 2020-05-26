global with sharing class Lead_Functions {

  /*webservice static AshlandWebSiteLeadInsertResults createAshlandWebSiteLead(Lead newLead) 
  {
    AshlandWebSiteLeadInsertResults result = new AshlandWebSiteLeadInsertResults();
    
    result.result = false;    
    
    String ashlandWebSiteRecordType = RecordType_Functions.LookupRecordTypeId('Ashland Website Lead', 'Lead');    
    
    newLead.RecordTypeId = ashlandWebSiteRecordType;
    newLead.LeadSource = 'Ashland Website';
    
    try {
        insert newLead;
        result.result = true;
        result.newId = newLead.Id;
        } 
        catch(Exception e) 
        {
        result.result = false;
        result.errorMessage = e.getMessage();
        }
        
    return result;
  }*/


}