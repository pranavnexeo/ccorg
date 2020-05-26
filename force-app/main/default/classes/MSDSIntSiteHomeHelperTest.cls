@IsTest
public class MSDSIntSiteHomeHelperTest {

    public static String DOCUMENTS_LIST = '[{"document": "","status": [],"dockey": "SBRWWI-00000000000006947646 00000","genvar": "1_GHS_NA","langu": "E","recn_dh": "00000000000011583693","material": "000000000000020005","genvar_desc": "USA - GHS","langu_desc": "English"},{"document": "","status": [],"dockey": "SBRWWI-00000000000006947647 00000","genvar": "1_GHS_NA","langu": "F","recn_dh": "00000000000011583697","material": "000000000000020005","genvar_desc": "USA - GHS","langu_desc": "French"}]';
    public static String DOCUMENT_RESPONSE = '['+
		'      {'+
		'      \"document\": \"0M8R4KGxGuEAAAAAAAAAAAAAAAAAAAAAPgADAP7/CQAGAAAAAAAAAAAAAAAEAAAAvQEAAAAAAAAAEAAAvwEAAAEAAAD+////AAAAALkBAAC6AQAAuwEAALwBAAD////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\",'+
		'      \"status\": [],'+
		'      \"dockey\": \"SBRWWI-00000000000006947646 00000\",'+
		'      \"genvar\": \"1_GHS_NA\",'+
		'      \"langu\": \"E\",'+
		'      \"recn_dh\": \"00000000000011583693\",'+
		'      \"material\": \"000000000000020005\",'+
		'      \"genvar_desc\": \"USA - GHS\",'+
		'      \"langu_desc\": \"English\"'+
		'   }' +
		']';
     private static String SEARCH_RESPONSE = '[{"material_list":[{"material":"0000000000005586151","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"0000000000005586152","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"0000000000005586153","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"}],"exceed_flag":"","status":[{"type":"E","id":"ZOTC","number":"137","message":"Material not found in System","log_no":"","log_msg_no":"000000","message_v1":"","message_v2":"","message_v3":"","message_v4":"","parameter":"","row":"0 ","field":"","system":""}]}]';

    
     static void setupData () {
        MSDS_Site__c siteSettings = new MSDS_Site__c ();
        siteSettings.Get_SDS_Document_Body__c = '[{"MATERIAL":"PLACE_HOLDER_0","RECN_DH":"PLACE_HOLDER_1"}]';
        siteSettings.Get_SDS_Document_List_Body__c = '[{"MATERIAL":"PLACE_HOLDER"}';
        siteSettings.Get_SDS_Document_List_Body_Internal__c = '[{"MATERIAL":"PLACE_HOLDER"," RECN_DH":"","EXCL_REFMSDS_FLAG":""}]';
        siteSettings.Landing_Zeros_Material_Number__c = '18';
        siteSettings.MSDS_EndpointPath__c = 'ZSD_GET_MSDS_LI';
        siteSettings.MSDS_EndpointPath_Query_Parameter__c = 'sap-client=020&spnego=disabled';
        siteSettings.Max_Number_Of_Records_Per_Page__c = 10;
        siteSettings.Pagination_Limit__c = '5';
        siteSettings.Search_By_Material_Name__c = 'SEARCH_BY_MATERIAL_NUMBER';
        siteSettings.MSDS_Material_Search_Endpoint__c = 'sap/bc/ZEHS_MATL_LIST?sap-client=020&spnego=disabled';
        siteSettings.Get_Material_Search_Body__c = '[{"MATERIAL":"PLACE_HOLDER_0","PRODUCT_NAME":"PLACE_HOLDER_1","LANGU":"","GENVAR":""}]';
        insert siteSettings;
        
        Material_Description__c md = new Material_Description__c();
        md.Material_Description__c = 'Material';
        md.Language_Code__c = 'ES';
        md.Material_Number__c = '000000000000005467';
        insert md;
            

        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = '000000000000005467';
       	mgd2.Material_Desc_Code__c = md.Id;
        insert mgd2;
        
      	Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material SDS', Material_Number__c = '000000000000005467', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key', Material_General_Data__c = mgd2.Id);        
        insert matlist;    
     
        ES_Order_Document__c orderDocument = new ES_Order_Document__c();
        insert orderDocument;        
    }
    
        public static testMethod void testGetMaterialName() {
        setupData();
        String materialNumber = '5467';
        String materialName = MSDSIntSiteHomeHelper.getMaterialName(materialNumber);
        System.assert(null != materialName);
        
    }
    
    public static testMethod void testGetMaterialNameEx() {
        setupData();
        String materialNumber = '54671';
        String materialName = MSDSIntSiteHomeHelper.getMaterialName(materialNumber);
        System.assert(null != materialName);
        
    }
    
    public static testMethod void getSDSDocumentsList() {
        setupData();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(200, '200', DOCUMENTS_LIST, new Map<String, String>()));
            String materialNumber = '5467';
            MSDSResponse documentsList = MSDSIntSiteHomeHelper.getSDSDocumentsList(materialNumber);
        Test.stopTest();   
        
    }
    
    public static testMethod void getSDSDocumentsListEx() {
        setupData();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(404, '404', DOCUMENTS_LIST, new Map<String, String>()));
        String materialNumber = '5467';
        MSDSResponse documentsList = MSDSIntSiteHomeHelper.getSDSDocumentsList(materialNumber);
        Test.stopTest();        
    }
    
    public static testMethod void getSDSDocumentsListEx2() {
        setupData();
        Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(404, '404', DOCUMENTS_LIST, new Map<String, String>()));
        String materialNumber = '5467';
        MSDSResponse documentsList = MSDSIntSiteHomeHelper.getSDSDocumentsList(materialNumber); 
    }
    
    public static testMethod void getSDSDocument(){
        setupData();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(200, '200', DOCUMENT_RESPONSE, new Map<String, String>()));
            String materialNumber = '5467';
        	String renchNumber = '124345467';
            MSDSResponse documentsList = MSDSIntSiteHomeHelper.getSDSDocument(materialNumber, renchNumber);
        Test.stopTest();   
    }
    
    public static testMethod void getSDSDocumentEx() {
        setupData();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(404, '404', DOCUMENT_RESPONSE, new Map<String, String>()));
        String materialNumber = '5467';
        String renchNumber = '124345467';
        MSDSResponse documentsList = MSDSIntSiteHomeHelper.getSDSDocument(materialNumber, renchNumber);
        Test.stopTest();        
    }
    
    public static testMethod void getSDSDocumentEx2() {
        setupData();
        Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(404, '404', DOCUMENT_RESPONSE, new Map<String, String>()));
        String materialNumber = '5467';
        String renchNumber = '124345467';
        MSDSResponse documentsList = MSDSIntSiteHomeHelper.getSDSDocument(materialNumber, renchNumber); 
    }
    
    public static testMethod void createMSDSDocument() {
        setupData();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(200, '200', DOCUMENT_RESPONSE, new Map<String, String>()));
            String materialNumber = '5467';
        	String renchNumber = '124345467';
            MSDSResponse documentsList = MSDSIntSiteHomeHelper.getSDSDocument(materialNumber, renchNumber);
        	String documentId = MSDSIntSiteHomeHelper.createMSDSDocument(documentsList.documents.get(0));
        	System.assertNotEquals(null, documentId);
        Test.stopTest();           
    }
    
    public static testMethod void getMaterialSearchResults() {
        setupData();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(200, '200', SEARCH_RESPONSE, new Map<String, String>()));
            String valueToSearch = '5467';
        	String formatSelected = '';
        	String languageSelected = '';
            String searchSelected = 'SEARCH_BY_MATERIAL_NUMBER'; 
            MSDSIntSiteHomeHelper.getMaterialSearchResults(valueToSearch, formatSelected, languageSelected, searchSelected);
        Test.stopTest();           
    }
    
    public static testMethod void getMaterialSearchResultsEx() {
        setupData();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(404, '404', '', new Map<String, String>()));
            String valueToSearch = '5467';
        	String formatSelected = '';
        	String languageSelected = '';
            String searchSelected = 'SEARCH_BY_MATERIAL_NUMBER'; 
            MSDSIntSiteHomeHelper.getMaterialSearchResults(valueToSearch, formatSelected, languageSelected, searchSelected);
        Test.stopTest();           
    }
    
    public static testMethod void getMaterialSearchResultsEx2() {
        setupData();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(200, '200', 'SEARCH_RESPONSE', new Map<String, String>()));
            String valueToSearch = '5467';
        	String formatSelected = '';
        	String languageSelected = '';
            String searchSelected = 'SEARCH_BY_MATERIAL_NUMBER'; 
            MSDSIntSiteHomeHelper.getMaterialSearchResults(valueToSearch, formatSelected, languageSelected, searchSelected);
        Test.stopTest();           
    }
    
    public static testMethod void getMaterialSearchResultsEx3() {
        setupData();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(200, '200', 'SEARCH_RESPONSE', new Map<String, String>()));
            String valueToSearch = '5467';
        	String formatSelected = '';
        	String languageSelected = '';
            String searchSelected = null; 
            MSDSIntSiteHomeHelper.getMaterialSearchResults(valueToSearch, formatSelected, languageSelected, searchSelected);
        Test.stopTest();           
    }
}