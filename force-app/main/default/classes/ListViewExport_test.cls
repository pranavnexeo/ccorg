@isTest

public class ListViewExport_test{

     public static testMethod void test(){
     
       ListViewExport lve = new ListViewExport();
         try{
             lve.getnestedrecords();
         }catch(exception e){}
         lve.getresult();
         ListViewExport.ListViewColumn lvc = new ListViewExport.ListViewColumn();
         lvc.ascendingLabel = 'test';
         lvc.descendingLabel = 'test1';
         lvc.fieldNameOrPath = 'test1';
         lvc.Label = 'test1';
         lvc.hidden =true;
         lvc.selectListItem = 'test2';
         lvc.sortDirection = 'test3';
         lvc.sortIndex = 1;
         lvc.sortable = true;
         lvc.type = 'test3';
         try{
         lve.querydata();
         }catch(exception e){}
         ListViewExport.ListViewResult lvr = new ListViewExport.ListViewResult();
         //lve.calltoolingapi();
         lvr.query = 'test3';
     }
}