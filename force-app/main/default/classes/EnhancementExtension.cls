public class EnhancementExtension{
public string recId{get;set;}
private final Enhancement__c enhancement;
public boolean editStatus{get;set;}
public boolean showDetail{get;set;}
public boolean showCheckBox3{get;set;}
public String currentUser{get;set;}
public boolean enableCheckBox2{get;set;}
public boolean enableCheckBox3{get;set;}
private final ApexPages.StandardController enhancementController;
public EnhancementExtension(ApexPages.StandardController controller) {
 enhancement = (Enhancement__c)controller.getRecord();               
  
  editStatus = false;
  showDetail = false;
  showCheckBox3 = false;
  enableCheckBox2 = false;
  enableCheckBox3 = false;
  
  
      recId = ApexPages.currentPage().getParameters().get('id');
      currentUser = UserInfo.getUserId();
      if (recId != null && recId !=''){
      
      editStatus = true ;
  
  List<Enhancement__c> enh = [Select Id,Project_Status__c from Enhancement__c where Id=:recId];
    //  if(enh[0].Project_Status__c == 'Confirmed' || enh[0].Project_Status__c == 'In Process' || enh[0].Project_Status__c == 'Completed' || enh[0].Project_Status__c == 'Cancelled' || enh[0].Project_Status__c == 'On Hold' ){
    if(enh[0].Project_Status__c != 'Open' ){
          showDetail = true;
      }
        List<String> idList = new List<String>(); 
        Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name = 'Enhancement Group'];  
        for (GroupMember gm : g.groupMembers) {  
        idList.add(gm.userOrGroupId);  
        }  
        
        for(Integer i=0;i<idList.size();i++){
        if(idList[i]== currentUser){
        showCheckBox3 = true;
        }
        }
        
     

  }
       
}


public void enablingcheckbox2(){
if (enhancement.Requirements_Garthered__c == true){
    enableCheckBox2 = true;
    enhancement.Requirements_Gathered_Date__c=System.Today();
}
if (enhancement.Requirements_Garthered__c == false){
    enableCheckBox2 = false;
    enableCheckBox3 = false;
    enhancement.Functional_Design__c = false;
    enhancement.Functional_Design_Approved__c = false;
    enhancement.Requirements_Gathered_Date__c= null;
    enhancement.Assigned_To__c = null;
}
if (enhancement.Functional_Design__c == true){
    enableCheckBox3 = true;
    enhancement.Functional_Design_Date__c=System.Today();
}
if (enhancement.Functional_Design__c == false){ 
    enableCheckBox3 = false;
    enhancement.Functional_Design_Approved__c = false;
    enhancement.Functional_Design_Date__c= null;
    enhancement.Assigned_To__c = null;
}
if (enhancement.Functional_Design_Approved__c == true){
    enhancement.Functional_Design_Approved_Date__c = System.Today();
}
 if (enhancement.Functional_Design_Approved__c == false){
    enhancement.Functional_Design_Approved_Date__c= null;
} 
    
}



}