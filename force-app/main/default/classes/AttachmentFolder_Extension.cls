public class AttachmentFolder_Extension{
   
    public List<folders> Folders {get ;set;} 
    public Account Account{get; set;}
    public Case MyCase{get; set;}
     
    public AttachmentFolder_Extension(ApexPages.StandardController stdController) {

        String AccountID = ApexPages.currentpage().getparameters().get('AccID');
        String CaseID = ApexPages.currentpage().getparameters().get('CaseID');
        Set<ID> FolderIDs = new set<ID>();
        Set<ID> Folder2IDs = new set<ID>();
        Set<ID> Folder3IDs = new set<ID>();
        Map<ID, List<Attachment>> amap = new map<ID, List<Attachment>>();
        Map<ID, List<Attachment>> a2map = new map<ID, List<Attachment>>();
        Map<ID, List<Attachment>> a3map = new map<ID, List<Attachment>>();
        Folders = new List<folders>();
        Account = new Account();
        MyCase = new Case();
        list<Attachment_Folder__c> Level_1_Folders = new list<Attachment_Folder__c>();
        list<Attachment_Folder__c> Level_2_Folders = new list<Attachment_Folder__c>();
        list<Attachment_Folder__c> Level_3_Folders = new list<Attachment_Folder__c>();
        list<Attachment> AttachmentsOnParent = new list<Attachment>();
        
        if(CaseID != null && AccountID == null){
        MyCase = [select ID, Accountid, casenumber from Case where id = :CaseID limit 1];
            
        Level_1_Folders = [select id, name, parent_folder__c from Attachment_Folder__c where Level_1_Case_ID__c = :CaseID order by Name];
        Level_2_Folders = [select id, name, parent_folder__c from Attachment_Folder__c where Level_2_Case_ID__c = :CaseID order by Name];
        Level_3_Folders = [select id, name, parent_folder__c from Attachment_Folder__c where Level_3_Case_ID__c = :CaseID order by Name];
         AttachmentsOnParent = [select id, name from Attachment where parentid = :CaseID order by Name];
        }
             
        if(AccountID != null){
        Level_1_Folders = [select id, name, parent_folder__c from Attachment_Folder__c where Level_1_Account_ID__c = :AccountID order by Name];
        Level_2_Folders = [select id, name, parent_folder__c from Attachment_Folder__c where Level_2_Account_ID__c = :AccountID order by Name];
        Level_3_Folders = [select id, name, parent_folder__c from Attachment_Folder__c where Level_3_Account_ID__c = :AccountID order by Name];
        AttachmentsOnParent = [select id, name from Attachment where parentid = :AccountID order by Name];
        
        Account = [select id, name from Account where id = :AccountID];}
        
        
        for(Attachment_Folder__c f:Level_1_Folders){
           FolderIDs.add(f.id);
        }
        
        for(Attachment_Folder__c f:Level_2_Folders){
           Folder2IDs.add(f.id);
        }
        
        for(Attachment_Folder__c f:Level_3_Folders){
           Folder3IDs.add(f.id);
        }
        
        amap = Attachment_Functions.getattachments(FolderIDs);
        a2map = Attachment_Functions.getattachments(Folder2IDs);
        a3map = Attachment_Functions.getattachments(Folder3IDs);
        
        
        if(AccountID != null){
        folders.add(new folders(new Attachment_Folder__c(Name='Attachments from Account'), AttachmentsOnParent, AccountID));}
        if(CaseID != null){
        folders.add(new folders(new Attachment_Folder__c(Name='Attachments from Case'), AttachmentsOnParent, CaseID));}
        
        for(Attachment_Folder__c f:Level_1_Folders){
           if(amap != null) {
              if(amap.containskey(f.id)){
                  folders.add(new folders(f, amap.get(f.id)));
              }else{
                  folders.add(new folders(f));
              }//end if
           }//end if
          else{ folders.add(new folders(f)); }
       }//end for
        
        for(Attachment_Folder__c f2:Level_2_Folders){
           if(a2map != null) {
              if(a2map.containskey(f2.id)){
                  folders.add(new folders(f2, a2map.get(f2.id)));
              }else{
                  folders.add(new folders(f2));
              }//end if
           }//end if
          else{ folders.add(new folders(f2)); }
       }//end for
        
        for(Attachment_Folder__c f3:Level_3_Folders){
           if(a3map != null) {
              if(a3map.containskey(f3.id)){
                  folders.add(new folders(f3, a3map.get(f3.id)));
              }else{
                  folders.add(new folders(f3));
              }//end if
           }//end if
          else{ folders.add(new folders(f3)); }
       }//end for
         
       List<Attachment_Folder__c> templist = new list<Attachment_Folder__c>();
       Map<ID, folders> fmap = new map<ID, folders>();
       
       for(folders f:folders){
           templist.add(f.folder);
           fmap.put(f.folder.id, f);     
       }
       Sort_Helper SH = new Sort_Helper();
       templist = SH.getSortedList(templist, 'Name', true);

       folders.clear();
       for(Attachment_Folder__c f:templist){
           folders.add(fmap.get(f.id));
       }
  
    } 
    
    public class Folders{
       
       public Attachment_Folder__c folder{get; set;}
       public list<Attachment> attachments{get; set;}
       public string id{get; set;}
      

       public folders(Attachment_Folder__c f, list<Attachment> a){          
            folder = f;
            attachments = a; 
            id = f.id;          
       }
       
       public folders(Attachment_Folder__c f){          
            folder = f;
            attachments = new list<attachment>(); 
            id = f.id;
       }
       public folders(Attachment_Folder__c f, list<Attachment> a, String IDString){
            folder = f;
            attachments = a;
            id = IDString; 
      }
    }
    
}