/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Date_Functions_Test {

static testMethod void myUnitTest() {
        Test.startTest();

    DateTime now = System.now();
    Date datenow;
    
    System.debug('MonthYear = ' + Date_Functions.getYearMonth(now));
    
    datenow = Date_Functions.convertDateTimetoDate(now);
    
    System.debug('DateTime = ' + now);
    System.debug('Date = ' + datenow);
    
    List<Date> DatesIn = new List<Date>();
    DatesIn.Add(System.today());
    DatesIn.Add(System.today().addDays(5));
    DatesIn.Add(System.today().addDays(3));
    
    String d1 = Date_Functions.getFormattedDate(datenow, 1);

    String d2 = Date_Functions.getFormattedDateTime(now, 1);
    String d3 = Date_Functions.getFormattedDateTime(now, 2);
    String d4 = Date_Functions.getFormattedDateTime(now, 3);
    
    Date d5 = Date_Functions.stringToDate('12/26/1970');
    
    System.debug('Largest Date: ' + Date_Functions.returnLargestDate(DatesIn));

  }

}