public class MultiAdd
{
    
    //Will hold the account records to be saved
    public List<Test_Case_del__c>lstAcct  = new List<Test_Case_del__c>();
    //List of the inner class
    public List<innerClass> lstInner{get;set;} 
     
    //Will indicate the row to be deleted
    public String selectedRowIndex{get;set;}
      
    
    //no. of rows added/records in the inner class list
    public Integer count = 1;
    
    ////Save the records by adding the elements in the inner class list to lstAcct,return to the same page
    
    
    //New pages referenced under LAB Project.
    //@Rajeev
    public PageReference Save(){
    
         List<Sample_Analysis_Request__c> c = [Select id, recordtypeid,RecordTypeName__c From Sample_Analysis_Request__c Where Id = :ApexPages.currentPage().getParameters().get('00Nc0000000Sthg_lkid')];
         PageReference pr;
         
        if (c[0].RecordTypeName__c == 'Customer Competitive') {
           pr = new PageReference('/apex/SampleViewCustomerCompetitive?id='+ApexPages.currentPage().getParameters().get('00Nc0000000Sthg_lkid'));
 
        }
        else if (c[0].RecordTypeName__c == 'Customer Complaint') {

           pr = new PageReference('/apex/SampleViewCustomerComplaint?id='+ApexPages.currentPage().getParameters().get('00Nc0000000Sthg_lkid'));
 
        } 
        else if (c[0].RecordTypeName__c == 'Customer Value Add') {
          
           pr = new PageReference('/apex/SampleViewCustomerValueAdd?id='+ApexPages.currentPage().getParameters().get('00Nc0000000Sthg_lkid'));
 
        }
        else if (c[0].RecordTypeName__c == 'Plant') {
            
           pr = new PageReference('/apex/SampleViewPlant?id='+ApexPages.currentPage().getParameters().get('00Nc0000000Sthg_lkid'));
 
        }
        else if (c[0].RecordTypeName__c == 'Supplier') {
           
           pr = new PageReference('/apex/SampleViewSupplier?id='+ApexPages.currentPage().getParameters().get('00Nc0000000Sthg_lkid'));
 
        }       
        else {
          pr = new PageReference('/' + c[0].id + '/e');
            
        } 
        
        for(Integer j = 0;j<lstInner.size();j++){
        
            lstAcct.add(lstInner[j].acct);
        } 
        
        insert lstAcct;
        pr.setRedirect(True);
        return pr;
    }
        
    //add one more row
    public void Add()
    {   
        count = count+1;
        addMore();      
    }
    
    /*Begin addMore*/
    public void addMore(){
    
        //call to the inner class constructor
        innerClass objInnerClass = new innerClass(count);
        //add the record to the inner class list
        lstInner.add(objInnerClass);           
    }/* end addMore*/
    
    
    /* begin delete */
    public void Del(){
    
        lstInner.remove(Integer.valueOf(selectedRowIndex)-1);
        count = count - 1;
        
    }/*End del*/
    
    
    
    /*Constructor*/
    public MultiAdd(ApexPages.StandardController ctlr){

        lstInner = new List<innerClass>();
        addMore();
        selectedRowIndex = '0';
        
    }/*End Constructor*/
        


    /*Inner Class*/
    public class innerClass
    {       
        /*recCount acts as a index for a row. This will be helpful to identify the row to be deleted */
        public String recCount
        {get;set;}
        
        
        public Test_Case_del__c acct 
        {get;set;}
        
        /*Inner Class Constructor*/
        public innerClass(Integer intCount)
        {
            recCount = String.valueOf(intCount);        
            
            /*create a new account*/
            acct = new Test_Case_del__c();
            acct.Test_Name_del__c=ApexPages.currentPage().getParameters().get('00Nc0000000Sthg_lkid');
        }/*End Inner class Constructor*/    
    }/*End inner Class*/
}/*End Class*/