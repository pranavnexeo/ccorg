@isTest

private class ZTERR_Sch_Test{

    public static testMethod void testme() {
           
        
    List<Territory2Type> ZDOG = [select id from Territory2Type where MasterLabel = 'ZDOG' limit 1];
    if (ZDOG.size() == 0) {
		List<sObject> listTerritoryType = Test.loadData(Territory2Type.sObjectType, 'Territory2TypeZDOG');               
    }
    List<Territory2Type> ZTER = [select id from Territory2Type where MasterLabel = 'ZTER' limit 1];    
	if (ZTER.size() == 0) {
		List<sObject> listTerritoryType = Test.loadData(Territory2Type.sObjectType, 'Territory2TypeZTER');               
    }        
   
    
    SchedulableContext sc;    
    ZTERR_Sch psss = new ZTERR_Sch();
    psss.execute(sc);
    
    }
    
}