public class AutoCompleteData{
     public string label{get;set;} 
     public string value{get;set;}
  public AutoCompleteData(){
     label= ''; 
     value=''; 
  }
  public AutoCompleteData( string label, string value){
     this.label= label;
     this.value = value;
  }
}