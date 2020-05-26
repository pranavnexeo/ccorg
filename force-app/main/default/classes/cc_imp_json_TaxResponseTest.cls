@IsTest
public class cc_imp_json_TaxResponseTest {
    public static String json = '[{'+
        '   \"sfdc_account_id\": \"11-22-33\",'+
        '   \"sfdc_material_id\": \"44-55-1\",'+
        '   \"price\": \"8,144.65\",'+
        '   \"curr\": \"USD\",'+
        '   \"price_support\": \"\",'+
        '   \"ic_charge\": \"\",'+
        '   \"add_charge\": \"64.90\",'+
        '   \"mat_cost\": \"446.88\",'+
        '   \"warehouse_charge\": \"6.99\",'+
        '   \"freight_charge\": \"116.16\",'+
        '   \"rebate\": \"\",'+
        '   \"quantity\": \"660.02\",'+
        '   \"revenue\": \"8,209.55\",'+
        '   \"cost\": \"570.03\",'+
        '   \"contrib_margin\": \"7,639.52\",'+
        '   \"cm_percent\": \"93.06\",'+
        '   \"unit_cm\": \"11.575\",'+
        '   \"unit_mat_cost\": \"0.677\",'+
        '   \"unit_warehouse_chg\": \"0.011\",'+
        '   \"unit_freight_chg\": \"0.176\",'+
        '   \"subtotals\": [{'+
        '           \"posnr\": \"000010\",'+
        '           \"cm_group\": \"00\",'+
        '           \"cm_group_name\": \"Revenue\",'+
        '           \"cm_subtotal\": \"01\",'+
        '           \"cm_subtotal_name\": \"Price\",'+
        '           \"kwert\": \"8144.65 \",'+
        '           \"waers\": \"USD\"'+
        '       }, {'+
        '           \"posnr\": \"000010\",'+
        '           \"cm_group\": \"00\",'+
        '           \"cm_group_name\": \"Revenue\",'+
        '           \"cm_subtotal\": \"04\",'+
        '           \"cm_subtotal_name\": \"Additional charges\",'+
        '           \"kwert\": \"64.90 \",'+
        '           \"waers\": \"USD\"'+
        '       }, {'+
        '           \"posnr\": \"000010\",'+
        '           \"cm_group\": \"01\",'+
        '           \"cm_group_name\": \"Cost\",'+
        '           \"cm_subtotal\": \"07\",'+
        '           \"cm_subtotal_name\": \"Freight Charge\",'+
        '           \"kwert\": \"116.16 \",'+
        '           \"waers\": \"USD\"'+
        '       }, {'+
        '           \"posnr\": \"000010\",'+
        '           \"cm_group\": \"01\",'+
        '           \"cm_group_name\": \"Cost\",'+
        '           \"cm_subtotal\": \"05\",'+
        '           \"cm_subtotal_name\": \"Material cost\",'+
        '           \"kwert\": \"446.88 \",'+
        '           \"waers\": \"USD\"'+
        '       }, {'+
        '           \"posnr\": \"000010\",'+
        '           \"cm_group\": \"01\",'+
        '           \"cm_group_name\": \"Cost\",'+
        '           \"cm_subtotal\": \"06\",'+
        '           \"cm_subtotal_name\": \"WH Charge\",'+
        '           \"kwert\": \"6.99 \",'+
        '           \"waers\": \"USD\"'+
        '       }, {'+
        '           \"posnr\": \"000010\",'+
        '           \"cm_group\": \"03\",'+
        '           \"cm_group_name\": \"Exclude From Contribution Margin\",'+
        '           \"cm_subtotal\": \"09\",'+
        '           \"cm_subtotal_name\": \"Tax\",'+
        '           \"kwert\": \"6.99 \",'+
        '           \"waers\": \"USD\"'+
        '       }'+
        ''+
        '   ],'+
        '   \"status\": \"SUCCESS\",'+
        '   \"message\": \"\"'+
        '}]';
    
    static testMethod void testParse() {
        List<cc_imp_json_TaxResponse> obj = cc_imp_json_TaxResponse.parse(json);
        System.assert(obj != null);
    }
}