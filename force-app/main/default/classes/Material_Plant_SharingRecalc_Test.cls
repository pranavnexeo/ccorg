@isTest
    public class Material_Plant_SharingRecalc_Test{
        public static testmethod void test_sharing(){
            Material_Plant_SharingRecalc clsBatchSync = new Material_Plant_SharingRecalc();
            ID idBatch = Database.executeBatch(clsBatchSync,1);
            SObject[] soa = new SObject[]{};
            clsBatchSync.start(null);
            clsBatchSync.execute(null,soa);
        }    
}