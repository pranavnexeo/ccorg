public class DuplicateMonthTests{
    static testMethod void testDuplicateMonth() {
       Site_Information__c c1=new Site_Information__c(Name='Corporate Incident-New Corporate Incident');
        insert c1;
    Site_Information__c  c=new Site_Information__c(Name='test2');
    insert c;
      Set<String> month = new Set<String>();
      Set<String> year = new Set<String>();
      month.add('test1');
      month.add('test2');
      month.add('test3');
      month.add('test4');
      month.add('test5');
      year.add('year1');
      year.add('year2');
      year.add('year3');
      year.add('year4');
      year.add('year5');
      
      System.assert([SELECT count() FROM Monthly_Plant_Hour__c
                     WHERE Reporting_Month__c IN :month] == 0);
        
      
      Site_Information__c site = new Site_Information__c();
      Monthly_Plant_Hour__c lead1 = new Monthly_Plant_Hour__c(Facility__c=c1.id,Reporting_Year__c='year1',
                            Reporting_Month__c='test1');
      Monthly_Plant_Hour__c lead2 = new Monthly_Plant_Hour__c(Facility__c=c1.id,Reporting_Year__c='year2',
                            Reporting_Month__c='test2');
      Monthly_Plant_Hour__c lead3 = new Monthly_Plant_Hour__c(Facility__c=c1.id,Reporting_Year__c='year3',
                            Reporting_Month__c='test3');
      Monthly_Plant_Hour__c[] leads = new Monthly_Plant_Hour__c[] {lead1, lead2, lead3};
      insert leads;
       
    
      Monthly_Plant_Hour__c dup1 = new Monthly_Plant_Hour__c(Facility__c=c1.id,Reporting_Year__c='year1',
                            Reporting_Month__c='test1');
      try {
         insert dup1;
         
      } catch (DmlException e) {
         
      } 
    
      dup1 = new Monthly_Plant_Hour__c(Id = lead1.Id, Facility__c=c1.id,Reporting_Year__c='year1',
                            Reporting_Month__c='test2');
      try {
         update dup1;
      } catch (DmlException e) {
         
        }
    
         
      dup1 = new Monthly_Plant_Hour__c(Facility__c=c1.id,Reporting_Year__c='year4',
                            Reporting_Month__c='test4');
      Monthly_Plant_Hour__c dup2 = new Monthly_Plant_Hour__c(Facility__c=c1.id,Reporting_Year__c='year3',
                            Reporting_Month__c='test2');
      Monthly_Plant_Hour__c dup3 = new Monthly_Plant_Hour__c(Facility__c=c1.id,Reporting_Year__c='year3',
                            Reporting_Month__c='test2');
      Monthly_Plant_Hour__c[] dups = new Monthly_Plant_Hour__c[] {dup1, dup2, dup3};
      try {
         insert dups;
        
      } catch (DmlException e) {

      }
    
       
    
      dup1 = new Monthly_Plant_Hour__c(Id=lead1.Id, Reporting_Year__c='year4', Reporting_Month__c='test4');
      dup2 = new Monthly_Plant_Hour__c(Id=lead2.Id, Reporting_Year__c='year3', Reporting_Month__c='test2');
      dup3 = new Monthly_Plant_Hour__c(Id=lead3.Id, Reporting_Year__c='year1', Reporting_Month__c='test2');
      dups = new Monthly_Plant_Hour__c[] {dup1, dup2, dup3};
      try {
         update dups;
         
      } catch (DmlException e) {
         
        }
        
      
    
      dup1 = new Monthly_Plant_Hour__c(Facility__c=c.id,Reporting_Year__c='year4',
                            Reporting_Month__c='test4');
      dup2 = new Monthly_Plant_Hour__c(Facility__c=c.id,Reporting_Year__c='year2',
                            Reporting_Month__c='test2');
      dup3 = new Monthly_Plant_Hour__c(Facility__c=c.id,Reporting_Year__c='year3',
                            Reporting_Month__c='test3');
      dups = new Monthly_Plant_Hour__c[] {dup1, dup2, dup3};
      try {
         insert dups;
         
      } catch (DmlException e) {
        
      }
      
      dup1 = new Monthly_Plant_Hour__c(Id=lead1.Id, Reporting_Year__c='year4', Reporting_Month__c='test4');
      dup2 = new Monthly_Plant_Hour__c(Id=lead2.Id, Reporting_Year__c='year3', Reporting_Month__c='test3');
      dup3 = new Monthly_Plant_Hour__c(Id=lead3.Id, Reporting_Year__c='year2', Reporting_Month__c='test2');
      dups = new Monthly_Plant_Hour__c[] {dup1, dup2, dup3};
      try {
         update dups;
         
      } catch (DmlException e) {
        
      }
   }
}