using LithosAppClient.Defs;
using LithosAppClient.Interfaces;
using LithosAppClient.Models.Response;
using LithosAppClient.Models.RequestBody;
using Newtonsoft.Json;

namespace LithosAppClient.RequestHandlers
{
    public class CoreConfigApi : ICoreConfigApi
    {
        // Provate members 
        // Initialize handler 
        IRequestHandler restSharpRequestHandler;

        public CoreConfigApi(IRequestHandler reqHandler)
        {
            restSharpRequestHandler = reqHandler;
        }

        // Methods ....................................
        public ResponseRootobject GetAll(string tgtGrp)
        {
            // Prepare URI
            string tgtUrl = Definitions.configvarsUrl;
            string qryParam = tgtGrp;

            // GET request 
            string apiRawResponse = restSharpRequestHandler.GET(tgtUrl, qryParam);

            // Deserialize response
            ResponseRootobject apiResponse = JsonConvert.DeserializeObject<ResponseRootobject>(apiRawResponse);

            return apiResponse;
        }

        public ResponseRootobject GetAllGroups()
        {
            // Prepare URI
            string tgtUrl = Definitions.configvarsUrl + "/Groups";
            string qryParam = "";

            // GET request
            string apiRawResponse = restSharpRequestHandler.GET(tgtUrl, qryParam);

            // Deserialize response
            ResponseRootobject apiResponse = JsonConvert.DeserializeObject<ResponseRootobject>(apiRawResponse);

            return apiResponse;
        }

        public ResponseRootobject GetOneRecord(string tgtRecord)
        {
            // Prepare URI
            string tgtUrl = Definitions.configvarUrl + "/" + tgtRecord;
            string qryParam = "";

            // GET request
            string apiRawResponse = restSharpRequestHandler.GET(tgtUrl, qryParam);

            // Deserialize response
            ResponseRootobject apiResponse = JsonConvert.DeserializeObject<ResponseRootobject>(apiRawResponse);

            return apiResponse;
        }

        public ResponseRootobject DeleteOneRecord(string tgtRecord)
        {
            // Prepare URI
            string tgtUrl = Definitions.configvarUrl + "/" + tgtRecord;

            // DELETE request 
            string apiRawResponse = restSharpRequestHandler.DELETE(tgtUrl);

            // Deserialize response
            ResponseRootobject apiResponse = JsonConvert.DeserializeObject<ResponseRootobject>(apiRawResponse);

            return apiResponse;
        }

        public ResponseRootobject CreateOneRecord(PostRequestRoot reqObj)
        {
            // Prepare URI
            string tgtUrl = Definitions.configvarUrl;

            // POST request 
            string apiRawResponse = restSharpRequestHandler.POST(tgtUrl, reqObj);

            // Deserialize response
            ResponseRootobject apiResponse = JsonConvert.DeserializeObject<ResponseRootobject>(apiRawResponse);

            return apiResponse;
        }

        public ResponseRootobject UpdateOneRecord(string tgtRecord, PutRequestRoot reqObj)
        {
            // Preapre URI
            string tgtUrl = Definitions.configvarUrl + "/" + tgtRecord;

            // PUT Request
            string apiRawResponse = restSharpRequestHandler.PUT(tgtUrl, reqObj);

            // Deserialize response
            ResponseRootobject apiResponse = JsonConvert.DeserializeObject<ResponseRootobject>(apiRawResponse);

            return apiResponse;
        }




    }
}
