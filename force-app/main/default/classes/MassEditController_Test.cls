@isTest
private class MassEditController_Test {

  public static testMethod void TestMassEditController() {
     contact c = new Contact(firstname = 'Test', Lastname='Contact', email='test@email.com');
     insert c;
     
     List<Contact> contacts = new list<Contact>{c}; 
     apexpages.currentpage().getparameters().put('returl', '/003/o');
     MassEditController mec = new MassEditController(new apexpages.standardsetcontroller(contacts));
     
     mec.masssave();
  }
}