public class SampleManufacturer{  
 public SampleManufacturer(ApexPages.StandardSetController controller)   
 {   }   
 public PageReference next()  
  {      
   PageReference newpage = new PageReference('/'+ApexPages.currentPage().getParameters().get('Id'));       
   return newpage;  
    } 
  }