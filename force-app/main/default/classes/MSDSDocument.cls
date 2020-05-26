public class MSDSDocument {

   public String document {get;set;}
   public List<Status> status {get;set;}
   public String dockey {get;set;}
   public String genvar {get;set;}
   public String langu {get;set;}
   public String recn_dh {get;set;}
   public String material {get;set;}
   public String genvar_desc {get;set;}
   public String langu_desc {get;set;}

   public class Status {
   }

	
	public static List<MSDSDocument> parse(String json) {
		return	(List<MSDSDocument>) System.JSON.deserialize(json, List<MSDSDocument>.class);
        
	}

}