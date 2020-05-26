public class Note_Functions {

  public static List<note> returnNotesRelatedtoObject(Id parentObjectId) {
    List<Note> notes = null;
    
    try {
          notes = [SELECT 
                          Id, 
                          ParentId, 
                          Title, 
                          Body, 
                          CreatedDate, 
                          CreatedById,
                          CreatedBy.Name
                          FROM Note WHERE ParentId = :parentObjectId
                          ORDER BY CreatedDate DESC];
        } 
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }
      
    if (notes.size() == 0) {notes = null;}
         
    return notes;
  }

  public static Boolean createNote(Id parentId,String title,String body) {
    Boolean result = true;
    
    try {
        Note newNote = new Note();
        
        newNote.parentId = parentId;
        newNote.title = title;
        newNote.body = body;
        
        insert newNote;
        } catch (Exception e) {result = false;}
        
    return result;
  }
//The End
}