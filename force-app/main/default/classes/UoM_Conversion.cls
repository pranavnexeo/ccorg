global class UoM_Conversion
{
    global class Result
    {
        webservice Double resultQty = 0;
        webservice Boolean resultFlag = False;
    }
    
    webservice static Result retrieve_UoM_Conversion(String mtrlNumber, Double qty, 
                                                     String UoM_From, String UoM_To)
    {
        Result res = new Result();
        Map<String, Double> numDenConvFactorMapByAltUOM = new Map<String, Double>();
        String tempToUOMCode;
        Double tempQty;
        
        List<SAP_UOM_Description__c> alist = [
            Select UOM_Code__c from SAP_UOM_Description__c where External_UOM__c =: UOM_From];
        if (alist == null || alist.isEmpty()) {return res;}
        
        String fromUOMCode = alist[0].UOM_Code__c;
                              
        List<SAP_UOM_Description__c> blist = [
            Select UOM_Code__c from SAP_UOM_Description__c where External_UOM__c =: UOM_To];
        if (blist == null || blist.isEmpty()) {return res;}

        String toUOMCode = blist[0].UOM_Code__c;
                        
        List<Material_UOM2__c> mtrlUOM2s = [Select Material_Number__c, Alternative_UOM__c, 
                                            Num_Den_Conversion_Factor__c from Material_UOM2__c 
                                            where Material_Number__c =: mtrlNumber];
        
        for(Material_UOM2__c m : mtrlUOM2s)
        numDenConvFactorMapByAltUOM.put(m.Alternative_UOM__c, m.Num_Den_Conversion_Factor__c);
        
        List<SAP_UOM_Code__c> sapUOMCodes = [Select Dimension_Key__c, UOM_Code__c from SAP_UOM_Code__c
                                             where UOM_Code__c IN: numDenConvFactorMapByAltUOM.keySet()];
               
        if((numDenConvFactorMapByAltUOM.keySet().contains(fromUOMCode)) && (numDenConvFactorMapByAltUOM.keySet().contains(toUOMCode)))
        {
            //Material Specific UOM conversion
            //Code for converting UOM_From to UOM_To
            res.resultQty = qty * numDenConvFactorMapByAltUOM.get(fromUOMCode) * (1/numDenConvFactorMapByAltUOM.get(toUOMCode));
            res.resultFlag = True;
        }              
        else if((!numDenConvFactorMapByAltUOM.keySet().contains(fromUOMCode)) && (!numDenConvFactorMapByAltUOM.keySet().contains(toUOMCode)))
        {
            //Global UOM Conversion
            SAP_UOM_Code__c sapFromUOMCode = [Select Dimension_Key__c, Num_Den_Conversion_Factor__c
                                              from SAP_UOM_Code__c where UOM_Code__c =: fromUOMCode];
                                              
            SAP_UOM_Code__c sapToUOMCode = [Select Dimension_Key__c, Num_Den_Conversion_Factor__c
                                            from SAP_UOM_Code__c where UOM_Code__c =: toUOMCode];                                  
            
            if(sapFromUOMCode.Dimension_Key__c == sapToUOMCode.Dimension_Key__c)
            {
                //Global UOM Conversion possible
                //Code for converting UOM_From to UOM_To
                res.resultQty = qty * sapFromUOMCode.Num_Den_Conversion_Factor__c * (1/sapToUOMCode.Num_Den_Conversion_Factor__c);
                res.resultFlag = True;
                
            }            
            else
            {
                //Global UOM Conversion not possible
                res.resultQty = 0;
                res.resultFlag = False;
            }
        }        
        else if((numDenConvFactorMapByAltUOM.keySet().contains(fromUOMCode)) && (!numDenConvFactorMapByAltUOM.keySet().contains(toUOMCode)))
        {
            SAP_UOM_Code__c sapToUOMCode = [Select Dimension_Key__c, Num_Den_Conversion_Factor__c
                                            from SAP_UOM_Code__c where UOM_Code__c =: toUOMCode];
                
            for(SAP_UOM_Code__c s : sapUOMCodes)
            {
                if(s.Dimension_Key__c == sapToUOMCode.Dimension_Key__c)
                tempToUOMCode = s.UOM_Code__c;
            }
            
            if(tempToUOMCode != null)
            {
                //UOM Conversion possible
                //Code for converting UOM_From to temp_UOM_To with Material Specific UOM Conversion
                tempQty = qty * numDenConvFactorMapByAltUOM.get(fromUOMCode) * (1/numDenConvFactorMapByAltUOM.get(tempToUOMCode));
                
                SAP_UOM_Code__c sapTempFromUOMCode = [Select Dimension_Key__c, Num_Den_Conversion_Factor__c
                                                      from SAP_UOM_Code__c where UOM_Code__c =: tempToUOMCode];    
                
                //Code for converting temp_UOM_To to UOM_To with Global UOM Conversion
                res.resultQty = tempQty * sapTempFromUOMCode.Num_Den_Conversion_Factor__c * (1/sapToUOMCode.Num_Den_Conversion_Factor__c);
                res.resultFlag = True;
            }
            else
            {
                //UOM Conversion not possible
                res.resultQty = 0;
                res.resultFlag = False;
            }
        }
        else if((!numDenConvFactorMapByAltUOM.keySet().contains(fromUOMCode)) && (numDenConvFactorMapByAltUOM.keySet().contains(toUOMCode)))
        {
            SAP_UOM_Code__c sapFromUOMCode = [Select Dimension_Key__c, Num_Den_Conversion_Factor__c
                                            from SAP_UOM_Code__c where UOM_Code__c =: fromUOMCode];
                                            
            for(SAP_UOM_Code__c s : sapUOMCodes)
            {
                if(s.Dimension_Key__c == sapFromUOMCode.Dimension_Key__c)
                tempToUOMCode = s.UOM_Code__c;
            }
            
            if(tempToUOMCode != null)
            {
                //UOM Conversion possible
                SAP_UOM_Code__c mtrlTempFromUOMCode = [Select Dimension_Key__c, Num_Den_Conversion_Factor__c
                                                      from SAP_UOM_Code__c where UOM_Code__c =: tempToUOMCode];
                                                      
                //Code for converting UOM_From to temp_UOM_To with Global UOM Conversion
                tempQty = qty * sapFromUOMCode.Num_Den_Conversion_Factor__c * (1/mtrlTempFromUOMCode.Num_Den_Conversion_Factor__c);
                
                //Code for converting temp_UOM_To to UOM_To with Material Specific UOM Conversion
                res.resultQty = tempQty * numDenConvFactorMapByAltUOM.get(tempToUOMCode) * (1/numDenConvFactorMapByAltUOM.get(toUOMCode));
                res.resultFlag = True;
            }
            else
            {
                //UOM Conversion not possible
                res.resultQty = 0;
                res.resultFlag = False;
            }
        }
        return res;
    }


/*
Test Methods
*/
public static testMethod void test01() {

        Result res = new Result();
/*
        system.debug('CS to UN'); 


        res = retrieve_UoM_Conversion('VV129',
                                          1,
                                         'CS',
                                         'UN');

        system.debug(res); 

        system.debug('CS to KG'); 


        res = retrieve_UoM_Conversion('VV129',
                                          1,
                                         'CS',
                                         'KG');
        system.debug(res); 

        system.debug('LB to KG'); 


        res = retrieve_UoM_Conversion('VV129',
                                          1,
                                         'LB',
                                         'KG');
        system.debug(res); 


        system.debug('CS to TO'); 

        res = retrieve_UoM_Conversion('VV129',
                                          1,
                                         'CS',
                                         'TO');
        system.debug(res); 

        system.debug('CS to TON'); 

        res = retrieve_UoM_Conversion('VV129',
                                          1,
                                         'CS',
                                         'TON');
        system.debug(res); 


        system.debug('CS to TOZ'); 

        res = retrieve_UoM_Conversion('VV129',
                                          1,
                                         'CS',
                                         'TOZ');
        system.debug(res); 


        system.debug('LB to CS'); 

        res = retrieve_UoM_Conversion('VV129',
                                          22,
                                         'LB',
                                         'CS');
        system.debug(res); 


        system.debug('KG to CS'); 

        res = retrieve_UoM_Conversion('VV129',
                                          10,
                                         'KG',
                                         'CS');
        system.debug(res); 
*/

        system.debug('000000000000050788 KG to LB'); 

        res = retrieve_UoM_Conversion('000000000000050788',
                                          10,
                                         'KG',
                                         'LB');
        system.debug(res); 
/*

        system.debug('000000000000050788 KG to GAL'); 

        res = retrieve_UoM_Conversion('000000000000050788',
                                          100,
                                         'KG',
                                         'GAL');
        system.debug(res); 

        system.debug('000000000000050788 KG to M3'); 

        res = retrieve_UoM_Conversion('000000000000050788',
                                          100,
                                         'KG',
                                         'M3');
        system.debug(res); 


        system.debug('000000000000050788 KG to DR'); 

        res = retrieve_UoM_Conversion('000000000000050788',
                                          100,
                                         'KG',
                                         'DR');
        system.debug(res); 

        system.debug('000000000000050788 RCU to KG'); 

        res = retrieve_UoM_Conversion('000000000000050788',
                                          1,
                                         'RCU',
                                         'KG');
        system.debug(res); 

        system.debug('000000000000050788 GAL to KG'); 

        res = retrieve_UoM_Conversion('000000000000050788',
                                          100,
                                         'GAL',
                                         'KG');
        system.debug(res); 

        system.debug('000000000000050788 M3 to LB'); 

        res = retrieve_UoM_Conversion('000000000000050788',
                                          100,
                                         'M3',
                                         'LB');
        system.debug(res); 
*/

       }

}