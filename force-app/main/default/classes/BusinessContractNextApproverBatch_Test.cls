@isTest
private class BusinessContractNextApproverBatch_Test {

  public static testMethod void testmybatch() {
      list<SObject> objs=new  list<SObject>();
    Database.executeBatch(new BusinessContractNextApproverBatch());
    BusinessContractNextApproverBatch  con=new BusinessContractNextApproverBatch();
    con.execute(null,objs);
  }
}