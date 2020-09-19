using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace LithosAppClient.Models.Response
{
    public class CoreConfigTableWrapper
    {
        [JsonProperty(PropertyName = "coreConfigTable")]
        public CoreConfigTable[] coreConfigTable { get; set; }
    }
}
