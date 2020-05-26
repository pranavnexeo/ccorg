public with sharing class Sample_Request_Trigger_Functions {

    public static void processBeforeUpdate(List<Sample_Request__c> samples) {
      UpdateNotesSummary(samples);
    }
    
    private static void UpdateNotesSummary(List<Sample_Request__c> samples) {
    
      set<ID> IDSet = new set<ID>();
      List<Note> Notes = new list<Note>();
      Map<ID, Sample_Request__c> SampleMap = new Map<ID, Sample_Request__c>();
      
      for(Sample_Request__c SR:samples){
         if(SR.ID != null){
            IDSet.add(SR.ID);
            SR.Notes_Summary__c = '';
            SampleMap.put(SR.ID, SR);
         }
      }
      
      Notes = [select id, title, body, parentid, CreatedBy.Name from Note where parentID in :IDset order by ParentID, CreatedDate ];
      
      for(Note N:Notes){
         if(SampleMap.containskey(N.ParentID)){
             SampleMap.get(N.ParentID).Notes_Summary__c += N.title + '\n' + 'Created by: ' + N.CreatedBy.Name + '\n' + N.body + '\n\n';         
         }
      }
      
      for(Sample_Request__c SR:samples){
            SR.Notes_Summary__c = SampleMap.get(SR.ID).Notes_Summary__c;
      }
    }
}