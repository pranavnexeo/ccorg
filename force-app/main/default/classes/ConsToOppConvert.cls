public with sharing class ConsToOppConvert {

public string cid;
Opportunity newopp;
Consumption__c con;
List<Nexeo_Competitor_to_Consumption__c> NCCList;

    public ConsToOppConvert(ApexPages.StandardController controller) {
    cid = apexpages.currentpage().getparameters().get('cid');
    displaypopup = false;
    }

 
    public pagereference doconvert(){
    newopp = new Opportunity();
    con = [SELECT 
        Id, 
        Name, 
        recordtypeID,
        SAP_Material__c,
        Account_Name__c,
        Base_Code_Other__c,
        distributor__c,
        Product_Group__c,
        Distribution_Volume__c,
        Direct_Volume__c,
        Secondary_Volume__c,
        Annual_Volume__c,
        Supplier_Producer__c,
        description__c,
        Unit_of_Measure__c,
        Converted_To_Opportunity__c,
        Created_From_Opportunity__c,
        Account_Name__r.name,
        SAP_Material__r.name,
        nexeo_competitor__c,
        marketing_code__c,
        Nexeo_Competitor__r.name
       from Consumption__c where id = :cid limit 1];
    /* Determine recordtpe for new opportunity */
    
    Map<String, Schema.RecordTypeInfo> ConRTMap = Consumption__c.sObjectType.getDescribe().getRecordTypeInfosByName();
    Map<String, Schema.RecordTypeInfo> OppRTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
    
    /* Chemicals */
    if(con.recordtypeID == conRTMap.get('Distribution Chemicals').getrecordtypeid()){
    newopp.recordtypeID = oppRTMap.get('Distribution Chemicals').getrecordtypeid(); 
    newopp.name = con.Account_name__r.name + ' : ' +  con.SAP_Material__r.name;


}
    /* Composites */
    else if (con.RecordTypeID == conRTMap.get('Distribution Composites').getrecordtypeid()){
    newopp.recordtypeID = oppRTMap.get('Distribution Targets').getrecordtypeid();
    newopp.name = con.Account_name__r.name + ' : ' +  con.SAP_Material__r.name;

} 
    /* Plastics */
    else if (con.recordtypeID == conRTMap.get('Distribution Plastics').getrecordtypeid()){
    newopp.recordtypeID = oppRTMap.get('Distribution Plastics').getrecordtypeid();
    newopp.name = con.Account_name__r.name;
    newopp.Product_Group__c = con.Product_Group__c;

}
    /* Plastics EMEA added by Annes on 12/17/2012*/
    else if (con.recordtypeID == conRTMap.get('Distribution Plastics EMEA').getrecordtypeid()){
    newopp.recordtypeID = oppRTMap.get('Distribution Plastics EMEA').getrecordtypeid();
    newopp.ADE_Tech_Rep_Required__c = 'No';    
    newopp.name = con.Account_name__r.name;
    newopp.Product_Group__c = con.Product_Group__c;

}

    /* ES RTK */ 
    else if (con.recordtypeID == conRTMap.get('Distribution RTK').getrecordtypeid()){
    newopp.recordtypeID = oppRTMap.get('Distribution Environmental Services').getrecordtypeid();
    newopp.name = con.Account_name__r.name;
    newopp.type = 'RTK';

}
    /* PM */ 
    else if (con.recordtypeID == conRTMap.get('PM China').getrecordtypeid()){
    newopp.recordtypeID = oppRTMap.get('Performance Materials - PM').getrecordtypeid();
    newopp.name = con.Account_name__r.name + ' : ' +  con.SAP_Material__r.name;
}
    
    NCCList = new List<Nexeo_Competitor_to_Consumption__c>();
    NCCList = [select id, Nexeo_competitor__c, consumption__c from Nexeo_Competitor_to_Consumption__c where consumption__c = :con.id];
    
    
    
    
    if(newopp.name == null){
    newopp.name = 'Opportunity';}
    
    newopp.created_from_Consumption__c = true;
    newopp.AccountID = con.account_name__c;
    newopp.SAP_Material__c = con.SAP_Material__c;
    newopp.product_of_Interest_Other__c = con.Base_Code_Other__c;
    newopp.closedate= system.today() + 60;
    newopp.stagename = 'Quotation';
    newopp.primary_competitor__c = con.distributor__c;
    newopp.consumption__c = con.id;
    newopp.Annual_Usage__c = 0;
    newopp.nexeo_primary_competitor_PL__c = con.nexeo_competitor__r.Name;
    newopp.marketing_code__c = con.marketing_code__c;
    
    
    if(con.Distribution_volume__c != null) {
    newopp.Annual_Usage__c = newopp.Annual_Usage__c + con.Distribution_Volume__c; }
    
    if(con.Direct_Volume__c != null){
    newopp.Annual_Usage__c = newopp.Annual_Usage__c + con.Direct_Volume__c;}

    if(con.Secondary_Volume__c != null){
    newopp.Annual_Usage__c = newopp.Annual_Usage__c + con.Secondary_Volume__c;}
    
    if(con.Annual_Volume__c != null){
    newopp.Annual_Usage__c = newopp.Annual_Usage__c + con.Annual_Volume__c;}
    
    newopp.Ashland_supplier__c = con.Supplier_Producer__c;
    newopp.details__c = con.description__c;
    newopp.Price_Unit_of_Measure__c = con.Unit_of_Measure__c;
    
    pagereference pr;
    if(con.converted_to_Opportunity__c == true ||
       con.created_from_Opportunity__c == true){showpopup();}
    else{        
    pr = processcontinue();
    }

    return pr;
   
    
}

    public pagereference processcontinue(){
    insert newopp;
    for(Nexeo_Competitor_to_Consumption__c NCC:NccList){
       if(NCC.Nexeo_competitor__c != con.nexeo_competitor__c){
       Nexeo_Competitor_to_Opportunity__c NCO = new Nexeo_Competitor_to_Opportunity__c();
       NCO.opportunity__c = newopp.id;
       NCO.nexeo_competitor__c = NCC.Nexeo_Competitor__c;
       insert NCO;
       }     
    }
    pagereference pr = new pagereference('/' + newopp.id + '/e?retURL=' + newopp.id);
    con.converted_to_Opportunity__c = true;
    update con;
    return pr;   
    }
    
    public pagereference processcancel(){
    pagereference pr = new pagereference('/' + con.id);
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