public without sharing class cc_mn_hlpr_EffectiveAccount {
	public static List<Account> queryEffectiveAccounts(String thequery){
		return (List<Account>)Database.query(theQuery);
	}
}