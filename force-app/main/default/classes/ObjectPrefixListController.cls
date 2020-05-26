public with sharing class ObjectPrefixListController {

    public static final String SORT_ASC = 'asc'; 
    public static final String SORT_ASC_IMG = '/img/sort_' + SORT_ASC + '_arrow.gif'; 

    public static final String SORT_DESC = 'desc'; 
    public static final String SORT_DESC_IMG = '/img/sort_' + SORT_DESC + '_arrow.gif'; 

    public static final String FLD_LABEL = 'label'; 
    public static final String FLD_NAME = 'name'; 
    public static final String FLD_PREFIX = 'prefix'; 
    
    List<ObjectRecord> objRecs; 
    public String sortImage {get; set;}
    public String sortField {get; set;}
    public String previousSortField {get; set;}
    public String sortOrder {get; set;}
    
    public boolean renderLabelSortImage {get; set;}
    public boolean renderNameSortImage {get; set;}
    public boolean renderPrefixSortImage {get; set;}
    
    public List<ObjectRecord> getObjRecs() {
    	if (objRecs == null) {
    		setObjRecs();
    	}
    	return objRecs;
    }
    
    private void setObjRecs() {
    	objRecs = new List<ObjectRecord>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        List<Schema.SObjectType> tlist = gd.values();
        for(Schema.SObjectType t : tlist) {
            Schema.DescribeSObjectResult r = t.getDescribe();
            if (r.getKeyPrefix() != null) {
            	ObjectRecord o = new ObjectRecord();
            	o.label = r.getLabel();
            	o.name = r.getName();
            	o.prefix = r.getKeyPrefix();
            	objRecs.add(o);
                //System.debug(r.getName()+':'+r.getLabel()+':'+r.getKeyPrefix());
            }
        }
        this.sortField = FLD_PREFIX;
        this.previousSortField = this.sortField;
        this.sortOrder = SORT_ASC;
        sortObjRecs();
    }
    
    public void doSort(){
        /*This checks to see if the same header was click two times in a row, if so 
        it switches the order.*/
        if(previousSortField == sortField){
            sortOrder = SORT_DESC;
            previousSortField = null;
        }else{
            this.sortOrder = SORT_ASC;
            previousSortField = sortField;
        }
       
        sortObjRecs();
    }
    
    private void setSortImageFlags() {
    	renderLabelSortImage = false;
        renderNameSortImage = false;
        renderPrefixSortImage = false;
        if (sortField == FLD_NAME) {
            renderNameSortImage = true;
        } else if (sortField == FLD_LABEL) {
            renderLabelSortImage = true;
        } else if (sortField == FLD_PREFIX) {
            renderPrefixSortImage = true;
        }
    }
    
    private void sortObjRecs() {
    	if (objRecs == null) {return;}
    	setSortImageFlags();
    	Map<object, ObjectRecord> amap = new Map<object, ObjectRecord>();
    	for (ObjectRecord o : objRecs) {
    		String k;
    		if (sortField == FLD_NAME) {
    			k = o.name;
    		} else if (sortField == FLD_LABEL) {
    			k = o.label;
    		} else if (sortField == FLD_PREFIX) {
    			k = o.prefix;
    		}
    		if (k != null) {
    			amap.put(k, o);
    		}
    	}
        List<object> keys = new List<object>(amap.keySet());
        keys.sort();
        List<ObjectRecord> sortedRecs = new List<ObjectRecord>();
        for(object key : keys){ 
            sortedRecs.add(amap.get(key)); 
        }
        objRecs.clear();
        if(sortOrder.toLowerCase() == SORT_ASC){
            sortImage = SORT_ASC_IMG;
            for(ObjectRecord o : sortedRecs){
                objRecs.add(o);  
            }
        }else if(sortOrder.toLowerCase() == SORT_DESC){
            sortImage = SORT_DESC_IMG;
            for(integer i = sortedRecs.size()-1; i >= 0; i--){
                objRecs.add(sortedRecs[i]);   
            }
        }
    }
    
    public class ObjectRecord {
    	public String name {get; set;}
    	public String label {get; set;}
    	public String prefix {get; set;}
    }

}