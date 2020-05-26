trigger Clonecontainer on Container_Specification_Document__c (after update) { 
List<Container_Specification_Document__c> jbApp = new List<Container_Specification_Document__c>();
 for(Container_Specification_Document__c stud:Trigger.new){
 if(stud.Status__c=='Approved'&& stud.Master_Id__c!=null){
  Container_Specification_Document__c st = [Select id,Status__c,Master_Id__c from Container_Specification_Document__c where id=:stud.Master_Id__c];
if(st.Status__c!='Archived')
{
  st.Status__c = 'Archived';
jbApp.add(st);
}
if(jbApp.size()>0)
update jbApp;
  }
 }
 }