/*Class to avoid recursive triggers
  The class initializes the static boolean variable as true for the first run
  and then makes it false for the second run.

Author - Rajeev*/

public Class checkRecursive{
    
    private static boolean run = true;
    private static boolean runaccount = true;
    private static boolean runaccount1 = true;
     private static boolean runaccount2 = true;
     private static boolean runaccount3 = true;
    private static boolean runcdf = true;
    
    public static boolean runOnce(){
    
    if(run){
    
       run = false;
      
      return true;
    
    }else{
      
      return run;
      }
    
  }
  public static boolean runAccountOnce(){
    
    if(runaccount){
    
       runaccount = false;
      
      return true;
    
    }else{
      
      return runaccount;
      
    }
    
  }
  public static boolean runAccountOnce1(){
    
    if(runaccount1){
    
       runaccount1 = false;
      
      return true;
    
    }else{
      
      return runaccount1;
      
    }
    
  }
  
  public static boolean runAccountOnce2(){
    
      
    if(runaccount2){
    
       runaccount2 = false;
      
      return true;
    
    }else{
      
      return runaccount2;
      
    }
    
  }
  
  public static boolean runAccountOnce3(){
    
    if(runaccount3){
    
       runaccount3 = false;
      
      return true;
    
    }else{
      
      return runaccount3;
      
    }
    
  }
  
  public static void resetAccountOnce2(){
    
    runaccount2 = false;
        
  }



public static boolean runOnceCdf(){
    
    if(runcdf){
    
       runcdf = false;
      
      return true;
    
    }else{
      
      return runcdf;
      
    }
    
  }

}