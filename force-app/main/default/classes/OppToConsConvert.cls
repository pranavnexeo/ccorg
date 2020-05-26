public with sharing class OppToConsConvert {

public string oid;
public string redirectto;
Consumption__c newcon;
Opportunity Opp;
List<Nexeo_Competitor_to_Opportunity__c> NCOList;


    public OppToConsConvert(ApexPages.StandardController controller) 

{
    
    oid = apexpages.currentpage().getparameters().get('oid');
    redirectto = apexpages.currentpage().getparameters().get('redirectto');
    }

 
    public pagereference doconvert(){
    
    newcon = new Consumption__c();
    
    opp = [SELECT Id, 
       recordtypeid,
       annual_usage__c,
       accountid,
       SAP_Material__c, 
       product_of_interest_other__c,
       price_unit_of_measure__c,
       primary_competitor__r.name,
       primary_competitor__c,
       Ashland_supplier__c,
       details__c,
       product_group__c,
       created_from_consumption__c,
       converted_to_consumption__c,
       Consumption__c,
       Marketing_Code__c
FROM opportunity where id = :oid limit 1];

    Map<String, Schema.RecordTypeInfo> ConRTMap = Consumption__c.sObjectType.getDescribe().getRecordTypeInfosByName();
    Map<String, Schema.RecordTypeInfo> OppRTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();

    /* Determine recordtpe for new opportunity */
    
    /* Chemicals */
    if(opp.recordtypeID == OppRTmap.get('Distribution Chemicals').getrecordtypeid()){
    newcon.recordtypeID = ConRTMap.get('Distribution Chemicals').getrecordtypeid();
    newcon.distribution_volume__c = opp.annual_usage__c;


}
    /* Composites */
    else if (opp.recordtypeID == OppRTMap.get('Distribution Targets').getrecordtypeid()){
    newcon.recordtypeID = ConRTMap.get('Distribution Composites').getrecordtypeid();
    newcon.annual_volume__c = opp.annual_usage__c;

} 
    /* Plastics NA*/
    else if (opp.recordtypeID == oppRTMap.get('Distribution Plastics').getrecordtypeid()){
    newcon.recordtypeID = conRTMap.get('Distribution Plastics').getrecordtypeid();
    newcon.distribution_volume__c = opp.annual_usage__c;

}

    /* Plastics EMEA*/
    else if (opp.recordtypeID == oppRTMap.get('Distribution Plastics EMEA').getrecordtypeid() ){
    newcon.recordtypeID = conRTMap.get('Distribution Plastics EMEA').getrecordtypeid();
    newcon.distribution_volume__c = opp.annual_usage__c;

}

    /* ES RTK */ 
    else if (opp.recordtypeID == oppRTMap.get('Distribution Environmental Services').getrecordtypeid()){
    newcon.recordtypeID = conRTMap.get('Distribution RTK').getrecordtypeid();


}

    /* PM */ 
    else if (opp.recordtypeID == oppRTMap.get('Performance Materials - PM').getrecordtypeid()){
    newcon.recordtypeID = conRTMap.get('PM China').getrecordtypeid();
    

} 

   NCOList = new list<Nexeo_Competitor_to_Opportunity__c>();
   NCOList = [select id, Nexeo_Competitor__C, opportunity__C from Nexeo_Competitor_to_Opportunity__c where opportunity__C = :opp.id];
   
   newcon.created_from_Opportunity__c = true;
   newcon.account_name__c = opp.accountid;
   newcon.SAP_Material__c = opp.SAP_Material__c;
   newcon.base_code_other__c = opp.product_of_interest_other__c;  
   newcon.unit_of_measure__c = opp.price_unit_of_measure__c; 
   newcon.distributor__c = opp.primary_competitor__c; 
   newcon.current_supplier_producer__c = opp.Ashland_supplier__c;
   newcon.description__c = opp.details__c;
   newcon.product_group__c = opp.product_group__c;
   newcon.marketing_code__c = opp.Marketing_Code__c;
   
   pagereference pr; 
    if(Opp.created_from_consumption__c == true ||
        Opp.converted_to_consumption__c == true ||
          Opp.Consumption__c != null) {showpopup();}
    else{        
    pr = processcontinue();
    }
    return pr;
}    
    
    public pagereference processcontinue(){
    insert newcon;
    

    pagereference pr;
    if(redirectto == 'Account'){
    pr = new pagereference('/' + newcon.account_name__c);    
    }else {
    pr = new pagereference('/' + newcon.id + '/e?RetURL=' + newcon.id);
    }
    Opp.converted_to_consumption__c = true;
    update Opp;
    return pr;   
    }
    
    public pagereference processcancel(){
    pagereference pr = new pagereference('/' + opp.id);
    return pr;   
    }
    public boolean displayPopup {get; set;}
 
    public void closePopup() {
        displayPopup = false;
    }
 
    public pagereference showPopup() {
        displayPopup = true;
        return null;
    }
}