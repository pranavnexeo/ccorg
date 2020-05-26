/*Used to display alert on R&D Object page layouts
*@Approval process helper
*@LAB Project
*/

public class RD_Page_Banner{
    
    /*Initializing variables*/    
    private R_D_Requests__c req{get; set;}
    private Set<String> Innovation_Stage_1 = new Set<String>{'Innovation – Stage 1 Market Research', 'Innovation – Stage 2 Product Development', 'Innovation – Stage 3 Pre-Launch' };
    private Set<String> Innovation_Stage_2 = new Set<String>{'Innovation – Stage 2 Product Development', 'Innovation – Stage 3 Pre-Launch' };
    private Set<String> Innovation_Stage_3 = new Set<String>{'Innovation – Stage 3 Pre-Launch' };
    private Set<String> Customer_Stage_1 = new Set<String>{'Customer – Stage 1 Scope', 'Customer – Stage 2 In Process' };
    private Set<String> Customer_Stage_2 = new Set<String>{'Customer – Stage 2 In Process' };

    
    /*Contructor*/ 
    public RD_Page_Banner(apexpages.standardcontroller sc){
          req = (R_D_Requests__c)sc.getrecord();
          req = [select id, recordtype.name,
                Subtype__c,
                HSSE_Final_Review__c,
                Legal_Final_Review__c,
                Legal_IP_Review__c,
                Marcomms_Final_Reivew__c,
                Market_Analysis__c,
                No_Material_Recommendation__c,
                PLM_Final_Review__c,
                PLM_Logistics_Review__c,
                Product_Development__c,
                Product_Launch_Plan__c,
                Project_Plan__c,
                Project_Technical_Report__c
                from R_D_Requests__c where id = :req.id limit 1];
                
    }
    /*End of constructor*/
    
    /*Display alerts*/
    public void setMessages(){
       if(Innovation_Stage_1.contains(req.recordtype.name)){
        if(!req.Legal_IP_Review__c && req.Subtype__c == 'Blend Development') 
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Confirm Legal IP Review before submitting for approval'));
        if(!req.PLM_Logistics_Review__c)
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Confirm PLM Review before submitting for approval'));
        if(!req.Market_Analysis__c && req.Subtype__c == 'Blend Development')
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Confirm Market Analysis document is attached before submitting for approval'));
      }
       if(Innovation_Stage_2.contains(req.recordtype.name)){  
        if(!req.Project_Technical_Report__c) 
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Confirm Project Technical report is attached before submitting for approval'));
        if(!req.Project_Plan__c) 
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Confirm Project Plan is attached before submitting for approval'));
      
      }
      if(Innovation_Stage_3.contains(req.recordtype.name)){
       if(!req.Product_Launch_Plan__c) 
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Confirm Product Launch Plan is Attached before submitting for approval'));
       if(!req.PLM_Final_Review__c)
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Confirm PLM Final Review before submitting for approval'));
       if(!req.Legal_Final_Review__c)
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Confirm Legal Final Review before submitting for approval'));
       if(!req.HSSE_Final_Review__c)
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Confirm HSSE Final Review before submitting for approval'));
       if(!req.Marcomms_Final_Reivew__c)
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Confirm Marcoms Final Review before submitting for approval'));
      }
      if(Customer_Stage_1.contains(req.recordtype.name)){
       if(!req.Project_Plan__c)
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Confirm Project Plan is attached before submitting for approval'));
      }
      if(Customer_Stage_2.contains(req.recordtype.name)){
       if(!req.Project_Technical_Report__c)
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Confirm Technical Report is attached before submitting for approval'));
      }
      if(apexPages.getmessages().size() == 0)
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'OK to Submit for approval'));
}

}