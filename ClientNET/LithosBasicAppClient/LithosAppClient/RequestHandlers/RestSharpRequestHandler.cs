using LithosAppClient.Interfaces;
using System;
using RestSharp;
using Newtonsoft.Json;

namespace LithosAppClient.RequestHandlers
{
    class RestSharpRequestHandler : IRequestHandler
    {
        public string GET(string url, string qryParam)
        {
            if (!String.IsNullOrEmpty(qryParam))
            {
                url = url + "?cfgGrp=" + qryParam;
            }

            var client = new RestClient(url);

           var rstReq = new RestRequest(Method.GET);

            var response = client.Execute(rstReq);

            if (response == null || !response.IsSuccessful)
            {
                throw new Exception(response.Content);
            }

            return response.Content;
        }

        public string DELETE(string url)
        {
            var client = new RestClient(url);

            var rstReq = new RestRequest(Method.DELETE);

            var response = client.Execute(rstReq);

            if (response == null || !response.IsSuccessful)
            {
                throw new Exception(response.Content);
            }

            return response.Content;
        }

        public string POST(string url, object JsonObj)
        {
            // Generate body Jason string
            string jsonString = JsonConvert.SerializeObject(JsonObj);

            var client = new RestClient(url);

            var rstReq = new RestRequest(Method.POST)
                            .AddJsonBody(jsonString);

            var response = client.Execute(rstReq);

            if (response == null || !response.IsSuccessful)
            {
                throw new Exception(response.Content);
            }

            return response.Content;
        }

        public string PUT(string url, object JsonObj)
        {
            // Generate body Jason string
            string jsonString = JsonConvert.SerializeObject(JsonObj);

            var client = new RestClient(url);
            
            var rstReq = new RestRequest(Method.PUT)
                             .AddJsonBody(jsonString);

            var response = client.Execute(rstReq);

            if (response == null || !response.IsSuccessful)
            {
                throw new Exception(response.Content);
            }

            return response.Content;
        }


        // Get and Deserialize         
        //public List<CoreConfigTable> GetDeserializedReleases(string url)
        //{
        //    var client = new RestClient(url);

        //    var response = client.Execute<List<CoreConfigTable>>(new RestRequest());

        //    return response.Data;
        //}



    }
}
