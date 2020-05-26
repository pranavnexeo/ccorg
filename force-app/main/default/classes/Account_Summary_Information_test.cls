//@istest(SeeAllData=true)
@istest
public class Account_Summary_Information_test{

    
    public static testmethod void test01(){
        Account_Summary_Information con = new Account_Summary_Information();
        Decimal d = 3.141;
        date myDate = date.today();
        date newDate = mydate.addDays(2);
        con.addData('Current Month',myDate,newDate,d,d,d,d,d,2.30,2.50,d,'USD');
        con.addData('PY Current Month',myDate,newDate,d,d,d,d,d,2.30,2.50,d,'USD');
        con.addData('FYTD',myDate,newDate,d,d,d,d,d,2.30,2.50,d,'USD');
        con.addData('PFYTD',myDate,newDate,d,d,d,d,d,2.30,2.50,d,'USD');
        con.getPFYStartDate();
        con.getCFYEndDate();
    }
}