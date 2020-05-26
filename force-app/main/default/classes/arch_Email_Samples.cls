global class arch_Email_Samples{
  public string NoteId{Get ;set;}
  public List<Sample_Material__c> getMaterials(){
    
    Opportunity_Call_Report__c ocr = [select id, Opportunity__c from Opportunity_Call_Report__c where id = :NoteId limit 1];
    
    return [select id, name, Opportunity__r.StageName from Sample_Material__c where Opportunity__c = :ocr.Opportunity__c];
  }

}