public with sharing class BBBTemplateController {

public list<contact>matchedcontactlist;
public list<folder>folderlist;
public list<user>matcheduserlist;
public list<emailtemplate>templist;
public set<string>selectedusers;

public string userid;
public string whatid;
public user user;

public map<string, string> emailmap;
public map<string, string> namemap;
public list<selectoption>matchedcontacts;
public list<selectoption>matchedusers;
public list<selectoption>templates;
public List<selectoption> userlist;


    public BBBTemplateController()
    { 
        endmessage='';
        emailsent = false;
        success = false;
        searchcontact = '';
        searchuser = '';
        selecteduserid = '';
        userinlist = '';
        displaypopup = false;
        bccme = true;
        ccseller = false;
        cccsr = false;
        
        
        emailmap = new map<string, string>();
        namemap = new map<string, string>();
        whatid = apexpages.currentpage().getparameters().get('whatid');
        templateid = apexpages.currentpage().getparameters().get('tid'); 
        templateidnull = (templateid == null);
        bccme = false;
        
        userid = userinfo.getuserid();
        
        list<user> u = [select id, name, email from user where id = :userid];
        user = u[0];
        
        matchedcontacts = new list<selectoption>();
        matchedusers = new list<selectoption>();       
        folders = new list<selectoption>();
        templates = new list<selectoption>();
        templist = new list<EmailTemplate>();
        folderlist = new list<folder>();
        matchedcontactlist = new list<contact>();
        matcheduserlist = new list<user>();
        selectedusers = new set<string>();
        userlist = new list<selectoption>();

        
        //folderlist = [select id, name, type from folder where (type='Email') and (name='Mobile Templates')];
        //folderid = folderlist[0].id;
        
        folderid = apexpages.currentpage().getparameters().get('fid');
        for(folder f:folderlist){
            if(f.type != null){
            folders.add(new selectoption(f.id, f.name)); }
        }
        
        
        multiple = apexpages.currentpage().getparameters().get('multiple');
    }

public list<selectoption> gettemplates(){
templist = [select id, name from emailtemplate where (folderid = :folderid) and (isactive=true)];
templates.clear();
for(emailtemplate t:templist){
templates.add(new selectoption(t.id, t.name));
}
return templates;
}

public boolean templateidnull{get; set;}
public string endmessage{get; set;}
public string folderid{get; set;}
public string templateid{get; set;}
public string contactid{get; set;}
public string selecteduserid{ get; set;}
public list<selectoption> folders{get; set;}
public string searchcontact{get; set;}
public string searchuser{get; set;}

public list<selectoption> getmatchedusers(){

if(searchuser != ''){
    matcheduserlist.clear();
    String s = searchuser.replace('*', '%');
    matcheduserlist = [select id, name, email from user where lastname like :s];
    for(user u:matcheduserlist){
        namemap.put(u.id, u.name);
        emailmap.put(u.id, u.email);}
}

matchedusers.clear();
matchedusers.add(new selectoption('-1', 'Select...'));

for(user u:matcheduserlist){
    matchedusers.add(new selectoption(u.id, u.name ));}

return matchedusers;
}

public list<selectoption> getuserlist(){
if(selecteduserid != '-1' & selecteduserid != ''){
if(!selectedusers.contains(selecteduserid)){
selectedusers.add(selecteduserid);
userlist.add(new selectoption(selecteduserid, namemap.get(selecteduserid)));
}
}
return userlist;
}

public pagereference removeuser(){
selecteduserid = '-1';
for(integer i=0; i<userlist.size(); i++){
    if(userlist.get(i).getValue() == userinlist){
        userlist.remove(i);
    }
}
selectedusers.remove(userinlist);


return null;
}

public list<selectoption> getmatchedcontacts(){

if(searchcontact != ''){
    matchedcontactlist.clear();
    searchcontact = searchcontact.replace('*', '%');
    matchedcontactlist = [select id, name, email from contact where (lastname like :searchcontact) and (email != null) order by Name limit 1000];
    for(contact c:matchedcontactlist){
        namemap.put(c.id, c.name);
        emailmap.put(c.id, c.email);}
}

matchedcontacts.clear();
matchedcontacts.add(new selectoption('-1', 'Select...'));

for(contact c:matchedcontactlist){
    matchedcontacts.add(new selectoption(c.id, c.name ));}

return matchedcontacts;
}

public string getcontactemail(){return emailmap.get(contactid);}
public pagereference refreshthis(){return null;}
public boolean success{get; set;}
public boolean emailsent{get; set;}
public string otheremail{get; set;}
public boolean bccme{get; set;}
public string multiple{get; set;}
public string userinlist{get; set;}
public boolean ccseller{get; set;}
public boolean cccsr{get; set;}

public pagereference cancel(){
pagereference pr = new pagereference('/'+contact.id);
return pr;
}

public pagereference sendEmail() {
        
      Messaging.SingleEmailMessage m;
      
      m = new Messaging.SingleEmailMessage();
      m.setSenderDisplayName(user.name);
      m.setReplyTo(user.email);
      m.setSaveAsActivity(true);
      m.setwhatID(whatid);
      list<contact> c = new list<contact>();
      
      if(contactid == '-1' || contactid == '' || contactid == null){
        c = [select id, Account.ownerid, Account.SAP_CSR_Email__c from contact where LastName = 'Call Report Holder'];
        contactid = c[0].id;
      }
      else{
        c = [select id, Account.ownerid, Account.SAP_CSR_Email__c from contact where LastName = 'Call Report Holder'];
      }
      
      c[0].email= user.email;
      update c[0];
      
      system.debug('ContactID: '+ contactid); 
      m.settargetobjectid(contactid);
      m.settemplateid(templateid);
      
      list<string> cc = new list<string>();

          if(selecteduserid != '' & selecteduserid != '-1'){           
              cc.add(emailmap.get(selecteduserid)); 
              
          }
          if(selectedusers.size() != 0){
              for(string u:selectedusers){
                  if(u != selecteduserid){
                  cc.add(emailmap.get(u));}
              }
          }
          if(cccsr & c[0].Account.SAP_CSR_Email__c != null){
              cc.add(c[0].Account.SAP_CSR_Email__c);
          }
          if(ccseller){
          list<User> u = [select email from user where id = :c[0].Account.ownerid limit 1];
              cc.add(u[0].email);
              }
          
     
      if(otheremail != ''){
      cc.add(otheremail);
      } 
      m.setccaddresses(cc);
      
      if(bccme){
      m.setbccaddresses(new list<string>{user.email});
      }
      
      
      try {
          List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.Email[]{m});
          success = results[0].success;
          if(success){endmessage = 'Success';
          showpopup();}

          //System.debug(results);
          } catch(Exception e) {
          endmessage = 'Error: ' + e;
          showpopup();
          System.debug(e.getMessage());
          }
     emailsent = true;
     return null;    
    }
    
        public boolean displayPopup {get; set;}
 
    public pagereference closePopup() {
        displayPopup = false;
        pagereference pr = new pagereference('/' + whatid);
        return pr;
    }
 
    public pagereference showPopup() {
        displayPopup = true;
        return null;
    }
}