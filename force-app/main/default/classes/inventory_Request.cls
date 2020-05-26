public class inventory_Request {
    public list<header> header;
    public list<partners> partners;
    public list<items> items;
    public list<switches> switches;
    public string client;
    
    public class partners{
        public String partn_role;   //  AG=sold to, WE=ship to
        public String partn_numb;   // 
    }
    public class header{
        public string sales_org;
        public string distr_chan;
        public string division;
        public string language;
    }
    public class items{
        public string material;
        public string plant;
        public string req_qty;
        public string sales_unit;
        public date req_date;
    }
    
    public class switches{
        public list<ATP> ATP;
    }
    
    public class ATP{
        public string swtchOn;
        public string locale; 
    }
    public static List<inventory_Request> parse(String json) {
        return (List<inventory_Request>) System.JSON.deserialize(json, List<inventory_Request>.class);
    }
}