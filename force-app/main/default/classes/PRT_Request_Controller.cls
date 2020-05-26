public class PRT_Request_Controller{

   public Price_Request_Transaction__c priceRequest;
   Opportunity opportunity;
   Account account;
   String ValidationErrorMessage = '';
   public String getValidationErrorMessage() {return ValidationErrorMessage;}
   private List<Opportunity> opportunities;
   public String opportunitySelected = '';
   public String getOpportunitySelected() {return opportunitySelected;} 
   public void setOpportunitySelected(String s) {this.opportunitySelected = s;} 
   public PageReference init() {
       priceRequest = getpriceRequest();
       return null;
    
   }
  
   public String getPrice_Request_Link() {
    String result = '';    
    if (priceRequest != null)
      {
        if (priceRequest.Id != null)
          {
            result = priceRequest.Name;
          }
      }
    return result;   
  }
  
   public Price_Request_Transaction__c getpriceRequest() 
   {
       System.debug('getpriceRequest'+priceRequest);
       if (priceRequest == null) 
       {
           String priceRequestId = System.currentPageReference().getParameters().get('priceRequestId');
           System.debug('priceRequestId  value:'+priceRequestId); 
           if ((priceRequestId != '') && (priceRequestId != null))
           {
                priceRequest = [SELECT 
                                Id,Name,
                                Ship_To__c,
                                Sold_To__c 
                                FROM Price_Request_Transaction__c WHERE Id = :priceRequestId];
           }
           else {priceRequest = new Price_Request_Transaction__c();}
       }

       return priceRequest;
   }
  
   public Opportunity getOpportunity() {
       System.debug('getOpportunity');
       priceRequest = getpriceRequest();

       opportunity = [select id,
                       AccountId,
                       OwnerId,
                       Name,
                       Description,
                       StageName,
                       Amount,
                       Probability
             from Opportunity where id = : priceRequest.Opportunity__c];
        
      
       return opportunity;
   }
  
   public PageReference Save_Price_Request_with_New_Opportunity() {
       PageReference result = null;
       ValidationErrorMessage = '';
       if (priceRequest != null) 
       {
           if (opportunitySelected != '')
           {
               priceRequest.Opportunity__c = opportunitySelected;
        
               update priceRequest;
               PageReference priceRequestPage = new PageReference('/' + priceRequest.id);
               priceRequestPage.setRedirect(true);
               result = priceRequestPage;
           }
           else
           {ValidationErrorMessage = System.label.Error_Opportunity_Not_Selected; }
       }
     return result;  
    }
  
  
   public PageReference Cancel_Save() {
       PageReference result = null;
       if (priceRequest != null) 
       {
          PageReference priceRequestPage = new PageReference('/' + priceRequest.id);
          priceRequestPage.setRedirect(true);
          result = priceRequestPage;
       }
       return result;  
   }
  
   public String getAlreadyHaveOpportunityMessage() {
       System.debug('inside getAlreadyHaveOpportunityMessage');
       String result = '';
       getpriceRequest();

        //result = system.label.Warning_Opp_Associated_1 + '<a HREF="/' + opportunity.Id + '" target="_blank">' + opportunity.Name + '</a>.' + system.label.Warning_Opp_Associated_2;
  
    return result;      
  }
  
   public Integer getOpportunityRelatedtoParentAccount_Count() {
       System.debug('inside getOpportunityRelatedtoParentAccount_Count');
       Integer result = 0;
       getOpportunities();
       if (opportunities != null)
       {
          result = opportunities.size();
       }
       return result;
   } 
  
   public List<Opportunity> getOpportunities() {
       System.debug('inside getOpportunities');  
       if ( opportunities == null ) {
       try {
           system.debug('priceRequest.Ship_To__c : '+priceRequest.Ship_To__c);
           opportunities = [SELECT id,
                              Name,
                              RecordType.Name,
                              Description,
                              StageName,
                              CloseDate
                         FROM Opportunity where AccountId  = : priceRequest.Ship_To__c or AccountId = : priceRequest.Sold_To__c]; }
           catch (Exception e) {}
          
        }
        return opportunities;
   }

}