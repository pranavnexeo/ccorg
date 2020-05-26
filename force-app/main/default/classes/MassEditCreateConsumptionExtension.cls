public with sharing class MassEditCreateConsumptionExtension {

public list<Consumption__c>conslist{get; set;}
public list<ConWrapper> wrapperlist{get; set;}

public integer conslistsize{get; set;}
public double cindex{get; set;}
public string aid{get; set;}
public string RTID{get; set;}
public string url{get; set;}

public boolean selOneConFlag{get; set;}
public boolean selSameConsFlag{get; set;}
public boolean fromaccount{get; set;}
public boolean isChemicals{get; set;}
public boolean isComposites{get; set;}
public boolean isPlastics{get; set;}
public boolean isES{get; set;}
public boolean isDistribution{get; set;}
public boolean isAqualon{get; set;}
public boolean isPM{get; set;}
public boolean isNorthAmerica{get; set;}


public List<RecordType> RTList;


    public MassEditCreateConsumptionExtension(ApexPages.StandardsetController stdsetcontroller) {
       
        selSameConsFlag = true;
        selOneConFlag = true;
        isNorthAmerica = true;
        isChemicals = false;
        isPlastics = false;
        isComposites = false;
        isES = false;
        isDistribution = false;
        isAqualon = false;
        isPM = false;
        fromAccount = false;
        
        url = apexpages.currentpage().getparameters().get('retURL');
        Map<String, Schema.RecordTypeInfo> RTMapCons = Consumption__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        
        list<consumption__c> cons = new list<consumption__c>();
        conslist = new list<consumption__c>();
        wrapperlist = new list<ConWrapper>();     
        cons = stdsetcontroller.getselected();
        selOneConFlag = (cons.size() > 0);
        aid = apexpages.currentpage().getparameters().get('retURL');
        aid = aid.substring(1);          
        
        Set<ID> conset = new set<ID>();
        for(consumption__c c:cons){
           conset.add(c.id);
        }
        
        if(SelOneConFlag == true){
        conslist = [select id, Account_Name__r.id, recordtypeid, name, Account_Customer_Classification__c,Account_Name__c,Agent_Area__c,Annual_Usage_T_Y__c,Annual_Usage_Volume__c,Annual_Volume__c,Application__c,Ashland_Material_in_Use__c,Ashland_Material_Number__c,Base_Code_Description__c,Base_Code_Other__c,Channel_to_Market__c,Code__c,Comments__c,Competitor_Volume__c,Container__c,Container_Size__c,Converted_to_Opportunity__c,Corporate_Bid__c,Created_from_Lead__c,Created_from_Opportunity__c,Current_Supplier_Producer__c,Current_Supplier_Producer_Other__c,Density__c,Description__c,Direct_Volume__c,Distribution__c,Distribution_Volume__c,Distributor__c,End_User_City__c,End_User_Country__c,EPA_ID__c,FAMILY__c,FAMILY_Other__c,Flexural_Modulus__c,Grade__c,Lead_Source__c,Market__c,Material__c,Material_Trade_Name__c,MFI__c,Multinationals_Groups_Distributors__c,of_Filler_Content_or_Comonomer__c,Offsite_Waste_Management__c,Onsite_Waste_Management__c,Other_Material_in_Use__c,Page_Number__c,Price__c,Price_Specify_Year_Updated__c,Product_Description__c,Product_Group__c,Product_Group_FAMILY__c,Product_Tradename__c,Product_Type__c,Record_Source__c,Region__c,Related_Account_Name__c,RelatedOpportunity__c,Reporting_Year__c,SAP_Material__c,SAP_Product_Group__c,Secondary_Volume__c,Segment_Class__c,Slip_Antiblocking__c,Source_Code__c,Source_Description__c,Status__c,Sub_Segment__c,Sum_All_Volumes__c,Supplier_Lead_ID_No__c,Supplier_Producer__c,Tarnell_Annual_Q1_Report__c,Tarnell_Annual_Q2_Report__c,Tarnell_Annual_Q3_Report__c,Tarnell_Annual_Q4_Report__c,Tarnell_Annual_Volume_Manual__c,Tarnell_Sales__c,Technology__c,Technology_Activity__c,Tons_Generated__c,Tons_Managed_Offsite__c,Tons_Managed_Onsite__c,Type__c,Unit_of_Measure__c,Volume_specify_year_updated__c,Waste_Form_Code__c,Waste_Form_Description__c,  Nexeo_Competitor__c from Consumption__c where id in :conset];    
        RTID = conslist[0].recordtypeid;
        
        for(consumption__c c:conslist){
           wrapperlist.add(new conwrapper(c));
        }
        
         if(!aid.contains('?')){ fromAccount = true;}                    
            else{     
                fromAccount = true;   
                string firstaccountid = conslist[0].Account_name__r.id;         
                if(selOneConFlag == true){                                 
                    for(consumption__c c:conslist){                                      
                        if(c.RecordTypeid != RTID)            
                        {              
                            selSameConsFlag = False;              
                            break;            
                        }   
                        if(c.Account_name__r.id != firstaccountid)
                        {
                            fromAccount = false;
                        }      
                    }
                } 
                if(fromAccount == true){ aid = firstaccountid;}
             } 
           
        isNorthAmerica = true;  
        if(RTID == RTMapCons.get('Distribution RTK').getrecordtypeid()){isES = true;}
        if(RTID == RTMapCons.get('Distribution Chemicals').getrecordtypeid()){ ischemicals = true;}
        if(RTID == RTMapCons.get('Distribution Plastics').getrecordtypeid()){isPlastics = true;}
        if(RTID == RTMapCons.get('Distribution Composites').getrecordtypeid()){iscomposites = true;}
        if(RTID == RTMapCons.get('Aqualon Consumption').getrecordtypeid()){isAqualon = true;}
        if(RTID == RTMapCons.get('PM China').getrecordtypeid()){isPM = true;}
        if(RTID == RTMapCons.get('Distribution Plastics EMEA').getrecordtypeid()) {isPlastics = true; isNorthAmerica = false;}
        
        
        
      }
    system.debug('After Init Wrapperlist: ' + wrapperlist);
    system.debug('After Init Conslist: ' + Conslist);
    }
    
    public pagereference cancel(){
        
        return new pagereference('/' + aid);
    }
   
    public pagereference save(){
    boolean haserror = false;  
    system.debug('Before Save: ' + wrapperlist); 
    boolean isvalid = false;
    List<Consumption__c> clist = new list<Consumption__c>();
    
    for(ConWrapper CW:Wrapperlist){
     isvalid = Conisvalid(CW);
     CW.isvalid = isvalid;
     if(isvalid == true){
        clist.add(cw.con);
     }else{  haserror = true;  }
         
     }
     
     upsert clist;
     system.debug('After Save: ' + wrapperlist);
     
     if(haserror == true){ return null; }
     else{  return new pagereference('/' + aid);}
    }
    
    public pagereference saveandcontinue(){
   
    boolean isvalid = false;
    for(ConWrapper CW:Wrapperlist){
     isvalid = Conisvalid(CW);
     CW.isvalid = isvalid;
     if(isvalid == true){
     if(CW.Con.id != null)
       { update CW.Con;}
     else {insert CW.Con; }   
     } 
     }
      
      return null;     
    }
    
    public boolean conisvalid(ConWrapper cw){
      boolean returnvalue = true;
      If(cw.con.status__c == 'Active' &&
         cw.con.distribution_volume__c != null && 
         cw.con.Nexeo_Competitor__c == null)
         {
            returnvalue = false;
            cw.isvalid = false;          
         }
      if(returnvalue == true) {cw.isvalid = true;}
      return returnvalue;
    }
    
   public pagereference removeline() {
        
        system.debug('CINDEX: ' + Cindex);
        
        for(integer i = 0; i<wrapperlist.size(); i++){
          if(wrapperlist.get(i).id == cindex){
              system.debug('ID TO REMOVE: ' + wrapperlist.get(i).id + '-' + wrapperlist.get(i).con.id);
              wrapperlist.remove(i);
              
          }
        } 
        return null;
        
    }
    
    public pagereference clonecon(){
       Consumption__c c = new consumption__c();
       for(integer i = 0; i<wrapperlist.size(); i++){
          if(wrapperlist.get(i).id == cindex){
              c = wrapperlist.get(i).con.clone(false);
              wrapperlist.add(new conwrapper(c));
          }
        }
        return null;
   }
    
   public void insertrow() {
          consumption__c c = new consumption__c();
          c.recordtypeid = RTID;
          if(fromAccount == true){
          c.account_name__c = aid;}
          wrapperlist.add(new conwrapper(c));
    }
    
        public class ConWrapper{
        public Consumption__c con{get; set;}
        public Boolean isvalid{get; set;}
        public integer id{get; set;}
                
        public ConWrapper(Consumption__c c){
            con = c;
            isvalid = true;
            Double x = math.random() * 10000;
            Double y = math.random() * 10000;
            id = x.intvalue() * y.intvalue();       
        }
    }  
}