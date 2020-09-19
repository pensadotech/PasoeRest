using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace LithosAppClient.Models.RequestBody
{  
    public class PostRequest
    {
        [JsonProperty(PropertyName = "cfgGrp")]
        public string CfgGrp { get; set; }

        [JsonProperty(PropertyName = "cfgSgrp")]
        public string CfgSgrp { get; set; }

        [JsonProperty(PropertyName = "keyName")]
        public string KeyName { get; set; }

        [JsonProperty(PropertyName = "keyValue")]
        public string KeyValue { get; set; }

        [JsonProperty(PropertyName = "keyNotes")]
        public string Notes { get; set; }
    }
}
