public class User_Functions {
    
  private static final String SYSADMIN = 'System Admin';
  
  private static final String CA_T3_SUPPORT = 'CA Team - Tier 3 Support';
     
  private static String loggedInUserProfileName = null;

  public static String RetrieveUserName(String id) {
    String result = '';
    
    try {
        User user = [SELECT Name FROM User WHERE Id = :id];
        result = user.Name;
        } catch (Exception e) {}
    return result;
  }

  public static String RetrieveUserName(Id id) {
    String result = '';
    
    try {
        User user = [SELECT Name FROM User WHERE Id = :id];
        result = user.Name;
        } catch (Exception e) {}
    return result;
  }


  public static Id LookupActiveUserbyFullName(String fullName) {
    Id result = null;
    
    try {result = [SELECT Id FROM User WHERE Name = :fullName AND IsActive = true LIMIT 1].Id;}
    catch (Exception e) {//Not Found
                        }
      
    return result;
  }

  public static Map<String,Id> LookupActiveUsersbyFullName(List<String> fullNames) {
    Map<String,Id> results = new Map<String,Id>();
    List<User> usersFound;
    
    if (fullNames != null)
      {
        try {
            usersFound = [SELECT Id, Name FROM User WHERE Name in :fullNames AND IsActive = true];
            for(User userFound:usersFound)
                {
                results.put(userFound.Name,userFound.Id);
                }
            }
        catch (Exception e) {//Not Found
                            }
      }                                
      
    return results;
  }


  public static Id LookupInactiveUserbyFullName(String fullName) {
    Id result = null;
    
    try {result = [SELECT Id FROM User WHERE Name = :fullName AND IsActive = false LIMIT 1].Id;}
    catch (Exception e) {//Not Found
                        }
      
    return result;
  }

  public static Id LookupUserbyFullName(String fullName) {
    Id result = null;
    
    try {result = [SELECT Id FROM User WHERE Name = :fullName LIMIT 1].Id;}
    catch (Exception e) {//Not Found
                        }
      
    return result;
  }

  public static String getLoggedInUserEmail() {
    String result = getUserEmail(UserInfo.getUserId());
    return result;
  }

  public static String getUserEmail(String id) {
    String result = '';
    try {
        User user = [SELECT Email FROM User WHERE Id = :id];
        result = user.Email;
    } catch (Exception e) {
        System.debug(e.getMessage());
    }
    return result;
  }

    public static String getLoggedInUserProfileName() {
        if (loggedInUserProfileName == null) {
            String pid = UserInfo.getProfileId();
            if (pid != null) {
                List<profile> pl = [select name from profile where id = :pid];
                if (pl != null && pl.size() > 0) {
                    loggedInUserProfileName = pl[0].Name;
                }
            }
        }
        //System.debug('User Profile Name : '+loggedInUserProfileName);
        return loggedInUserProfileName;
    }
    
    public static boolean isSysAdmin() {
        loggedInUserProfileName = getLoggedInUserProfileName();
        if (loggedInUserProfileName != null) {
            return loggedInUserProfileName.startsWith(SYSADMIN);
        }
        return false;
    }

    public static boolean isSupport() {
        loggedInUserProfileName = getLoggedInUserProfileName();
        if (loggedInUserProfileName != null) {
            return loggedInUserProfileName.equalsIgnoreCase(CA_T3_SUPPORT);
        }
        return false;
    }
//The End
}