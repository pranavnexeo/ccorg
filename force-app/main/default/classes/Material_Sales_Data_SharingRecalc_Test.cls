@isTest
public class Material_Sales_Data_SharingRecalc_Test{
    public static testmethod void testMaterial_Sales_Data_Sharing(){
        Material_Sales_Data_SharingRecalc clsBatchSync = new Material_Sales_Data_SharingRecalc();
        ID idBatch = Database.executeBatch(clsBatchSync,1);
        SObject[] soa = new SObject[]{};
        clsBatchSync.start(null);
        clsBatchSync.execute(null,soa);
    
    }
}