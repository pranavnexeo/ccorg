public class Salesforce_Process {

	public Salesforce_Process(Salesforce_Process__c SF_Process,
							  String formatted_Businesses,
							  String formatted_Rollout_Areas,
							  String formatted_User_Roles,
							  String formatted_Salesforce_Objects) {
		this.SF_Process = SF_Process; 
		this.formatted_Businesses = formatted_Businesses; 
		this.formatted_Rollout_Areas = formatted_Rollout_Areas; 
		this.formatted_User_Roles = formatted_User_Roles; 
		this.formatted_Salesforce_Objects = formatted_Salesforce_Objects; 
    }
    
    public Salesforce_Process__c SF_Process { get; private set; }
    public String formatted_Businesses { get; set; }
    public String formatted_Rollout_Areas { get; set; }
    public String formatted_User_Roles { get; set; }
    public String formatted_Salesforce_Objects { get; set; }

    //******************
    //Test Method 
    //******************
    static testMethod void TestMe() {

	Salesforce_Process cls = new Salesforce_Process(new Salesforce_Process__c(),'','','','');  
   	
   }

    
}