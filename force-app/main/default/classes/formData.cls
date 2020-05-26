public class formData{
public string name{get; set;}
public string value{get; set;}
public formData(){ name = ''; value=''; }
public formData( string name, string value){
  this.name = name;
  this.value = value;

}
}