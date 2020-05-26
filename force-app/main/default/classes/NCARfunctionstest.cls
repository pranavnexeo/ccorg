@isTest
public class NCARfunctionstest{
    public static testMethod void testNCAR()
    {
        String st = 'Approver';     
        String t1 = 'ES - Pricing';
        String t2 = 'ES - Not Communicated'; 
        String t3 = 'ES - CSR';   
        String t11 = 'ES - Incorrect Order / Account Information' ;
        String t21 = 'ES - Wrong Ship To' ; 
        String t31 = 'ES - Sales' ;
        String t32 = 'Batch / Supplier not noted';        
        String t33 = 'Nexeo Solutions Fleet';        
        String t34= 'ES - Billing';    
        String t35 ='External Carrier';        
        String t36 = 'Sales/PLM';        
        String t37 = 'Freight Forwarder';        
        String t38 = 'Supplier' ;        
        String t39 = 'Test';         
        String st2 = 'Evaluator';        
        String t310 =  'Batch / Supplier not noted';
        String st3 = 'Test2';          
        String t311 = 'Test3';   
 
        NCAR_Functions.determineRouteTo(st,t1,t2,t3);
        NCAR_Functions.determineRouteTo(st,t11,t21,t31);
        NCAR_Functions.determineRouteTo(st,t1,t2,t32);
        NCAR_Functions.determineRouteTo(st,t1,t2,t33);
        NCAR_Functions.determineRouteTo(st,t1,t2,t34);
        NCAR_Functions.determineRouteTo(st,t1,t2,t35);
        NCAR_Functions.determineRouteTo(st,t1,t2,t36);
        NCAR_Functions.determineRouteTo(st,t1,t2,t37);
        NCAR_Functions.determineRouteTo(st,t1,t2,t38);
        NCAR_Functions.determineRouteTo(st,t1,t2,t39);
        NCAR_Functions.determineRouteTo(st2,t1,t2,t310);
        NCAR_Functions.determineRouteTo(st2,t1,t2,t311);
        NCAR_Functions.determineRouteTo(st3,t1,t2,t310);
                
    }
}