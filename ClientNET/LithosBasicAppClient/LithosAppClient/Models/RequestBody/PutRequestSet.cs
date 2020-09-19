using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace LithosAppClient.Models.RequestBody
{
    public class PutRequestSet
    {
        [JsonProperty(PropertyName = "updtCoreConfigTable")]
        public PutRequestData[] RequestData { get; set;}
    }
}
