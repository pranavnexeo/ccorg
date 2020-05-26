/**
 * Created by C751352 on 2/12/2019.
 */

@IsTest
public class MaterialSearchResponseTest {

    // This test method should give 100% coverage
    static testMethod void testParse() {
        String json = '[{'+
                '   \"material_list\": [   {'+
                '      \"material\": \"000000000000558615\",'+
                '      \"matl_desc\": \"TI IFF ALLYL AMYL GLYCOLATE HOL D07\",'+
                '      \"product_name\": \"ALLYL AMYL GLYCOLATE HOL\",'+
                '      \"comp_code\": \"\",'+
                '      \"salesorg\": \"\",'+
                '      \"distr_chan\": \"\",'+
                '      \"division\": \"31\",'+
                '      \"envi_indi\": \"X\",'+
                '      \"langu\": \"E\",'+
                '      \"mtart\": \"ZNVA\",'+
                '      \"format\": \"\",'+
                '      \"genvar\": \"\",'+
                '      \"record_no\": \"00000000000000000000\"'+
                '   }],'+
                '   \"exceed_flag\": \"\",'+
                '   \"status\": [{'+
                '   \"type\": \"E\",'+
                '   \"id\": \"ZOTC\",'+
                '   \"number\": \"137\",'+
                '   \"message\": \"Material not found in System\",'+
                '   \"log_no\": \"\",'+
                '   \"log_msg_no\": \"000000\",'+
                '   \"message_v1\": \"\",'+
                '   \"message_v2\": \"\",'+
                '   \"message_v3\": \"\",'+
                '   \"message_v4\": \"\",'+
                '   \"parameter\": \"\",'+
                '   \"row\": \"0 \",'+
                '   \"field\": \"\",'+
                '   \"system\": \"\"'+
                '}'+
                ']'+
                '}]';
        List<MaterialSearchResponse> r = MaterialSearchResponse.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        MaterialSearchResponse.Status objStatus = new MaterialSearchResponse.Status(System.JSON.createParser(json));
        System.assert(objStatus != null);
        System.assert(objStatus.type_Z == null);
        System.assert(objStatus.id == null);
        System.assert(objStatus.number_Z == null);
        System.assert(objStatus.message == null);
        System.assert(objStatus.log_no == null);
        System.assert(objStatus.log_msg_no == null);
        System.assert(objStatus.message_v1 == null);
        System.assert(objStatus.message_v2 == null);
        System.assert(objStatus.message_v3 == null);
        System.assert(objStatus.message_v4 == null);
        System.assert(objStatus.parameter == null);
        System.assert(objStatus.row == null);
        System.assert(objStatus.field == null);
        System.assert(objStatus.system_Z == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        MaterialSearchResponse objMaterialSearchResponse = new MaterialSearchResponse(System.JSON.createParser(json));
        System.assert(objMaterialSearchResponse != null);
        System.assert(objMaterialSearchResponse.material_list == null);
        System.assert(objMaterialSearchResponse.exceed_flag == null);
        System.assert(objMaterialSearchResponse.status == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        MaterialSearchResponse.Material_list objMaterial_list = new MaterialSearchResponse.Material_list(System.JSON.createParser(json));
        System.assert(objMaterial_list != null);
        System.assert(objMaterial_list.material == null);
        System.assert(objMaterial_list.matl_desc == null);
        System.assert(objMaterial_list.product_name == null);
        System.assert(objMaterial_list.comp_code == null);
        System.assert(objMaterial_list.salesorg == null);
        System.assert(objMaterial_list.distr_chan == null);
        System.assert(objMaterial_list.division == null);
        System.assert(objMaterial_list.envi_indi == null);
        System.assert(objMaterial_list.langu == null);
        System.assert(objMaterial_list.mtart == null);
        System.assert(objMaterial_list.format == null);
        System.assert(objMaterial_list.genvar == null);
        System.assert(objMaterial_list.record_no == null);
    }
}