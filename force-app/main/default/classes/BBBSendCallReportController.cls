public with sharing class BBBSendCallReportController {

public string crid;
public string tid;
public string mobile;

public call_report__c cr;
public emailtemplate t;
public string userid;
public user user;

public list <user> sendtousers;
public set<user> sendtoset;
public list <user> matchedusers;
public list <selectOption> matched;
public list <selectOption> sendto;
public map<id, string> namemap;
public map<id, string> emailmap;

    public BBBSendCallReportController(ApexPages.StandardController controller)
    { 
        sendtousers = new list<user>();
        matchedusers = new list<user>();
        sendtoset = new set<user>();
        searchuser = '';
        mobile = '';
        endmessage = '';
        
        sendto = new list<selectOption>();
        matched = new list<selectOption>();
        
        namemap = new map<id, string>();
        emailmap = new map<id, string>();
        
        emailsent = false;
        success = false;
        selectedmatch = '-1';
        
        crid = apexpages.currentpage().getparameters().get('crid');
        tid = apexpages.currentpage().getparameters().get('tid');
        userid = userinfo.getuserid();
        mobile = apexpages.currentpage().getparameters().get('m');
        
        
        list<call_report__c> c = [select id, name from call_report__c where id = :crid];
        cr = c[0];
        
        list<user> u = [select id, name, email from user where id = :userid];
        user = u[0];
        
        list<EmailTemplate> emtemp = [select id, name from emailtemplate where id = :tid];
        t = emtemp[0];
    }

public list<selectoption> getmatched(){

if(searchuser != ''){
    matchedusers.clear();
    String s = searchuser.replace('*', '%');
    matchedusers = [select id, name, email from user where lastname like :s];
    for(user u:matchedusers){
        namemap.put(u.id, u.name);
        emailmap.put(u.id, u.email);}
}

matched.clear();
matched.add(new selectoption('-1', 'Select...'));

for(user u:matchedusers){
    matched.add(new selectoption(u.id, u.name ));}

return matched;
}

public list<selectOption> getsendto(){

if(selectedmatch <> '-1' & mobile != 'true') {
sendto.clear();
List<user> u = [select id, name from user where id = :selectedmatch];
if(sendtoset.contains(u[0]) == false){
sendtoset.add(u[0]);
sendtousers.add(u[0]);
}
for(User L:sendtousers){
sendto.add(new selectoption(L.id, namemap.get(L.id)));}
}
return sendto;
}


public void removeuser(){

if(mobile != 'true'){
    selectedmatch = '-1';
    for(integer i=0; i<sendtousers.size(); i++){
        if(sendtousers.get(i).id == selectedsendto){
            boolean b = sendtoset.remove(sendtousers.get(i));
            user s = sendtousers.remove(i);
            sendto.clear();
        }
    }

    sendtoset.clear();
    for(user u:sendtousers){
        sendtoset.add(u);
        sendto.add(new selectoption(u.id, namemap.get(u.id)));
    }
}
}

public pagereference sendemail(){

 Messaging.SingleEmailMessage m;
      
      
      
      String replyTo = user.email;
      m = new Messaging.SingleEmailMessage();
      m.setSenderDisplayName(user.name);
      m.setReplyTo(replyTo);
      m.setSaveAsActivity(true);
      m.settemplateid(tid);
      m.setsaveasactivity(false);
      List<Contact> C = [select id from Contact where LastName = 'ServiceDesk-DoNotReply' limit 1];
      m.settargetobjectid(C[0].id);
      m.setwhatID(crid);
      manualaddresses = manualaddresses.replace(',', '');
      manualaddresses = manualaddresses.replace(';', '');
      String[] s = new String[]{};
      if(manualaddresses.length() <> 0){
      s = manualaddresses.split('\r');}
      if(mobile == 'true' & selectedmatch != '-1'){
      s.add(emailmap.get(selectedmatch));}
      else{
      for(user L:sendtousers){
      s.add(emailmap.get(L.id)); }
      }
      m.setccaddresses(s);
      system.debug(s);
      try {
          List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.Email[]{m});
          success = results[0].success;
          if(success){endmessage = 'Success';}
          else{ endmessage = 'Error';}
          
          showpopup();
          //System.debug(results);
          } catch(Exception e) {
            System.debug(e.getMessage());
          }
     emailsent = true;
   

     return null;
}

public pagereference refreshthis(){return null;}

public boolean success{get; set;}
public boolean emailsent{get; set;}

public string searchuser{get; set;}
public string getcrid(){return crid;}
public string selectedsendto{get; set;}
public string selectedmatch{get; set;}
public string endmessage{get; set;}
public String getcr(){return cr.name;}
public String gettid(){return tid;}

public string manualaddresses{get; set;}
public pagereference cancel(){
pagereference pr = new pagereference('/'+cr.id);
return pr;
}

    public boolean displayPopup {get; set;}
 
    public pagereference closePopup() {
        displayPopup = false;
        pagereference pr = new pagereference('/' + crid);
        return pr;
    }
 
    public pagereference showPopup() {
        displayPopup = true;
        return null;
    }



}