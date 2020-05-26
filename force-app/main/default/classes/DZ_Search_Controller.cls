public class DZ_Search_Controller {

	private static Boolean firstRun = true;

	public String searchString = '';

    public String warningMessage { get; set; }

	public String getsearchString() {
		return searchString;}

	public void setsearchString(String newsearchString) {
		searchString = newsearchString;}

	public List<Case> getCases() {
		warningMessage = '';
		
		if ((searchString == '') && (firstRun == true))
			{
			if(ApexPages.currentPage().getparameters().get('searchString') != null) 
		        {searchString = ApexPages.currentPage().getparameters().get('searchString');}
			}
		
		firstRun = false;
		
		List<Case> cases = new List<Case>();

		//String actualSearchString = '%' + searchString + '%';
		String actualSearchString = searchString;
		
		Integer caseCount = [SELECT COUNT() FROM case
		                      WHERE DZ_Number__c = :actualSearchString 
		                        AND RecordType.Name = 'Distribution DZ' LIMIT 51];
		                      
		if (caseCount > 50)
			{warningMessage = 'Warning: More than 50 results were returned.  Only the first 50 of the ' + caseCount + ' are shown below.';}		                      


		cases = [SELECT Id,
						Account.Id,
						Account.Name,
						Account.Owner.Name, 
		                DZ_Number__c, 
		                Line_Item_Number__c, 
		                OwnerId,
		                Owner.Name, 
		                CreatedDate, 
		                Status, 
		                Subject,
		                Description 
		                FROM case
		                WHERE DZ_Number__c = :actualSearchString 
		                  AND RecordType.Name = 'Distribution DZ'
		                LIMIT 50];
		
		return cases;
	}

//******************
//Test Method 
//******************

  static testMethod void TestMe() {

    DZ_Search_Controller cls = new DZ_Search_Controller();  
	List<Case> test = cls.getCases();

    cls.setsearchString('123');
    String teststring = cls.getsearchString();
	List<Case> test2 = cls.getCases();

  }

}