public class EmailWithTemplate{

public String tid{get; set;}
private String oid{get; set;}
private String cid{get; set;}
private String fid{get; set;}
private String field{get; set;}
private String pdf{Get; set;}
private String id{get; set;}

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


public EmailWithTemplate(ApexPages.StandardController sc){
   tid = ApexPages.currentpage().GetParameters().get('tid');
   cid = ApexPages.currentPage().getParameters().get('cid');
   fid = ApexPages.currentPage().getParameters().get('fid');
   field = ApexPages.currentPage().GetParameters().get('f');
   id = ApexPages.currentPage().getParameters().get('id');  
   pdf = ApexPages.currentPage().getParameters().get('pdf');
   renderPDFButton = (pdf != null); 
  
   templates = new list<SelectOption>();
   
   
   
   renderlist = (tid == null);
   
   if(fid != null){
     FolderName = [select id, name from folder where id = :fid limit 1].name;
     templates.add(new SelectOption('-1','--None--'));
     for(EmailTemplate e:[select id, name from EmailTemplate where folderid = :fid]){
        templates.add(new SelectOption(e.id, e.name));
     }
   }
   
   sobj = sc.getrecord();
   oid = sobj.id;
   Contact = [select id, name, email from Contact where id = :cid];
   User = [select id, name, email from user where id = :userinfo.getuserid()];
   bccString = User.email;

}

    public pagereference getpdfpage(){ 
       return new pagereference('/apex/' + pdf + '?id=' + id); }
       
    public void save(){ 
      sobj.put(field, newtext);
      update sobj; }
    
    private Messaging.SingleEmailMessage buildmessage(){
      sobj.put(field, newtext);
      update sobj;
      Messaging.SingleEmailMessage m;  
      m = new Messaging.SingleEmailMessage();
      m.setSenderDisplayName(user.name);
      m.setReplyTo(user.email);
      m.setSaveAsActivity(true);
      m.setwhatID(oid);
      m.settargetobjectid(cid);
      m.settemplateid(tid);
      return m;
}
      
      
    Public pagereference SendEmail(){
      if(tid != null && tid != '-1'){
      Messaging.SingleEmailMessage m = buildmessage();
      list<string> cc = new list<String>();
      List<string> bcc = new list<string>();
      
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
      if(endmessage == 'Success'){ return new pagereference('/' + oid); }
      else{
        showpopup = false;
        return null;
      }
    }
    
    public String geturl(){
        return '/' + tid + '?recipient_type_id=' + cid + '&related_to_id=' + sobj.id;   
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
        sobj.put(field, newtext);
        update sobj;
    }
    
    public pagereference cancel(){
      return new pagereference('/' + oid); 
    }
}