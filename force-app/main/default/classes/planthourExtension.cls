public class planthourExtension {
    private final Plant_Hours_Report__c plant;
    public String year;
    public String previousYear;
    public Integer intYear = 0;
    public Integer intPreviousYear = 0;
    public String reporttype;
    public String reportperiod;
    public String reportCategory;
    public String facility;
    public String country;
    public String plantDivision;
    List<Decimal> cumulativemanhr=new List<Decimal>();
    List<Decimal> cummanhr1 = new List<Decimal>();
    List<Decimal> avgemployee = new List<Decimal>();
    Decimal cum = 0;
    decimal hr = 0;
    List<Monthly_Plant_Hour__c> incidentrec = new list<Monthly_Plant_Hour__c>();    
    public string firstWhereClause = '';
    public string secondWhereClause = '';
    public string secondWhereClause1 = '';
    public List<string> mon = new List<String>();
    private List<string> monthquery{get; set;}
    private List<String> monthquery1{get; set;}
   
    public planthourExtension(ApexPages.StandardController controller) {
        
      this.plant = (Plant_Hours_Report__c)controller.getRecord();
      Plant_Hours_Report__c o = [Select Country__c,Division_div__c,Facility__c, Reporting_Category__c,
                                     Report_Year__c,Report_Type__c,Reporting_Period__c
                                         From Plant_Hours_Report__c Where Id =: plant.Id];
                                         
        year= o.Report_Year__c;
        if(year!= null){
            intYear = Integer.valueof(year);
            intPreviousYear = intYear - 1;
            previousYear = String.valueof(intPreviousYear);
         }
        reporttype=o.Report_Type__c;
        reportperiod=o.Reporting_Period__c;
        facility = o.Facility__c;
        reportCategory = o.Reporting_Category__c;
        plantDivision = o.Division_div__c;
        country = o.Country__c;
        system.debug('reporttype is '+reporttype);
        
        if(reporttype == 'Facility'){
            firstWhereClause = 'Facility__c = \''+facility+'\' and Reporting_Category__c =\''+reportCategory+'\'';
        }else if(reporttype == 'Sub'){
            firstWhereClause = ' Country__c =  \''+country+'\'  and Reporting_Category__c =\''+reportCategory+'\'';
        }else if(reporttype == 'Division'){
            firstWhereClause = '  Country__c = \''+country+'\' and Division__c = \''+plantDivision+'\'';
        }else {
            firstWhereClause = ' Country__c = \''+country+'\'';
        }
        
        Date currentDate = date.today();
        
        Integer currentMonth =  currentDate.month();
        system.debug('Current Month is'+currentMonth );
     
        monthQuery = new String[]{};
        monthQuery1 = new String[]{};
        
        if(reportperiod == 'Calendar'){
                    system.debug('Entered Calendar');
            for(Integer i=1;i<=currentMonth;i++ ){
                monthQuery.add('\''+String.valueof(i)+'\'');
            }
            system.debug('monthQuery is '+monthQuery);
            secondWhereClause = ' and Reporting_Year__c =\''+year+'\' and Reporting_Month__c in :monthQuery';
            
        }else if(reportperiod == 'Fiscal'){
                                system.debug('Entered Fiscal');
            if(currentMonth >= 10){
                for(Integer i=10;i<=currentMonth;i++ ){
                     monthQuery.add('\''+String.valueof(i)+'\'');
                }
            }else{
                for(Integer i=1;i<=currentMonth;i++ ){
                     monthQuery.add('\''+String.valueof(i)+'\'');
                }
                for(Integer i=10;i<=12;i++ ){
                     monthQuery1.add('\''+String.valueof(i)+'\'');
                }
            }
            secondWhereClause = ' and Reporting_Year__c =\''+year+'\' and Reporting_Month__c in :monthQuery';
            secondWhereClause1 = ' and Reporting_Year__c =\''+previousYear+'\' and Reporting_Month__c in :monthQuery1';
            
        }else if(reportperiod == 'Rolling'){
                        system.debug('Entered Rolling');
            for(Integer i=1;i<currentMonth;i++ ){
                 monthQuery.add('\''+String.valueof(i)+'\'');
            }
            for(Integer i=currentMonth;i<=12;i++ ){
                 monthQuery1.add('\''+String.valueof(i)+'\'');
            }
            
            secondWhereClause = '  and Reporting_Year__c =\''+year+'\' and Reporting_Month__c in :monthQuery ';
            secondWhereClause1 = ' and Reporting_Year__c =\''+previousYear+'\' and Reporting_Month__c in :monthQuery1 ';
        }
         
    }  
   
    
    public List<Monthly_Plant_Hour__c> getManhour() {
       
        List<Monthly_Plant_Hour__c> finalmph = new List<Monthly_Plant_Hour__c>();
        
        
        if(!secondWhereClause1.equals('')){
        
            List<Monthly_Plant_Hour__c> mph1= Database.query('SELECT Name,Month__c,Reporting_Month__c,Employee__c,Man_hours__c,'
                                            +'Reporting_Year__c FROM Monthly_Plant_Hour__c '
                                                +'where '+ firstWhereClause+ ' ' + secondWhereClause1 + ' order by Reporting_Month__c ');
                                            
            for(Integer i=0; i<mph1.size();i++){
                finalmph.add(mph1[i]);
            } 
        }       
        string q = 'SELECT Name,Month__c,Reporting_Month__c,Employee__c,Man_hours__c,'
                                            +'Reporting_Year__c FROM Monthly_Plant_Hour__c '
                                                +'where '+ firstWhereClause + ' ' +secondWhereClause + ' order by Reporting_Month__c ';
        system.debug(q);                                                               
        List<Monthly_Plant_Hour__c> mph= Database.query(q);
                                                
        for(Integer i=0; i<mph.size();i++){
            finalmph.add(mph[i]);
        }
                                                
        return finalmph;
    }
    
    public List<Decimal> getCumulativeManhour() {

        Decimal cummanhr = 0;
        Decimal cummanhrcum = 0;

        
        if(!secondWhereClause1.equals('')){
        
            List<Monthly_Plant_Hour__c> mph1= Database.query('SELECT Name,Reporting_Month__c,Employee__c,Man_hours__c,'
                                            +'Reporting_Year__c FROM Monthly_Plant_Hour__c '
                                                +'where '+ firstWhereClause+ ' ' + secondWhereClause1 + ' order by Reporting_Month__c ');
                                            
            if(mph1.size()>0){
                for(Integer i=0;i<mph1.size();i++)
                {
                    cummanhr =mph1[i].Man_hours__c;
                    cummanhrcum = cummanhrcum + cummanhr;
                    cummanhr1.add(cummanhrcum);
                }
            }
        }                              
        List<Monthly_Plant_Hour__c> mph= Database.query('SELECT Name,Reporting_Month__c,Employee__c,Man_hours__c,'
                                            +'Reporting_Year__c FROM Monthly_Plant_Hour__c '
                                                +'where '+ firstWhereClause + ' ' +secondWhereClause + ' order by Reporting_Month__c ');
                                                
        if(mph.size()>0){
            for(Integer i=0;i<mph.size();i++)
            {
                cummanhr =mph[i].Man_hours__c;
                cummanhrcum = cummanhrcum + cummanhr;
                cummanhr1.add(cummanhrcum);
            }
        }    
        return cummanhr1;
    }
    public List<Decimal> getAverageEmployee() {
        Integer i= 0;
        Integer j= 0;
        Decimal avgemp = 0;
        Decimal avgemployeeset = 0;
        
        if(!secondWhereClause1.equals('')){
        
            List<Monthly_Plant_Hour__c> mph1= Database.query('SELECT Name,Reporting_Month__c,Employee__c,Man_hours__c,'
                                            +'Reporting_Year__c FROM Monthly_Plant_Hour__c '
                                                +'where '+ firstWhereClause+ ' ' + secondWhereClause1 + ' order by Reporting_Month__c ');
                                            
            if(mph1.size()>0){
                
                avgemployeeset = 0;
                for(i=0;i<mph1.size();i++)
                {
                    avgemp =mph1[i].Employee__c;
                
                    avgemployeeset = ((avgemployeeset*i) + avgemp)/(i+1);
                    
                    avgemployee.add(avgemployeeset);
                    j = i+1;
                }
            }
        }                                            
        List<Monthly_Plant_Hour__c> mph= Database.query('SELECT Name,Reporting_Month__c,Employee__c,Man_hours__c,'
                                            +'Reporting_Year__c FROM Monthly_Plant_Hour__c '
                                                +'where '+ firstWhereClause + ' ' +secondWhereClause + ' order by Reporting_Month__c ');
                                                
        if(mph.size()>0){
            for(Integer m=0;m<mph.size();m++)
            {
                avgemp =mph[m].Employee__c;
               
                avgemployeeset = ((avgemployeeset*j) + avgemp)/(j+1);
               
                avgemployee.add(avgemployeeset);
                j++;
            }
        }
        
        return avgemployee;
    }
    
    
    public List<Monthly_Plant_Hour__c> getCumulativeRolling() {
        
        List<Monthly_Plant_Hour__c> finalmph = new List<Monthly_Plant_Hour__c>();
        
        if(!secondWhereClause1.equals('')){
            List<Monthly_Plant_Hour__c> mph1= Database.query('SELECT Name,Month__c,Reporting_Month__c,Incidents__c,Total_Recordable_Rate__c,'
                                           +' Lost_Work_Incidents__c,Lost_Work_Rate__c,Days_Away_From_work__c,'
                                               +'     Days_Away_From_Work_Rate__c,Medical_Treatment__c, '
                                                 +'     Medical_Treatment_Rate__c,Fatalities__c,'
                                                  +'          Reporting_Year__c FROM Monthly_Plant_Hour__c '
                                                              +'where '+ firstWhereClause+ ' ' + secondWhereClause1 + ' order by Reporting_Month__c ');
        
             for(Integer i=0; i<mph1.size();i++){
                finalmph.add(mph1[i]);
             }
        
        }
        List<Monthly_Plant_Hour__c> mph= Database.query('SELECT Name,Month__c,Reporting_Month__c,Incidents__c,Total_Recordable_Rate__c,'
                                           +' Lost_Work_Incidents__c,Lost_Work_Rate__c,Days_Away_From_work__c,'
                                               +'     Days_Away_From_Work_Rate__c,Medical_Treatment__c, '
                                                 +'     Medical_Treatment_Rate__c,Fatalities__c,'
                                                  +'          Reporting_Year__c FROM Monthly_Plant_Hour__c '
                                                              +'where '+ firstWhereClause+ ' ' + secondWhereClause + ' order by Reporting_Month__c ');
        
        for(Integer i=0; i<mph.size();i++){
            finalmph.add(mph[i]);
        }
        return finalmph;
    }
}