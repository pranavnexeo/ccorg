public with sharing class MassTouchBatchProcessController {

    String objectName = '';
    String dateTimeString = '';
    DateTime lastModTime;
    PageReference ajpr = new PageReference('/apexpages/setup/listAsyncApexJobs.apexp');
    String batchSize = CustomSettings_Functions.getBW_Data_BatchSize();
    
    public PageReference submitBatchJob() {
        if (objectName == null || objectName.trim().length() == 0) {
            return null;
        }
        String query = 'select id from ' + objectName + 
                       ' where LastModifiedDate < ' + getLastModTimeString() +
                       ' limit ' + batchSize;
        MassTouchBatchProcessor mtbp = new MassTouchBatchProcessor(query);
        Id processId;
        try {
            processId = Database.executeBatch(mtbp);
            return ajpr;
        } catch(DmlException de) {
            System.debug(de.getMessage());
        }
        return null;
    }
    
    private String getLastModTimeString() {
        String s = lastModTime.format('yyyy-MM-dd HH:mm:ss.SSS');
        s = s.substring(0, 10) + 'T' + s.substring(11) + 'Z'; 
        return s;
    }

    public String getObjectName() {
        return objectName;
    }

    public void setObjectName(String objectName) {
        this.objectName = objectName;
    }
    
    public String getDateTimeString() {
        if (lastModTime == null) {
           lastModTime = DateTime.now();
        }
        dateTimeString = String.valueOf(lastModTime);
        return dateTimeString;
    }
    
    public void setDateTimeString(String dateTimeString) {
        this.lastModTime = DateTime.valueOf(dateTimeString);
        this.dateTimeString = dateTimeString;
    }

}