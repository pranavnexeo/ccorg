/**
 * Created by C751352 on 2/12/2019.
 */

public class MaterialSearchResponse {

    public class Status {
        public String type_Z {get;set;} // in json: type
        public String id {get;set;}
        public String number_Z {get;set;} // in json: number
        public String message {get;set;}
        public String log_no {get;set;}
        public String log_msg_no {get;set;}
        public String message_v1 {get;set;}
        public String message_v2 {get;set;}
        public String message_v3 {get;set;}
        public String message_v4 {get;set;}
        public String parameter {get;set;}
        public String row {get;set;}
        public String field {get;set;}
        public String system_Z {get;set;} // in json: system

        public  Status() {

        }
        
        public Status(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'number') {
                            number_Z = parser.getText();
                        } else if (text == 'message') {
                            message = parser.getText();
                        } else if (text == 'log_no') {
                            log_no = parser.getText();
                        } else if (text == 'log_msg_no') {
                            log_msg_no = parser.getText();
                        } else if (text == 'message_v1') {
                            message_v1 = parser.getText();
                        } else if (text == 'message_v2') {
                            message_v2 = parser.getText();
                        } else if (text == 'message_v3') {
                            message_v3 = parser.getText();
                        } else if (text == 'message_v4') {
                            message_v4 = parser.getText();
                        } else if (text == 'parameter') {
                            parameter = parser.getText();
                        } else if (text == 'row') {
                            row = parser.getText();
                        } else if (text == 'field') {
                            field = parser.getText();
                        } else if (text == 'system') {
                            system_Z = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Status consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public List<Material_list> material_list {get;set;}
    public String exceed_flag {get;set;}
    public List<Status> status {get;set;}

    public MaterialSearchResponse(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'material_list') {
                        material_list = arrayOfMaterial_list(parser);
                    } else if (text == 'exceed_flag') {
                        exceed_flag = parser.getText();
                    } else if (text == 'status') {
                        status = arrayOfStatus(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'MaterialSearchResponse consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }

    public MaterialSearchResponse() {
        
    }

    public class Material_list {
        public String material {get;set;}
        public String matl_desc {get;set;}
        public String product_name {get;set;}
        public String comp_code {get;set;}
        public String salesorg {get;set;}
        public String distr_chan {get;set;}
        public String division {get;set;}
        public String envi_indi {get;set;}
        public String langu {get;set;}
        public String mtart {get;set;}
        public String format {get;set;}
        public String genvar {get;set;}
        public String record_no {get;set;}

        public Material_list(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'material') {
                            material = parser.getText();
                        } else if (text == 'matl_desc') {
                            matl_desc = parser.getText();
                        } else if (text == 'product_name') {
                            product_name = parser.getText();
                        } else if (text == 'comp_code') {
                            comp_code = parser.getText();
                        } else if (text == 'salesorg') {
                            salesorg = parser.getText();
                        } else if (text == 'distr_chan') {
                            distr_chan = parser.getText();
                        } else if (text == 'division') {
                            division = parser.getText();
                        } else if (text == 'envi_indi') {
                            envi_indi = parser.getText();
                        } else if (text == 'langu') {
                            langu = parser.getText();
                        } else if (text == 'mtart') {
                            mtart = parser.getText();
                        } else if (text == 'format') {
                            format = parser.getText();
                        } else if (text == 'genvar') {
                            genvar = parser.getText();
                        } else if (text == 'record_no') {
                            record_no = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Material_list consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }


    public static List<MaterialSearchResponse> parse(String json) {
        System.debug(' json ' + json);
        System.JSONParser parser = System.JSON.createParser(json);
        return arrayOfMaterialSearchResponse(parser);
    }

    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT ||
                    curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                    curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }




    private static List<Status> arrayOfStatus(System.JSONParser p) {
        List<Status> res = new List<Status>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Status(p));
        }
        return res;
    }



    private static List<MaterialSearchResponse> arrayOfMaterialSearchResponse(System.JSONParser p) {
        List<MaterialSearchResponse> res = new List<MaterialSearchResponse>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new MaterialSearchResponse(p));
        }
        return res;
    }


    private static List<Material_list> arrayOfMaterial_list(System.JSONParser p) {
        List<Material_list> res = new List<Material_list>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Material_list(p));
        }
        return res;
    }


}