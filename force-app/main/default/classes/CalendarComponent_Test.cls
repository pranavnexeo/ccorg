@isTest
private class CalendarComponent_Test {

  static testMethod void myUnitTest() {
  List<CalEventItem> s=new  List<CalEventItem>();
  CalendarComponent cal=new CalendarComponent();
  cal.DisplayDate='12/12/2013';
  cal.getsobj();
  cal.setsobj(s);
  cal.showevent();
  cal.saveevent();

  }
  }