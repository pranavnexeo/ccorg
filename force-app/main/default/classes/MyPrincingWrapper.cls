/**
* Description: Wrapper that is going to be used on the My Pricing page for the Customer Portal
* Date: 08 / 15 / 2018
* Developer: Ignacio Gonzalez
*/
public class MyPrincingWrapper implements Comparable {
    
    public String Id {get; set;}
    public String materialNumber {get; set;}
    public String materialDescription {get; set;}
    public String customerMaterialNumber {get; set;}
    public String customerName {get; set;}
    public String pricingType {get; set;}
    public String description {get; set;}
    public String incoTerms {get; set;}
    public String sellerName {get; set;}
    public String sellerEmail {get; set;}
    public boolean isAscending {get; set;}
    public String fieldToSort {get; set;}
    public List<TierPricingWrapper> tierList {get; set;}
    
    public Integer compareTo(Object compareTo) { 
        MyPrincingWrapper objectToCompare = (MyPrincingWrapper)compareTo;
        if (fieldToSort == 'sellerName') {
            if(isAscending) {
                return this.sellerName.compareTo(objectToCompare.sellerName);
            } else {
                return objectToCompare.sellerName.compareTo(this.sellerName);
            }
        } else if (fieldToSort == 'incoTerms') {
            if(isAscending) {
                return this.incoTerms.compareTo(objectToCompare.incoTerms);
            } else {
                return objectToCompare.incoTerms.compareTo(this.incoTerms);
            }
        } else {
            return -1;
        }
        
    }
    
    
}