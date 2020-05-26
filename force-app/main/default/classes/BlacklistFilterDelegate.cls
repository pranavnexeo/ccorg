/**
 * Blacklist filter delegate contains all of the logic to implement keyword filtering
 * based on the Blacklisted_Word__c entity
 * Author: qwall@salesforce.com
 */
public class BlacklistFilterDelegate
{
    public static Integer FEED_POST = 1;
    public static Integer FEED_COMMENT = 2;
    public static Integer USER_STATUS = 3;
    
    List<PatternHelper> patterns {set; get;} 
    Map<Id, PatternHelper> matchedPosts {set; get;}
    
    public BlacklistFilterDelegate()
    {
         patterns = new List<PatternHelper>();
         matchedPosts = new Map<Id, PatternHelper>(); 
         preparePatterns();
    }
    
    private void preparePatterns()
    {
         //fetch the blacklisted words
        List<Blacklisted_Word__c> bwWords = [select Word__c, RegexValue__c, Substitution__c,
                                            Add_to_Compliance_Audit__c, 
                                            Prevent_Post_on_Breach__c
                                         from Blacklisted_Word__c where is_Active__c = true];
    
        for(Blacklisted_Word__c bwc : bwWords)
        {
            patterns.add(new PatternHelper(bwc));
        }
        
    }
    
    /**
     * Given a list of FeedItems, filter them against the blacklisted words
     */
    public List<FeedItem> filterFeedItems(List<FeedItem> fi)
    {
        return filterBody(fi);
    }
    
    /**
     * Given a list of FeedComments, filter them against the blacklisted words
     */
    public List<FeedComment> filterFeedComments(List<FeedComment> fc)
    {
        return filterBody(fc);
    }
    
    /**
     * Given a list of Users, filter them against the blacklisted words
     */
    public List<User> filterUserStatus(List<User> users)
    {
        return filterBody(users);
    }
    
    /**
     * This is where the heavy lifting happens and matching is performed.
     * Use convenience methods filterFeedPosts, filterFeedComments, and filterUserStatus to return the 
     * correctly casted Lists
     */
    private List<SObject> filterBody(List<SObject> sobjs)
    {
        List<SObject> updatedSobjs = new List<SObject>();
         Matcher m;
        String body = null;
    
         for (SOBject f : sobjs)
         {
                boolean preventPost = false;
                
                if(f instanceOf FeedItem)
                    body = ((FeedItem)f).Body == null ? '' : ((FeedItem)f).Body;
                else if(f instanceOf FeedComment)
                    body = ((FeedComment)f).CommentBody == null ? '' : ((FeedComment)f).CommentBody;
                else if( f instanceOf User)  //1.5: fix user status clear error
                    body = ((User)f).CurrentStatus == null ? '' : ((User)f).CurrentStatus;
                
                for(PatternHelper ph : patterns)
                {
                    //System.debug('CHECKING BODY: '+body);
                    //System.debug('WITH PATTERN: ' +ph.p);
                    //System.debug('FOR A RESULT OF: '+ph.p.matcher(body).find());
                       if(ph.p.matcher(body).find()) //1.6 fix to allow non unique substitution strings
                       {
                           //System.debug('------------> A MATCH:'+body);
                           body = body.replaceAll(ph.regexValue, ph.substitutionValue);
                       
                          if(!matchedPosts.containsKey(ph.blacklistedWord.id))
                          {
                              if(f instanceOf FeedItem)
                              {
                                     ph.origPostBody = ((FeedItem)f).Body;
                                     ph.postCreatedById = ((FeedItem)f).createdById;
                              }
                              else if(f instanceOf FeedComment)
                              {
                                     ph.origPostBody = ((FeedComment)f).CommentBody;
                                     ph.postCreatedById = ((FeedComment)f).createdById;
                              }
                              else if(f instanceOf User)
                              {
                                     ph.origPostBody = ((User)f).CurrentStatus;
                                     ph.postCreatedById = ((User)f).id;
                              }
                                    
                              matchedPosts.put(ph.blacklistedWord.id, ph);
                          }
                         
                         //we only need to do spambox and prevent post once per post
                        if(ph.preventPostOnMatch)
                              preventPost = true;
                          
                       }
                 }
                 
                if(preventPost)
                {  
                   //1.6 updated error msg to reflect phrase support
                    String errorMsg = 'Post prevented due to use of a blacklisted word or phrase.';
                   
                   f.addError(errorMsg);
                   
                    /* TODO need to explicitly set error field else errors incorrectly mark things like invalid url
                    if(f instanceOf FeedItem)
                    {
                        if(((FeedItem)f).type == 'LinkPost' || ((FeedItem)f).type == 'FilePost')
                            ((FeedItem)f).Body.addError('CRAP');
                        else
                            ((FeedItem)f).Body.addError(errorMsg);
                    }
                    else if (f instanceOf FeedComment)
                        ((FeedComment)f).CommentBody.addError(errorMsg);
                    else if (f instanceOf User)
                        ((User)f).CurrentStatus.addError(errorMsg);
                    */    
                
                }
                else
                {
                    System.debug('ADDING BODY: '+body);
                    
                    if(f instanceOf FeedItem)
                    {
                        //apex doesn't seem to like this sort of casting...
                        //((FeedItem)f).Body = body; 
                        FeedItem fi = (FeedItem)f;
                        fi.Body = body;
                        updatedSobjs.add(fi);
                    }
                    else if(f instanceOf FeedComment)
                    {
                        //((FeedComment)f).CommentBody = body;
                        FeedComment fc = (FeedComment)f;
                        fc.CommentBody = body;
                        updatedSobjs.add(fc);
                         
                    }
                    else if(f instanceOf User)
                    {
                        User u = (User)f;
                        u.CurrentStatus = body;
                        updatedSobjs.add(u);
                         
                    }
                }
 
         }
         
         doAudit();
         
         return updatedSobjs;
    }
    
    /**
     * If a blacklisted word is flagged as save to audit, lets write it to the blacklist audit list.
     */
    private void doAudit()
    {
        
        List< Blacklist_Audit__c> audits = new List<Blacklist_Audit__c>();
        Blacklist_Audit__c blaudit = null;
        
        for(PatternHelper p : matchedPosts.values())
        {
            
            //check for audit actions
            if(p.blacklistedWord.Add_to_Compliance_Audit__c)
            {
               blaudit = new Blacklist_Audit__c();
               blaudit.Breached_By__c = p.postCreatedById;
               blaudit.Unscrubbed_Post__c = p.origPostBody;
               blaudit.Blacklisted_Word__c = p.blacklistedWord.Word__c;
               audits.add(blaudit);
            }
            
            //check for notifier actions
            //TODO
        }
        
        if(!audits.isEmpty())
            insert audits;      
    }
}