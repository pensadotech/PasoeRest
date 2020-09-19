using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace LithosAppClient.Models.Response
{
    public class ResponseRootobject
    {
        [JsonProperty(PropertyName = "response")]
        public Response Response { get; set; }
    }
}
