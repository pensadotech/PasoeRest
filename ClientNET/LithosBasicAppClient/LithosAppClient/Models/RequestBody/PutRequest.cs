using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace LithosAppClient.Models.RequestBody
{
    public class PutRequest
    {
        [JsonProperty(PropertyName = "coreConfigSet")]
        public PutRequestSet RequestSet { get; set; }
    }
}
