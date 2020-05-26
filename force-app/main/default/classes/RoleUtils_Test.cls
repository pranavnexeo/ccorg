@isTest
public class RoleUtils_Test
{
public static testMethod void  RoleUtils_Test()
{
 RoleUtils rUtil = new RoleUtils();
 //Adding code to prevent have hardcoded IDs
 Map<String, SObject> testData = NexeoTestUtils_Test.initData();  
 User u = (User) testData.get('testUser1');
 UserRole nexeoTestRole = (UserRole) testData.get('nexeoTestRole');
 Id userId = u.Id;
 Id RoleId = nexeoTestRole.Id;
 Set<ID> roleIds = new Set<ID>();
 roleIds.add(nexeoTestRole.Id);
 String RoleName = nexeoTestRole.Name;
 RoleUtils.getRoleSubordinateUsers(userId);
 RoleUtils.getRoleSubordinateUsers(RoleName);
 RoleUtils.getRoleSubordinateUsersByRoleId(RoleId);
 //RoleUtils.getAllSubRoleIds(roleIds);
 }
}