public with sharing class cc_imp_util_Storefront {
	/**
	 * Get the CC Se
	 */
	public static CC_Settings__c getSettingsForStorefront(String storefront){
		if(storefront == null){
			return null;
		}
		return CC_Settings__c.getInstance(storefront);

	}

	public static Id getQueueIdByName(String queueName){
		return [
			SELECT
				Id
			FROM
				Group
			WHERE
				Type = 'Queue'
			AND
				DeveloperName = :queueName
			LIMIT
				1
		].Id;
	}

	public static Id getRecordTypeIdByNameAndSObjectType(String recordTypeName, String mySobject)
	{
		return [SELECT ID, 
					  Name, 
					  DeveloperName 
			   FROM 
			       RecordType 
			   WHERE 
			       SObjectType = :mySobject 
			   AND 
			      IsActive = TRUE
			   AND 
			   DeveloperName = :recordTypeName
			   LIMIT 
			       1
			   ].Id ;
	}


	/**
	* This utitlity method will be removed when the request structure of the Nexeo API's have been corrected
	**/
	public static String formatSerializedJSONRequest(String jsonString)
	{
		String formattedString  = jsonString;

		if (String.isNotBlank(jsonString) )
		{
		  formattedString = '[' + jsonString + ']' ; 
		}

		return formattedString;
	}

	/**
	* This utitlity method will be removed when the response structure of the Nexeo API's have been corrected
	**/
	public static String formatJSONResponse(String jsonString)
	{ 
		String formattedString = jsonString;

		if (String.isNotBlank(jsonString) )
		{
			formattedString = jsonString.substring(1, jsonString.length() -1);
		}
		return formattedString;
	}


    public static ccrz.cc_RemoteActionResult fetchSDSInfo(ccrz.cc_RemoteActionContext ctx, String materialId)
    {
    	ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);

          cc_mn_json_MSDSResponse sdsCallOutResponse = cc_mn_api_FetchSDS.fetchMSDS(materialId);

          cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, sdsCallOutResponse.success, 
                                                                     new Map<String,Object>
                                                                     {'success' => sdsCallOutResponse.success,
                                                                      'sdsData' => sdsCallOutResponse.document,
                                                                      'message' => sdsCallOutResponse.message
                                                                    });
        
          return response;
    }

    public static ccrz.cc_RemoteActionResult fetchSDSAttachment(ccrz.cc_RemoteActionContext ctx, String materialId, String sfid) {
        ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);

        cc_mn_json_MSDSResponse sdsCallOutResponse = cc_mn_api_FetchSDS.fetchMSDS(materialId);

        String theId = null;
        if (!String.isBlank(sdsCallOutResponse.document)) {
            Attachment attach = new Attachment(Name = materialId + '.pdf', Description = cc_imp_mn_AttachmentCleanup.ATTACHMENT_DESCRIPTION, ParentId = sfid);
            attach.body = EncodingUtil.base64Decode(sdsCallOutResponse.document);
            insert attach;
            theId = attach.Id;
	  		cc_imp_mn_AttachmentCleanup.cleanup();
        }

        cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, sdsCallOutResponse.success, 
            new Map<String,Object>{'success' => sdsCallOutResponse.success,'sdsData' => theId,'message' => sdsCallOutResponse.message
        });
        
        return response;
    }

}