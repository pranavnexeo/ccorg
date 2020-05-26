@isTest
public class CalMonth_Test {
public static testMethod void testCalMonth() {
CalMonth con=new CalMonth(system.today());
Calmonth.Week con2=new Calmonth.Week();
Calmonth.Day con1=new Calmonth.Day(system.today(),08);
con.getValidDateRange();
con.getMonthName();
con.getYearName();
con.getfirstDate();

con2.getWeekNumber();
con2.getStartingDate(); 
con.getWeekdayNames();

con1.getshowmore();
con1.getDayOfMonth2();
con1.getDayOfYear();
con1.getDate();
con1.getDateString();
con1.getDayOfMonth();
con1.getDayAgenda();
con1.getFormatedDate();
con1.getDayNumber();
con1.geteventsTodayShort();
con1.getCSSName();
}
}