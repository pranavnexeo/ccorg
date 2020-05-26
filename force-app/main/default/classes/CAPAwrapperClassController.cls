/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:         03/08/2016
*   Author:               Sneha Likhar
*   Short Description:  To update CAPA and NCAR records when CAPA will remove its related NCARs.
*   **********************************************************************************************************************/

public class CAPAwrapperClassController {

    Public id capaid;
    public boolean checklist{get;set;}
    public CAPAwrapperClassController(ApexPages.StandardController controller) {
    capaid = ApexPages.currentPage().getParameters().get('id');
    checklist = false; 
    
    }


    public List<cNCAR> ncarList {get; set;}

    public List<cNCAR> getNcars() {
        if(ncarList == null) {
            ncarList = new List<cNCAR>();
            for(NCAR_Cases__c c: [select Id, Name, Recordtypeid, Account__c , SAP_Division_Desc__c, CAPA__c, Status__c,SAP_CSR__c,Nexeo_Plant__c from NCAR_Cases__c where CAPA__c =:capaid]) { 
                ncarList.add(new cNCAR(c));
            }
        }
        if(ncarList.size()>0)
        checklist = true; 

            {

                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No NCARs Related to this CAPA');

                       ApexPages.addMessage(myMsg); 
            }
            
        return ncarList;
        
    }


    public PageReference processSelected() {

        List<NCAR_Cases__c> selectedNcars = new List<NCAR_Cases__c>();
                
         for(cNCAR cnr: getNcars()) {
            if(cnr.selected == true) {
               selectedNcars.add(cnr.con);
                
            }
        }
        List<NCAR_Cases__c> toupdate =New List<NCAR_Cases__c> ();
        List<NCAR_Cases__c> ncarupdate = New List<NCAR_Cases__c>([ select id,CAPA__c  from NCAR_Cases__c where id in:selectedNcars] );
        system.debug('Ncar update'+ ncarupdate );
       for(NCAR_Cases__c ncases: ncarupdate ) {
       If(ncases.CAPA__c!=null || ncases.CAPA__c!='')
         {
         ncases.CAPA__c = null ; 
         toupdate.add(ncases);
         system.debug('toupdate'+ toupdate);
         }
        }
        update toupdate;
        ncarList=null; 
        return null;
    }


        public class cNcar{
        public NCAR_Cases__c con {get; set;}
        public Boolean selected {get; set;}
        
         

        
        public cNcar(NCAR_Cases__c c) {
            con = c;
            selected = false;  
            
            
        }
    }
}