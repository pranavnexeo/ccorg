public with sharing class  Mass_Email_Wizard{

public string templateid{Get; set;}
public string datastring{Get; set;}

public Mass_Email_Wizard(){

  Map<Id, Node> nmap = new map<Id, Node>();
  
  nmap.put(UserInfo.getOrganizationId(), new node(UserInfo.getOrganizationId(), 'Unfiled Public Email Templates', 'folder', new state(false, false, false)));
  nmap.put(UserInfo.getUserId(), new node(UserInfo.getUserId(), 'My Personal Email Templates', 'folder', new state(false, false , false)));
  
  for(folder f:[select id, type, name from folder where type = 'Email' order by name]){
    nmap.put(f.id, new node(f.id, f.name, 'folder', new state(false, false, false)));
    system.debug(f.type);
  }
  
  for(emailtemplate t:[select id, name, folder.name, folderid from emailtemplate where isactive = true and folderid != null order by folder.name, name  limit 1000]){
    if(t.folderid == null){
      nmap.get(UserInfo.getOrganizationId()).children.add(new node(t.id, t.name, 'jstree-file', 'template'));
    }else if(nmap.containskey(t.folderid)){
      nmap.get(t.folderid).children.add(new node(t.id, t.name, 'jstree-file', 'template'));
    }
  }
  
  List<node> toreturn = new list<node>();
  toreturn.add(nmap.get(UserInfo.getOrganizationId()));
  toreturn.add(nmap.get(UserInfo.getUserId()));
  for(folder f:[select id, type, name from folder where type = 'Email' order by name]){
    toreturn.add(nmap.get(f.id));
  }
  datastring = JSON.serialize(toreturn);
}

public class node{
  
  public string id{get; set;}
  public string text{get; set;}    
  public string icon{get; set;} 
  public string type{get; set;}
  public state state{Get; set;}  
  public List<node> children{get; set;}
  public node(){
    children = new List<node>();
    this.state = new state();
  }
  
  public node(string id, string name, string type){
    this.id = id;
    this.text = name;
    this.children = new List<node>();
    this.type = type;
    this.state = new state();
  }
  
  public node(string id, string name, string type, state state){
    this.id = id;
    this.text = name;
    this.children = new List<node>();
    this.type = type;
    this.state = state;
  }
  
  public node(string id, string name, string icon, string type){
    this.id = id;
    this.text = name;
    this.children = new List<node>();
    this.icon = icon;
    this.type = type;
    this.state = new state();
  }
  
  public node(string id, string name, string icon, string type, state state){
    this.id = id;
    this.text = name;
    this.children = new List<node>();
    this.icon = icon;
    this.type = type;
    this.state = state;
  }
  }

public class state{
  public boolean opened{Get; set;}
  public boolean disabled{get; set;}
  public boolean selected{Get; set;}
  public state(){
    this.opened = false;
    this.disabled = false;
    this.selected = false;
  }
  
  public state(boolean opened, boolean disabled, boolean selected){
    this.opened = opened;
    this.disabled = disabled;
    this.selected = selected;
  }
}
}