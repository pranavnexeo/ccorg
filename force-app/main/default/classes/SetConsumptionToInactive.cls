Public with sharing class SetConsumptionToInactive{

private consumption__c c{get; set;}
public SetConsumptionToInactive(ApexPages.StandardController sc){
   c = (Consumption__c)sc.getrecord();
}
public pagereference Inactivate(){
   c.status__c = 'Inactive';
   update c;
   return new pagereference('/' + c.id);
}


}