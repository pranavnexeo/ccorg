@isTest
public class plantHoursController_Test { 
     public static testMethod void myUnitTest() {
         Site_Information__c temp1 = new Site_Information__c(CreatedById = UserInfo.getUserId(), Name = 'test' );
         insert temp1;
         Plant_Hours_Report__c phrc = new Plant_Hours_Report__c(State__c = 'test',Country1__c = 'USA',Report_Year__c = '2005',Facility__c = temp1.Id);
         insert phrc;

         Plant_Hours_Report__c temp2 = new Plant_Hours_Report__c(Report_Year__c = '2005',State__c = 'test',Country1__c = 'US');
         insert temp2;
         
         Site_RIM_Information__c temp3 = new Site_RIM_Information__c(Country__c='USA',MainSitePick__c = temp1.Id);
         insert temp3;
         
         plantHoursController phc = new plantHoursController(new ApexPages.StandardController(phrc));
         plantHoursController phController = new plantHoursController();
         Incident_Record__c temp = new Incident_Record__c(CreatedById = UserInfo.getUserId(),Incident_Date__c = system.today(),Nexeo_Location_Associated_with_incident__c = temp1.Id);
         insert temp;
         phController.PlantHour = phrc;
         phController.countemployee = 6;
         phController.employeepercent = 3.4;
         phController.getfacility();
         phController.State = 'Test';
         phController.country1 = 'USA';
         phController.Employeepercent();
         phController.getCountry();
         phController.getState();
         phController.Employeenumber();
         PageReference pageRef = Page.PlantHoursRecord;
         Test.setCurrentPage(pageRef);
         String nextPage = phc.saveCustom().getUrl();
         //System.assertEquals('/apex/failure?error=noParam', nextPage);



         
     }
}