global class Update_PriceSuppforSuppProf_Records{
 
    public void update_Method(){
        
        List<Supplier_Profile__c> SupplierProfileList = new List<Supplier_Profile__c>();
        List<Price_Support__c> priceSupportList = new List<Price_Support__c>();
        
        // select account ids as per checkbox
        SupplierProfileList = [select id,Vendor_PI__c,Supplier_Name__c,Supplier_Name__r.Name from Supplier_Profile__c where Update_Checkbox__c = TRUE];
        List<String> SuppProfileIds = new List<String>();
        Map<String,Supplier_Profile__c> SuppProfIdandSuppRecord = new Map<String,Supplier_Profile__c>();
        for(Supplier_Profile__c spp: SupplierProfileList ){
             SuppProfIdandSuppRecord.put(spp.Id,spp);
             spp.Update_Checkbox__c = FALSE;
             SuppProfileIds.add(spp.Id);
        }
        update SupplierProfileList ;
        // select price support objects which are related to accounts queried
        priceSupportList = [select id,Support_Type__c,Supplier_Profile_ID__c,Supplier_Name__c,Customer_soldto__c,Status__c,Customer_Type__c,Supplier_PI_Number__c from Price_Support__c where Supplier_Profile_ID__c IN: SuppProfileIds];
        
        // update price support records with new values
        for(Price_Support__c ps: priceSupportList){
            if(ps.Customer_Type__c=='PY-Payer'){
                if(ps.Support_Type__c == 'Rebate' && ps.Customer_soldto__c!=null  && ps.Status__c!='Rejected' && ps.Status__c!='Cancelled'&&(ps.Status__c=='Approved'||ps.Status__c=='Expired')){
                    system.debug('Name Testing'+SuppProfIdandSuppRecord.get(ps.Supplier_Profile_ID__c).Supplier_Name__r.Name);
                    system.debug('Map'+SuppProfIdandSuppRecord.get(ps.Supplier_Profile_ID__c));
                     system.debug('---------else pare open--------');
                   ps.SAP_Transfer__c = 'OPEN';
                    ps.Supplier_PI_Number__c = SuppProfIdandSuppRecord.get(ps.Supplier_Profile_ID__c).Vendor_PI__c;
                    ps.Supplier_Name__c      = SuppProfIdandSuppRecord.get(ps.Supplier_Profile_ID__c).Supplier_Name__r.Name;
                }
                else
                {
                    ps.Supplier_PI_Number__c = SuppProfIdandSuppRecord.get(ps.Supplier_Profile_ID__c).Vendor_PI__c;
                    ps.Supplier_Name__c      = SuppProfIdandSuppRecord.get(ps.Supplier_Profile_ID__c).Supplier_Name__r.Name;
                }
            }else if(ps.Support_Type__c == 'Rebate' && ps.Status__c!='Rejected' && ps.Status__c!='Cancelled'){
               if(ps.Status__c=='Approved'||ps.Status__c=='Expired'){
                system.debug('---------else pare open--------');
                ps.SAP_Transfer__c = 'OPEN';
                ps.Supplier_PI_Number__c = SuppProfIdandSuppRecord.get(ps.Supplier_Profile_ID__c).Vendor_PI__c;
                ps.Supplier_Name__c      = SuppProfIdandSuppRecord.get(ps.Supplier_Profile_ID__c).Supplier_Name__r.Name;
                }
            else{
               ps.Supplier_PI_Number__c = SuppProfIdandSuppRecord.get(ps.Supplier_Profile_ID__c).Vendor_PI__c;
               ps.Supplier_Name__c      = SuppProfIdandSuppRecord.get(ps.Supplier_Profile_ID__c).Supplier_Name__r.Name;
               }
            }
            if(ps.Support_Type__c == 'Upfront'  && ps.Status__c!='Rejected' && ps.Status__c!='Cancelled'){
                ps.Supplier_PI_Number__c = SuppProfIdandSuppRecord.get(ps.Supplier_Profile_ID__c).Vendor_PI__c;
                ps.Supplier_Name__c      = SuppProfIdandSuppRecord.get(ps.Supplier_Profile_ID__c).Supplier_Name__r.Name;
        }
        }
        update priceSupportList;
        
    }
}