global class combogriddata{

global integer total{get; set;}
global List<sobject> rows{get; set;}
global combogriddata(list<sobject> rows){ this.rows = rows; total = rows.size(); }

}