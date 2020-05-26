Public Class EmailNCAR{
public String tid{get; set;}
private String cid{get; set;}
private String fid{get; set;}
private String field{get; set;}
private String pdf{Get; set;}
private String id{get; set;}

Public NCAR_Cases__c mycase{get; set;}
public Contact Contact{get; set;}
private User User{get; set;}

public String ccstring{get; set;}
public String bccstring{get; set;}
public String endmessage{get; set;}
public boolean showpopup{get; set;}
public String newtext{get; set;}
public List<SelectOption> templates{get; set;}
public sobject sobj{get; set;}
public boolean renderlist{get; set;}
Public String FolderName{get; set;}
public boolean renderPDFButton{get; set;}
private ApexPages.StandardController standcont{get; set;}

Public EmailNCAR(ApexPages.standardcontroller sc){
standcont = sc;
mycase = (NCAR_Cases__c)sc.getrecord();
   tid = ApexPages.currentpage().GetParameters().get('tid');
   cid = ApexPages.currentPage().getParameters().get('cid');
   fid = ApexPages.currentPage().getParameters().get('fid');
   field = ApexPages.currentPage().GetParameters().get('f');
   id = ApexPages.currentPage().getParameters().get('id');  
   pdf = ApexPages.currentPage().getParameters().get('pdf');
   renderPDFButton = (pdf != null); 
   templates = new list<SelectOption>();
   renderlist = (tid == null);
  
   if(fid != null && fid != null){
     FolderName = [select id, name from folder where id = :fid limit 1].name;
     templates.add(new SelectOption('-1','--None--'));
     for(EmailTemplate e:[select id, name from EmailTemplate where folderid = :fid]){
        templates.add(new SelectOption(e.id, e.name));
     }  
     } 
     
    
   //TO DO - Query NCAR - Get Contact Info
   Contact = [select id, name, email from Contact where id = :cid];
   User = [select id, name, email from user where id = :userinfo.getuserid()];
   
   bccString = User.email;
   mycase = [select id, name, Actions_Taken__c,Action_Taken_Customer_Facing__c,Immediate_Action__c,Immediate_Action_Customer_Facing__c,Problem_Statement__c,Problem_Statement_Customer_Facing__c,Root_Cause__c,Root_Cause_Customer_Facing__c from NCAR_Cases__c where id = :id];

   //TO DO - Set Customer Facing Fields to values in Standard Fields
  
   system.debug('Actions Taken:' +  mycase.actions_taken__c + 'Customer Facing Actions Taken: ' + mycase.Actions_Taken__c);
   if(mycase.Action_Taken_Customer_Facing__c == null || mycase.Action_Taken_Customer_Facing__c.length() == 0){ 
   mycase.Action_Taken_Customer_Facing__c = mycase.Actions_Taken__c;}
   if(mycase.Immediate_Action_Customer_Facing__c == null || mycase.Immediate_Action_Customer_Facing__c.length() == 0){
   mycase.Immediate_Action_Customer_Facing__c = mycase.Immediate_Action__c;}
   if(mycase.Problem_Statement_Customer_Facing__c == null || mycase.Problem_Statement_Customer_Facing__c.length() == 0){
   mycase.Problem_Statement_Customer_Facing__c = mycase.Problem_Statement__c;}
   if(mycase.Root_Cause_Customer_Facing__c == null || mycase.Root_Cause_Customer_Facing__c.length() == 0){
   mycase.Root_Cause_Customer_Facing__c = mycase.Root_Cause__c;}


}
       
Public pagereference SendAndSave(){
   update mycase;

   SendEmail();
   String PDFFile = 'NCAR_Letter_' + system.now();
   return new pagereference('/apex/Make_PDF?id=' + mycase.id + '&PDF=NCAR_Letter_PDF&f=' + PDFFile );
}

Public pagereference Cancel(){
  return new pagereference('/' + mycase.id);
}

public pagereference pdfpage(){
   update mycase;
   String PDFFile = 'NCAR_Letter_' + system.now();
   return new pagereference('/apex/Make_PDF?id=' + mycase.id + '&PDF=NCAR_Letter_PDF&f=' + PDFFile );
}

private Messaging.SingleEmailMessage buildmessage(){
      update mycase;
      Messaging.SingleEmailMessage m;  
      m = new Messaging.SingleEmailMessage();
      m.setSenderDisplayName(user.name);
      m.setReplyTo(user.email);
      m.setSaveAsActivity(true);
      m.setwhatID(id);
      m.settargetobjectid(cid);
      m.settemplateid(tid);
      return m;

}

Public pagereference SendEmail(){
      if(tid != null && tid != '-1'){
      Messaging.SingleEmailMessage m = buildmessage();

      //Messaging.EmailFileAttachment EFA = new Messaging.EmailFileAttachment();
      //EFA.setBody(a.body); 
      //EFA.setFileName('NCAR_' + mycase.name + '_PDF.pdf');
      //EFA.setContentType('application/pdf');
      //EFA.setInline(false);
      //m.setFileAttachments(new Messaging.EmailFileAttachment[]{EFA});
      
      list<string> cc = new list<String>();
      List<string> bcc = new list<string>();
      ccstring='';
      if(ccstring.length() != 0){
      ccstring = ccstring.replace('\n', ',');
      for(String s:ccstring.split(',')){
         s = s.trim();
         if(s != null){ cc.add(s); }
      }
      if(cc.size() != 0){ m.setccaddresses(cc); }  
      }
      
      if(bccstring.length() != 0){
      bccstring = bccstring.replace('\n', ',');
      system.debug('bcc: ' + bccstring);
      for(string s:bccstring.split(',')){
         s = s.trim();
         if(s != null){ bcc.add(s); }
      }
      if(bcc.size() != 0){ m.setbccaddresses(bcc); }
      }
 
      try {
          List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.Email[]{m});
          boolean success = results[0].success;
          if(success){
             endmessage = 'Success'; 
             showpopup = true;
          }      
          } 
          catch(Exception e) {
             endmessage = 'Error: ' + e;
             showpopup = true;
          }
      }else 
      {
         endmessage = 'Please Select a Template';
         showpopup = true;
      }
          return null;    
    }
    
    public pagereference complete(){
      if(endmessage == 'Success'){ return new pagereference('/' + mycase.id); }
      else{
        showpopup = false;
        return null;
      }
    }
    
    public String geturl(){
        return '/' + tid + '?recipient_type_id=' + cid + '&related_to_id=' + mycase.id;   
    }
    
    public pagereference templatechanged(){
       return null;
    }
    
    public boolean getrenderPreview(){ return (tid != null); }
    
    public pagereference showtemplateerror(){
         endmessage = 'Please Select a Template';
         showpopup = true;
         return null;
}
public void updaterecord(){
   update mycase;
}

}