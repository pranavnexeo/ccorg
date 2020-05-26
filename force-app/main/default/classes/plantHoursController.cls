public class plantHoursController {
public Plant_Hours_Report__c PlantHour { get; set; }
    
    public String State{get; set;} 
    //public String Country{get; set;}
      
    public final Apexpages.Standardcontroller controller;
    List<Plant_Hours_Report__c> uniqueCustomObjectSet = new List<Plant_Hours_Report__c>();
                
    public plantHoursController(Apexpages.Standardcontroller sc){
    PlantHour =(Plant_Hours_Report__c)sc.getRecord();
    this.controller=sc;
    }
           
           public plantHoursController(){
 }
   public Plant_Hours_Report__c getfacility()
    {
        return PlantHour;
    }
 List<Incident_Record__c> incidentrec = new List<Incident_Record__c>();
 List<Id> incidentid = new List<Id>();
 List<Incident_Record__c> incident = new List<Incident_Record__c>();
public String country1;
public Integer countemployee;
public Decimal employeepercent;
    
        public Integer Employeenumber() {
            List<Incident_Record__c> incident = [SELECT CreatedById,Incident_Date__c FROM Incident_Record__c];
                System.debug('created by user count :' + incident);
                Set<Id> createdid=new Set<Id>();
                for(integer i=0;i<incident.size();i++){
                Integer hs = incident[i].Incident_Date__c.year();
                Integer ms = incident[i].Incident_Date__c.month();
                String m = string.valueof(ms);      
                String y = string.valueof(hs); 
                if(PlantHour.Report_Year__c == y){
                    createdid.add(incident[i].CreatedById);
                    System.debug('created by user new:' + createdid);
                }
                countemployee=createdid.size();
            }
           return countemployee;
    }
    
    public Decimal Employeepercent(){
        Integer incident = [SELECT count() FROM User];
        System.debug('user count :' + incident);
        Employeenumber();
        System.debug('user count in incident:' + countemployee);
        // Changes done by Abhishek to avoid nullpointer - START
        if(incident != null){
            employeepercent=countemployee/incident;
        }
        // Changes done by Abhishek to avoid nullpointer - END
        System.debug('user percent :' + employeepercent);
        return employeepercent;
    }
    
    public string getCountry(){
        // Changes done by Abhishek to avoid nullpointer - START
        List<Site_RIM_Information__c> country;
        if(PlantHour != null){
            country = [SELECT Country__c FROM Site_RIM_Information__c where MainSitePick__c=:PlantHour.Facility__c];
        }
        // Changes done by Abhishek to avoid nullpointer - END
        //country1=country.get(0);
        // Changes done by Abhishek to avoid nullpointer - START
        if(country != null){ 
            return country[0].Country__c;
        } else {
            return null;
        }
        // Changes done by Abhishek to avoid nullpointer - END
    }   
    
    public string getState(){
        List<Site_RIM_Information__c> state;
        if(PlantHour != null){
            state = [SELECT State__c FROM Site_RIM_Information__c where MainSitePick__c=:PlantHour.Facility__c];
        }
        //country1=country.get(0);
        // Changes done by Abhishek to avoid nullpointer - START
        if(state!= null){ 
            return state[0].State__c;
        } else {
            return null;
        }
        // Changes done by Abhishek to avoid nullpointer - END
    }
    
    public PageReference saveCustom() {
        Employeenumber();
        if(PlantHour != null)
            PlantHour.Employees_Making_Entries__c=countemployee;
        Employeepercent();
        if(PlantHour != null)
            PlantHour.Employees_Making_Entries1__c=employeepercent;
        String count = getCountry();
        if(count=='USA'){
        PlantHour.Country__c='USA Only';
        }
        else{
        PlantHour.Country__c='All';
        }
        String stat = getState();
        PlantHour.State__c=stat;
        return controller.save();
        }
}