public class comboData{
public string label{get; set;}
public string value{get; set;}
public comboData(){ label = ''; value=''; }
public comboData( string label, string value){
  this.label= label;
  this.value = value;

}
}