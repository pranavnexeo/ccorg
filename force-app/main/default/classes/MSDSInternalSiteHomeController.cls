public with sharing class MSDSInternalSiteHomeController {

   	public String materialNumber {get; set;}
    public String materialName {get; set;}
    public String formatSelected {get; set;}
    public String languageSelected {get; set;}
    public String searchSelected {get; set;}
    public String valueToSearch {get; set;}
    public Boolean showSearchResults {get; set;}
    public Boolean showErrorMessage {get; set;}
    public String errorMessage {get; set;}
    public List<MaterialSearchResponse.material_list> materialResultList {get; private set;}
    public Map<Integer, List<MaterialSearchResponse.material_list>> paginatedMaterials {get; set;} //Number of Page, list
    public List<MaterialSearchResponse.material_list> materialResultListToShow {get; private set;}
    //Pagination variables
    public List<Integer> availablePages {get; set;}
    public Integer pageNumber {get; set;}
    public Integer totalPages {get; set;}
    public Integer maxNumberOfRecordsPerPage;
    public Integer paginationLimit {get; set;}
    public Integer startAt {get; set;}
    public Integer endAt {get; set;}

    public MSDSInternalSiteHomeController (){
        MSDS_Site__c siteSettings = MSDS_Site__c.getInstance();
        System.debug('siteSettings.Max_Number_Of_Records_Per_Page__c ' + siteSettings.Max_Number_Of_Records_Per_Page__c);
        maxNumberOfRecordsPerPage = Integer.valueOf(siteSettings.Max_Number_Of_Records_Per_Page__c);
        paginationLimit = Integer.valueOf(siteSettings.Pagination_Limit__c);
        pageNumber = 1;
    }

    //Init of pagination methods
    public String hasPrevious {
        get {
            if (pageNumber == 1) {
                return 'disabled';
            }
            else {
                return '';
            }
        }
        set;
    }

    public String hasNext {
        get {
            if (totalPages <= pageNumber || (totalPages == 1 || totalPages == 0)) {
                return 'disabled';
            }
            else {
                return '';
            }
        }
        set;
    }

    public void first() {
        pageNumber = 1;
        updatePagiantedMaterials();
    }

    public void last() {
        pageNumber = totalPages;
        updatePagiantedMaterials();
    }

    public void previous() {
        pageNumber--;
        updatePagiantedMaterials();
    }

    public void next() {
        pageNumber++;
        updatePagiantedMaterials();
    }

    public void goToPage(){
        updatePagiantedMaterials();
    }

    public void updatePagiantedMaterials() {
        System.debug('updatePagiantedMaterials');
        System.debug('pageNumber ' + pageNumber);
        materialResultListToShow = new List<MaterialSearchResponse.material_list>();
        materialResultListToShow.addAll(paginatedMaterials.get(pageNumber));
        availablePages = new List<Integer>();
        //if (pageNumber > paginationLimit) {
            Integer size = paginatedMaterials.size();
            startAt = (Integer) (pageNumber - Math.floor(paginationLimit / 2));
            endAt = (Integer) (pageNumber + Math.floor(paginationLimit / 2));

            if (startAt <= 0) {
                endAt -= (startAt - 1);
                startAt = 1;
            }

            if (endAt > size) {
                endAt = size;
                if (endAt - paginationLimit + 1 > 0) {
                    startAt = endAt - paginationLimit + 1;
                } else {
                    startAt = 1;
                }
            }

            for (Integer i = startAt; i <= endAt; i++) {
                availablePages.add(i);
            }
        //}
    }

    public void createPaginatedList(){
        Integer numberOfPage = 1;
        paginatedMaterials = new Map<Integer, List<MaterialSearchResponse.material_list>>();
        System.debug(maxNumberOfRecordsPerPage <= materialResultList.size());
        System.debug('maxNumberOfRecordsPerPage ' + maxNumberOfRecordsPerPage);
        System.debug('materialResultList.size() ' + materialResultList.size());
        if (maxNumberOfRecordsPerPage >= materialResultList.size()) {
            paginatedMaterials.put(numberOfPage, materialResultList);
            numberOfPage = 1;
            totalPages = numberOfPage;
        } else {
            Integer numberOfMaterials = 0;
            for (MaterialSearchResponse.material_list currentMaterial : materialResultList) {
                if ( numberOfMaterials < maxNumberOfRecordsPerPage) {
                    if (paginatedMaterials.containsKey(numberOfPage)) {
                        List<MaterialSearchResponse.material_list> currentMaterialList =  paginatedMaterials.get(numberOfPage);
                        currentMaterialList.add(currentMaterial);
                        paginatedMaterials.put(numberOfPage, currentMaterialList);
                    } else {
                        List<MaterialSearchResponse.material_list> newListOfMaterials  =  new List<MaterialSearchResponse.material_list>();
                        newListOfMaterials.add(currentMaterial);
                        paginatedMaterials.put(numberOfPage, newListOfMaterials);
                    }
                    numberOfMaterials++;
                }

                if (numberOfMaterials == maxNumberOfRecordsPerPage) {
                    numberOfMaterials = 0;
                    numberOfPage ++;
                }


            }
            totalPages = numberOfPage;
        }
    }

    public List<SelectOption> getFormatOptions() {
        List<SelectOption> formatOptions = new List<SelectOption>();
        for(MSDSValidFormat__mdt currentFormat: [SELECT Format_Code__c, Order__c, Text_Value__c FROM MSDSValidFormat__mdt ORDER BY Order__c ASC ]){
            String formatCode= (currentFormat.Format_Code__c == null ? '' :currentFormat.Format_Code__c);
            formatOptions.add(new SelectOption(formatCode, currentFormat.Text_Value__c));
        }

        return formatOptions;
    }

    public List<SelectOption> getLanguageOptions() {
        List<SelectOption> languageOptions = new List<SelectOption>();
        for(MSDSValidLanguage__mdt currentLanguage: [SELECT Language_Code__c, Order__c, Text_Value__c FROM MSDSValidLanguage__mdt ORDER BY Order__c ASC ]){
            String langCode= (currentLanguage.Language_Code__c == null ? '' :currentLanguage.Language_Code__c);
            languageOptions.add(new SelectOption(langCode, currentLanguage.Text_Value__c));
        }

        return languageOptions;
    }

    public List<SelectOption> getSearchOptions() {
        List<SelectOption> searchOptions = new List<SelectOption>();
        for(MSDSValidSearchOption__mdt currentOption: [SELECT MasterLabel, Order__c,MSDS_Search_Code__c FROM MSDSValidSearchOption__mdt ORDER BY Order__c ASC ]){
            String optionCode= (currentOption.MSDS_Search_Code__c == null ? '' :currentOption.MSDS_Search_Code__c);
            searchOptions.add(new SelectOption(optionCode, currentOption.MasterLabel));
        }

        return searchOptions;
    }

    //In order to manage the command action of the search
    public PageReference searchMaterial() {
        System.debug(' valueToSearch ' +  valueToSearch );
        System.debug(' formatSelected ' + formatSelected );
        System.debug(' languageSelected ' + languageSelected );
        System.debug(' searchSelected ' +  searchSelected);
        showErrorMessage = false;
        List<MaterialSearchResponse> searchResults = MSDSIntSiteHomeHelper.getMaterialSearchResults(nullToBlank(valueToSearch), nullToBlank(formatSelected), nullToBlank(languageSelected), nullToBlank(searchSelected));
        if ( null != searchResults.get(0).material_list) {
            if (!searchResults.get(0).material_list.isEmpty()) {
                materialResultList = searchResults.get(0).material_list;
                createPaginatedList();
                updatePagiantedMaterials();
                showSearchResults = true;
            } else {
                showSearchResults = false;
            }
        } else {
            showSearchResults = false;
        }
        //verify if there is any message on the status
        System.debug(searchResults.get(0));
        if ( null != searchResults.get(0).status ) {
            if (!searchResults.get(0).status.isEmpty()) {
            if ( null != searchResults.get(0).status.get(0).message) {
                    errorMessage = searchResults.get(0).status.get(0).message;
                if (String.isNotEmpty(errorMessage)) {
                    showErrorMessage = true;
                }
            }
        }
        }
        return null;
    }

    public String nullToBlank(String valueString){

        if (null == valueString) {
            return '';
        } else {
            return valueString;
        }
    }

    //When user has clicked on a material
    //and wants to see the
    public PageReference goToMaterialDetail() {
        System.debug('goToMaterialDetail');
        if(materialNumber != null){
            System.debug('materialNumber' + materialNumber);
            PageReference pageRef = new PageReference('/apex/MSDSSiteMaterialDetail');
            pageRef.setRedirect(true);
            pageRef.getParameters().put('materialNumber',materialNumber);
            pageRef.getParameters().put('materialName',materialName);
            return pageRef;
        }  else{
            return null;
        }
    }

    //When user has clicked MaterialSearch
    public PageReference goToMaterialSearch() {
        System.debug('goToMaterialSearch');
        PageReference pageRef = new PageReference('/apex/MSDSIntSiteHome');
        pageRef.setRedirect(true);
        return pageRef;

    }

}