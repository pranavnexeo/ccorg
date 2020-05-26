public class inventory_Response {
    
    public string status;
    public List<messages> messages;
    public list<atp_Response> atp_Response;
    
    public class atp_Response{
        public string material;
        public string req_date;
        public string status;
        public list<messages> messages;
    }
    
    public class messages{
        public string message;
    }
    public static List<inventory_Response> parse(String json) {
        return (List<inventory_Response>) System.JSON.deserialize(json,List<inventory_Response>.class);
    }

}