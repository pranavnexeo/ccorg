trigger UpdateParentSampleRequestwithMaterialSummary on Sample_Material__c (after insert, after update, after delete, after undelete) {

    List<Id> SampleIds = new List<Id>();
    List<Sample_Material__c> recsToProcess;
    map<id, boolean> isnanjing = new map<id, boolean>();
    map<id, String> Material_Plant = new map<id, string>();    

    if ((Trigger.isInsert) || (Trigger.isUpdate))
        recsToProcess = Trigger.new;
    else
        recsToProcess = Trigger.old;

    //List<Sample_Material__c> Sample_Materials = [SELECT Id, Sample_Request__c FROM Sample_Material__c WHERE Id IN :recsToProcess.Id];
   
    for(Sample_Material__c rec:recsToProcess) 
        {
        Boolean newId = true;
        
        for(Id SampleId:SampleIds) 
            {
            if(rec.Sample_Request__c == SampleId) 
                {
                newId = false;
                }
            }
            
        if (newId == true) {SampleIds.add(rec.Sample_Request__c);}
        
        if (isnanjing.containskey(rec.Sample_Request__c)){
            if(isnanjing.get(rec.sample_request__c) == false && rec.nanjing_material__c == true){
               isnanjing.put(rec.Sample_Request__c, true);          
            }
        }else{
           isnanjing.put(rec.Sample_Request__c, rec.nanjing_material__c);
        }
        
        if (!Material_Plant.containskey(rec.Sample_Request__c)){
            if(rec.material_Plant__c != null){
               Material_Plant.put(rec.Sample_Request__c, rec.Material_Plant__c);          
            }
        }
     
        }


    Map<String, Map<ID, String>> Sample_Request_Updates_Map = Sample_Material_Functions.SummarizeMaterialsonSampleRequests(SampleIds);
    Map<Id,String> Material_Map = Sample_Request_Updates_Map.get('Material');
    Map<ID,String> Product_Line_Map = Sample_Request_Updates_Map.get('Product Line');
    Map<ID,String> Shipping_Info_Map = Sample_Request_Updates_Map.get('Shipping Info');
    Map<ID,String> PAC_Info_Map = Sample_Request_Updates_Map.get('PAC Info');
    
    List<Sample_Request__c> Sample_Requests = new List<Sample_Request__c>();

    for(Id SampleId:SampleIds) 
        {
        Sample_Request__c sample_Update = new Sample_Request__c(Id=SampleId);
        sample_Update.Material_Summary__c = material_map.get(SampleId);
        sample_Update.AHWT_Product_Lines__c = product_line_map.get(SampleID);
        if(isnanjing.containskey(SampleID)){
        sample_Update.Nanjing_Material__c = isnanjing.get(SampleID);}
        if(material_plant.containskey(SampleID)){
        sample_Update.material_Plant__c = material_plant.get(SampleID);}
        Sample_Update.Shipping_Info_Summary__c = shipping_info_map.get(SampleID); 
        Sample_Update.PAC_Summary__c = PAC_Info_Map.get(SampleID);
        Sample_Requests.add(sample_Update);
        
        }
    
   update Sample_requests;
}