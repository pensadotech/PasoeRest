using LithosAppClient.Defs;
using LithosAppClient.Interfaces;
using LithosAppClient.Models.Response;
using LithosAppClient.Models.RequestBody;
using LithosAppClient.RequestHandlers;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;

namespace LithosAppClient
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Fetching  Lithos Core configuration.");
            Console.WriteLine();

            // Initialize handler 
            ICoreConfigApi coreCfgApi = new CoreConfigApi(new RestSharpRequestHandler());
            ResponseRootobject apiResponse;

            string TestType = "GET-ALL";
            // string TestType = "GET-ONE-GRP";
            // string TestType = "GET-GRPS";
            // string TestType = "GET-ONE-REC";
            // string TestType = "DEL-ONE-REC";
            //string TestType = "CREATE-ONE";
            //string TestType = "UPD-ONE";

            switch (TestType)
            {
                case "GET-ALL":
                    // Get All Example 
                    Console.WriteLine("Example:  Get All");
                    apiResponse = coreCfgApi.GetAll("");
                    // Visualize response
                    ViewResults(apiResponse);
                    break;
                case "GET-ONE-GRP":
                    // Get One Group
                    Console.WriteLine("Example:  Get One Group");
                    apiResponse = coreCfgApi.GetAll("TSTGRP01");
                    // Visualize response
                    ViewResults(apiResponse);
                    break;
                case "GET-GRPS":
                    // Get groups 
                    Console.WriteLine("Example:  Get Groups");
                    apiResponse = coreCfgApi.GetAllGroups();
                    // Visualize response
                    ViewResults(apiResponse);
                    break;
                case "GET-ONE-REC":
                    // Get a single record
                    Console.WriteLine("Example:  Get one record");
                    apiResponse = coreCfgApi.GetOneRecord("117");
                    // Visualize response
                    ViewResults(apiResponse);
                    break;
                case "DEL-ONE-REC":
                    // Delete one record 
                    Console.WriteLine("Example:  Delete one record");
                    apiResponse = coreCfgApi.DeleteOneRecord("117");
                    // Visualize response
                    ViewResults(apiResponse);
                    break;
                case "CREATE-ONE":
                    // // Sample record
                    Console.WriteLine("Example:  Create one record");
                    // Call API 
                    PostRequestRoot postReqObj = CreatePostSampleRecrod();
                    apiResponse = coreCfgApi.CreateOneRecord(postReqObj);
                    // Visualize response
                    ViewResults(apiResponse);

                    break;
                case "UPD-ONE":
                    // Sample record
                    PutRequestRoot putReqObj = CreatePutSampleRecord();
                    // Call API     
                    apiResponse = coreCfgApi.UpdateOneRecord("117", putReqObj);
                    // Visualize response
                    ViewResults(apiResponse);
                    break;
                default:
                    Console.WriteLine("No Test Selected");
                    break;
            }
                      
            Console.WriteLine("Hit ENTER to continue");
            Console.ReadLine();
        }
               
        public static PostRequestRoot CreatePostSampleRecrod()
        {
            // Create Jason Object 
            var reqRoot = new PostRequestRoot();
            reqRoot.PostRequest = new PostRequest
            {
                CfgGrp = "TST",
                CfgSgrp = "TSTGRP",
                KeyName = "TSTVAR4A",
                KeyValue = "abcX123",
                Notes = "Key notes"
            };

            // Validate
            string jsonString = JsonConvert.SerializeObject(reqRoot);

            return reqRoot;
        }

        public static PutRequestRoot CreatePutSampleRecord()
        {
            // Create Jason Object 
            var reqRoot = new PutRequestRoot();
            reqRoot.PutRequest = new PutRequest();
            reqRoot.PutRequest.RequestSet = new PutRequestSet();

            PutRequestData reqData = new PutRequestData
            {
                CfgGrp = "TST",
                CfgSgrp = "TSTGRP",
                KeyName = "TSTVAR4",
                KeyValue = "123abcd",
                Notes = "Key notes"
            };

            PutRequestData[] dataArr = { reqData };

            reqRoot.PutRequest.RequestSet.RequestData = dataArr;


            // Validate
            string jsonString = JsonConvert.SerializeObject(reqRoot);

            return reqRoot;

        }

        public static void ViewResults(ResponseRootobject apiResponse)
        {
            var resObj = apiResponse.Response;
            var confVarTbl = resObj.coreConfigTableWrapper.coreConfigTable;

            Console.WriteLine("pgmExec: {0}", resObj.PgmExec);
            Console.WriteLine("successMsg: {0}", resObj.SucessMsg);
            Console.WriteLine("pgmExec: {0}", resObj.SucessFlag);
            Console.WriteLine("Count: {0}", confVarTbl.Count());

            foreach (var cfgvar in confVarTbl)
            {
                Console.WriteLine("UniqueId: {0}", cfgvar.UniqueId);
                Console.WriteLine("CfgGrp: {0}", cfgvar.CfgGrp);
                Console.WriteLine("CfgSgrp: {0}", cfgvar.CfgSgrp);
                Console.WriteLine("KeyName: {0}", cfgvar.KeyName);
                Console.WriteLine("KeyValue: {0}", cfgvar.KeyValue);
                Console.WriteLine("Notes: {0}", cfgvar.Notes);
                Console.WriteLine("ModifyBy: {0}", cfgvar.ModifyBy);
                Console.WriteLine("ModifyDate: {0}", cfgvar.ModifyDate);

                Console.WriteLine();
            }
        }
          
    }
}
