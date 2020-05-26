@isTest
public class Approval_Items_Controller_Test {

  public static testMethod void testApproval_Items_Controller() {
      Approval_Items_Controller aiController = new Approval_Items_Controller();
      
      User u = new User();
     // Id sid=new Id();
    //  Id TargetId=new Id();
      ProcessInstanceWorkItem i=new ProcessInstanceWorkItem();
      Approval_Items_Controller.Approval_Wrapper con=new Approval_Items_Controller.Approval_Wrapper('04bE0000000L1QH','01IE0000000QQnw' ,'TargetName','test',u,i );
      //aiController.Approval_Wrapper('005E0000000Zv8N', '005E0000000Zv8N', 'Target', 'Stringt', u, new ProcessInstanceWorkItem());
  }
}