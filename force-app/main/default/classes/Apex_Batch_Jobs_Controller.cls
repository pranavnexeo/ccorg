public with sharing class Apex_Batch_Jobs_Controller {

    public BatchJob[] getAsyncJobs() {
            List<BatchJob> aajs = new List<BatchJob>();
            for(AsyncApexJob aaj : [Select Id, Status, JobType, MethodName, 
                                           JobItemsProcessed, TotalJobItems, 
                                           NumberOfErrors, CreatedDate, CompletedDate 
                                      from AsyncApexJob 
                                     where jobtype!='future' 
                                     order by createddate desc]) {
                aajs.add(getBatchJob(aaj));
            }
        
            return aajs;
    }
    
    private BatchJob getBatchJob(AsyncApexJob aaj) {
        BatchJob bj = new BatchJob();
        bj.name=aaj.id;
        bj.Job_Type = aaj.jobtype;
        
        if(aaj.jobItemsProcessed > 0 && aaj.TotalJobItems>0) {
        	updateBatchJob(bj, aaj.jobItemsProcessed, 
        	               aaj.totalJobItems, aaj.status);
        } else {
            bj.Status = aaj.Status;
            bj.Percent= 1;
        }
        
        bj.Records_Processed =aaj.JobItemsProcessed;
        bj.Total_Records=aaj.TotalJobItems;
        bj.NumberOfErrors=aaj.NumberOfErrors;
        bj.MethodName=aaj.MethodName;
        bj.CreatedDate=aaj.CreatedDate;
        bj.CompletedDate=aaj.CompletedDate;
        return bj;
    }
    
    private void updateBatchJob(BatchJob bj,
                                Integer jobItemsProcessed,
                                Integer totalJobItems,
                                String status) {
        Decimal D = jobItemsProcessed;
        D=D.Divide(totalJobItems, 2)*100;
        bj.Status = status;
        bj.Percent= D.intValue();
    }
        
    public PageReference updateProgress() {
        return null;
    }
        
    // Internal class BatchJob starts
    public class BatchJob {

            public AsyncApexJob aj {get;set;}
            public String Status {get;set;}
            public String MethodName {get;set;}
            public Integer Percent {get;set;}
            public String Name {get;set;}
            public String Job_Type {get;set;}
            public Integer Records_Processed{get;set;}
            public Integer Total_Records{get;set;}
            public Integer NumberOfErrors{get;set;}
            public DateTime CreatedDate{get;set;}
            public DateTime CompletedDate{get;set;}
            
            public BatchJob(){
            }

            public Boolean getItemCompleted() {
                return (Status == 'Aborted' || 
                        Status == 'Completed' || 
                        Status == 'Failed');
            }
            
            public String getFormatted_CreatedDate() {
                return CreatedDate.format();
            }

            public String getFormatted_CompletedDate() {
                return CompletedDate.format();
            }

            public String getEstimatedCompletionDateTime() {
                DateTime currentDateTime = datetime.now();

                Long datediff = System.now().getTime() - CreatedDate.getTime();

                Decimal percentageComplete = 1;
                Decimal minutesLeft = 0; 

                Decimal D = Decimal.valueOf(Records_Processed);
                if (Total_Records != 0) {
                    D = D.Divide(Decimal.valueOf(Total_Records), 6);
                }
                
                try {
                    if (Total_Records != 0) {
                        percentageComplete = D;
                    }
                } catch(Exception e) {}

                String result = '';
                
                if (percentageComplete != 0){
                
                    minutesLeft = (((datediff / percentageComplete) - datediff) / (1000 * 60));
                    
                    DateTime completionDateTime = System.Now();
                    
                    String minhold = string.valueOf(minutesLeft);
                    Integer iminhold = integer.valueOf(minhold);
                    completionDateTime = completionDateTime.addMinutes(iminhold);
                
                    result = (((datediff / percentageComplete) - datediff) / (1000 * 60)) + ' minutes left';
                    
                    if ((((datediff / percentageComplete) - datediff) / (1000 * 60)) > 60) {
                        result += ' (' + (((datediff / percentageComplete) - datediff) / (1000 * 60 * 60)) + ' hours left)';
                    }
                    
                    result += ' ' + completionDateTime.format();
                }
                
                return result;
            }

    }
    // Internal class BatchJob ends
        
/*
 **********************************************************
 Test Methods
 ********************************************************** 
 */    

    public static testMethod void testMe() {
        testBatchJob();
    }
    
    private static void testBatchJob() {
        Apex_Batch_Jobs_Controller abjc = new Apex_Batch_Jobs_Controller();
        abjc.getAsyncJobs();
        abjc.updateProgress();
    	AsyncApexJob aaj = new AsyncApexJob();
        abjc.getBatchJob(aaj);
        BatchJob bj = new BatchJob();
        String status = 'Processing';
        abjc.updateBatchJob(bj, 100, 200, status);
        bj.CreatedDate = System.Now();
        bj.CompletedDate = System.Now();
        bj.Records_Processed = 100;
        bj.Total_Records = 200;
        String s1 = bj.getEstimatedCompletionDateTime();
        String s2 = bj.getFormatted_CompletedDate();
        String s3 = bj.getFormatted_CreatedDate();
        Boolean b = bj.getItemCompleted();
    }
    
}