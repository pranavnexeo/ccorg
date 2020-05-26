public class monthlyPlantHoursController {
public Monthly_Plant_Hour__c MonthlyPlant { get; set; }
    
    public String ReportingMonth{get; set;} 
      public String ReportingYear{get; set;}
      public String RM{get; set;}
      public String RY{get; set;}
      Integer CurrentYear = datetime.now().year();
      String curryr = string.valueof(CurrentYear);
      String nextyr = string.valueof(CurrentYear+1);
      String prevfiveyr = string.valueof(CurrentYear-5);
      String prevforyr = string.valueof(CurrentYear-4);
      String prevthreeyr = string.valueof(CurrentYear-3);
      String prevtwoyr = string.valueof(CurrentYear-2);
      String prevyr = string.valueof(CurrentYear-1);
    public final Apexpages.Standardcontroller controller;
      List<Monthly_Plant_Hour__c> uniqueCustomObjectSet = new List<Monthly_Plant_Hour__c>();
                
    public monthlyPlantHoursController(Apexpages.Standardcontroller sc){
    MonthlyPlant =(Monthly_Plant_Hour__c)sc.getRecord();
    this.controller=sc;
    }
           
           public monthlyPlantHoursController(){
 }
   public Monthly_Plant_Hour__c getfacility()
    {
        return MonthlyPlant;
    }
 List<Incident_Record__c> incidentrec = new List<Incident_Record__c>();
 List<Id> incidentid = new List<Id>();
public Integer count;
public Integer countfatalities;
public Integer countdaysaway;
public Integer countmedicaltreatment;
public Integer countlostwork;
public Integer countemployee;
public Decimal employeepercent;
    public List<selectOption> getreportmonth() {
        List<selectOption> options = new List<selectOption>(); 
        options.add(new selectOption('', '- None -'));
        options.add(new selectOption('1', '1'));
        options.add(new selectOption('2', '2'));
        options.add(new selectOption('3', '3'));
        options.add(new selectOption('4', '4'));
        options.add(new selectOption('5', '5'));
        options.add(new selectOption('6', '6'));
        options.add(new selectOption('7', '7'));
        options.add(new selectOption('8', '8'));
        options.add(new selectOption('9', '9'));
        options.add(new selectOption('10', '10'));
        options.add(new selectOption('11', '11'));
        options.add(new selectOption('12', '12')); 
        
        return options; 
    }
     
    public List<selectOption> getreportyear() {
    List<selectOption> options = new List<selectOption>(); 
        options.add(new selectOption('', '- None -'));
        options.add(new selectOption(prevfiveyr, prevfiveyr));
        options.add(new selectOption(prevforyr, prevforyr));
        options.add(new selectOption(prevthreeyr, prevthreeyr));
        options.add(new selectOption(prevtwoyr, prevtwoyr));
        options.add(new selectOption(prevyr, prevyr));
        options.add(new selectOption(curryr, curryr));
        options.add(new selectOption(nextyr, nextyr));             
        return options;         
    }
    
    public Integer Incedentnumber() {
            String type='Injury/Illness/Just Reporting';
            List<Incident_Record__c> incident = [SELECT Incident_Date__c FROM Incident_Record__c WHERE Type_of_Incident__c includes (:type)];
            System.debug('recod is :'+ incident);
            for(integer i=0;i<incident.size();i++){
                Integer hs = incident[i].Incident_Date__c.year();
                Integer ms = incident[i].Incident_Date__c.month();
                String m = string.valueof(ms);      
                String y = string.valueof(hs);     
                if((MonthlyPlant.Reporting_Year__c == y)&&(MonthlyPlant.Reporting_Month__c == m)){
                System.debug('In side first if :');
                incidentrec.add(incident[i]);
                count=incidentrec.size();
                }
            }
           return count;
    }
    public Integer Fatalitynumber() {
            String type='Fatality';
            List<Incident_Record__c> incident = [SELECT Incident_Date__c FROM Incident_Record__c WHERE Classification_of_injury__c =: type];
            System.debug('recod is :'+ incident);
            for(integer i=0;i<incident.size();i++){
                Integer hs = incident[i].Incident_Date__c.year();
                Integer ms = incident[i].Incident_Date__c.month();
                String m = string.valueof(ms);      
                String y = string.valueof(hs); 
                if((MonthlyPlant.Reporting_Year__c == y)&&(MonthlyPlant.Reporting_Month__c == m)){
                    incidentrec.add(incident[i]);
                countfatalities=incidentrec.size();
                }
            }
           return countfatalities;
    }
    public Integer Daysawayfromworknumber() {
            String type='Days Away from Work';
            List<Incident_Record__c> incident = [SELECT Incident_Date__c FROM Incident_Record__c WHERE Classification_of_injury__c =: type];
            System.debug('recod is :'+ incident);
            for(integer i=0;i<incident.size();i++){
                Integer hs = incident[i].Incident_Date__c.year();
                Integer ms = incident[i].Incident_Date__c.month();
                String m = string.valueof(ms);      
                String y = string.valueof(hs); 
                if((MonthlyPlant.Reporting_Year__c == y)&&(MonthlyPlant.Reporting_Month__c == m)){
                    incidentrec.add(incident[i]);
                countdaysaway=incidentrec.size();
                }
            }
           return countdaysaway;
    }
    public Integer Medicalnumber() {
            String type='Medical Treatment beyond First Aid';
            List<Incident_Record__c> incident = [SELECT Incident_Date__c FROM Incident_Record__c WHERE Classification_of_injury__c =: type];
            System.debug('recod is :'+ incident);
            for(integer i=0;i<incident.size();i++){
                Integer hs = incident[i].Incident_Date__c.year();
                Integer ms = incident[i].Incident_Date__c.month();
                String m = string.valueof(ms);      
                String y = string.valueof(hs); 
                if((MonthlyPlant.Reporting_Year__c == y)&&(MonthlyPlant.Reporting_Month__c == m)){
                    incidentrec.add(incident[i]);
                countmedicaltreatment=incidentrec.size();
                }
            }
           return countmedicaltreatment;
    }
    public Integer Lostworknumber() {
            String type='Restricted Work';
            String type1='Off the job';
            String losttime='Multiple Lost Time (employees / directly supervised contractors)';
            List<Incident_Record__c> incident = [SELECT Incident_Date__c FROM Incident_Record__c WHERE Elements_associated_with_this_Incident__c =: losttime AND (Classification_of_injury__c =: type OR Classification_of_injury__c =: type1)];
            System.debug('recod is :'+ incident);
            for(integer i=0;i<incident.size();i++){
                Integer hs = incident[i].Incident_Date__c.year();
                Integer ms = incident[i].Incident_Date__c.month();
                String m = string.valueof(ms);      
                String y = string.valueof(hs); 
                if((MonthlyPlant.Reporting_Year__c == y)&&(MonthlyPlant.Reporting_Month__c == m)){
                    incidentrec.add(incident[i]);
                countlostwork=incidentrec.size();
                }
            }
           return countmedicaltreatment;
    }
    public Integer Employeenumber() {
            List<Incident_Record__c> incident = [SELECT CreatedById,Incident_Date__c FROM Incident_Record__c];
                System.debug('created by user count :' + incident);
                Set<Id> createdid=new Set<Id>();
                for(integer i=0;i<incident.size();i++){
                Integer hs = incident[i].Incident_Date__c.year();
                Integer ms = incident[i].Incident_Date__c.month();
                String m = string.valueof(ms);      
                String y = string.valueof(hs); 
                if((MonthlyPlant.Reporting_Year__c == y)&&(MonthlyPlant.Reporting_Month__c == m)){
                    createdid.add(incident[i].CreatedById);
                    System.debug('created by user new:' + createdid);
                }
                countemployee=createdid.size();
            }
           return countemployee;
    }
    
    public Decimal Employeepercent(){
        Integer incident = [SELECT count() FROM User];
        Employeenumber();
        employeepercent=countemployee/incident;
        return employeepercent;
    }
    
     public string getCountry(){
        List<Site_RIM_Information__c> country = [SELECT Country__c FROM Site_RIM_Information__c where MainSitePick__c=:MonthlyPlant.Facility__c];
        if(Country.Size()>0)
        {
        return country[0].Country__c;
        }
        else
        {
        return '';
        }
    }   
    
    public string getState(){
        List<Site_RIM_Information__c> state = [SELECT State__c FROM Site_RIM_Information__c where MainSitePick__c=:MonthlyPlant.Facility__c];
        if(state.Size()>0)
        {
        return state[0].State__c;
        }
        else
        {
        return '';
        }
            }
        
    
    public PageReference saveCustom() {
        Incedentnumber();
        MonthlyPlant.Incidents__c= count;
        Fatalitynumber();
        MonthlyPlant.Fatalities__c=countfatalities;
        Daysawayfromworknumber();
        MonthlyPlant.Days_Away_From_work__c=countdaysaway;
        Medicalnumber();
        MonthlyPlant.Medical_Treatment__c=countmedicaltreatment;
        Employeenumber();
        MonthlyPlant.Employees_Making_Entries__c=countemployee;
        Employeepercent();
        MonthlyPlant.Employees_Making_Entries1__c=employeepercent;
        String country=getCountry();
        MonthlyPlant.Country__c=country;
        String state=getState();
        MonthlyPlant.State__c=state;
        return controller.save();
        }
}