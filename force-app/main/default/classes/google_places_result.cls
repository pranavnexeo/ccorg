global class google_places_result{

public List<address_component> address_components{Get; set;}
public geometry geometry{get; set;}
public string reference{get; set;}
public string vicinity{Get; set;}
public string name{get;set;}
public list<Event> events{get; set;}
public string formatted_address{get; set;}
public string formatted_phone_number{Get; set;}
public string icon{get; set;}
public string id{get; set;}
public List<Photo> photos{get; set;}
public List<string> types{get; set;}
public List<String> html_attributions{Get; set;}
public opening_hours opening_hours{Get; set;}
public double rating{Get; set;}
public string place_id{get; set;}
public string scope{get ;set;}
public integer price_level{get; set;}
public string plus_code{get ;set;}

global google_places_result(integer price_level, string scope, string place_id, double rating, string name, List<Address_component> address_components, geometry geometry, string id, string icon, List<Photo> photos, List<String> types, opening_hours opening_hours,
                            List<Event> events, string reference, string vicinity, string formatted_address, string formatted_phone_number, List<String> html_attributions){
  this.address_components = address_components;  
  this.formatted_address = formatted_address;
  this.geometry = geometry;
  this.reference = reference;
  this.vicinity = vicinity;
  this.name = name;
  this.events = events;
  this.formatted_address = formatted_address;
  this.formatted_phone_number = formatted_phone_number;
  this.icon = icon;
  this.id = id;
  this.photos = photos;
  this.html_attributions = html_attributions;
  this.types = types;
  this.opening_hours = opening_hours;
  this.rating = rating;
  this.place_id = place_id;
  this.scope = scope;
  this.price_level = price_level;
}

global class address_component{
  string long_name{Get; set;}
  string short_name{get; set;}
  List<String> types{Get; set;}
  public address_component(string long_name, string short_name, List<String> types){
    this.long_name = long_name;
    this.short_name = short_name;
    this.types = types;
  }
}

global class geometry{
  public location location{Get; set;}
  public string viewport{get; set;}
  public geometry(location location, string viewport){
    this.location = location;
  }
}
global class location{
  public double A{Get; set;}
  public double B{get; set;}
  public double K{get; set;}
  public double D{get; set;}
  public double G{get; set;}
  public location(double a, double b, double k, double d, double G){
    this.A = a;
    this.k = k;
    this.B = B;
    this.D = D;
    this.G = G;
  }

}

global class event{
  public string event_id{get; set;}
  public double start_time{get; set;}
  public string summary{get; set;}
  public string url{Get; set;}
  public event(string event_id, double start_time, string summary, string url){
    this.event_id = event_id;
    this.start_time = start_time;
    this.summary = summary;
    this.url = url;
  }
}

global class photo{
  public string photo_reference{Get; set;}
  public double height{Get; set;}
  public double width{get; set;}
  public List<String> html_attributions{Get; set;}
  public photo(string photo_reference, double height, double width, List<String> html_attributions){
    this.photo_reference = photo_reference;
    this.height = height;
    this.width = width;
    this.html_attributions = html_attributions;
  }
}

global class Opening_Hours{
  public boolean open_now{get; set;}
  public List<Period> periods{get; set;}
  public string weekday_text{get; set;}
  public Opening_hours(boolean open_now, List<Period> periods, string weekday_text){
    this.open_now = open_now;
    this.periods = periods;
    this.weekday_text = weekday_text;
   }

}

global class period{
  public day_time open{Get; set;}
  public day_time close{get; set;}
  public period(day_time open, day_time close){
    this.open = open;
    this.close = close;
  }
}

global class day_time{
  public integer day{get; set;}
  public double times{get; set;}
  public day_time(integer day, double times){
    this.day = day;
    this.times = times;
  }
}
}