public with sharing class cc_imp_TriggerHandler_Contact extends cc_imp_TriggerHandler 
{
	private Map<Id, Contact> newContactMap;
	private Map<Id, Contact> oldContactMap;

	public cc_imp_TriggerHandler_Contact() 
	{
		 this.newContactMap = (Map<Id, Contact>) Trigger.newMap;
		 this.oldContactMap = (Map<Id, Contact>) Trigger.oldMap;
	}


	 public override void beforeInsert() 
	 {
	 	List <Contact>contactList = (List<Contact>) Trigger.new;

	 	cc_imp_ContactTriggerHandlerFunctions.processNexeo3DContactBeforeUpdates(contactList);
	 	cc_imp_ContactTriggerHandlerFunctions.processMyNexeoContactBeforeUpdates(contactList);
     }

     public override void afterInsert() 
	 {
		Set<Id> newContactIdSet = this.newContactMap.keySet();
		
	 	cc_imp_ContactTriggerHandlerFunctions.processNexeo3DContactUpdates(newContactIdSet);
	 	cc_imp_ContactTriggerHandlerFunctions.processMyNexeoContactUpdates(newContactIdSet);
     }

     public override void afterUpdate(){
	 	cc_imp_ContactTriggerHandlerFunctions.deleteOpenCartsOnAccountChange(oldContactMap, newContactMap);
     }

}