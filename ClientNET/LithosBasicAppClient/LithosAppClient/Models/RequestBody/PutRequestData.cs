using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace LithosAppClient.Models.RequestBody
{
    public class PutRequestData
    {
        [JsonProperty(PropertyName = "CfgGrp")]
        public string CfgGrp { get; set; }

        [JsonProperty(PropertyName = "CfgSgrp")]
        public string CfgSgrp { get; set; }

        [JsonProperty(PropertyName = "KeyName")]
        public string KeyName { get; set; }

        [JsonProperty(PropertyName = "KeyValue")]
        public string KeyValue { get; set; }

        [JsonProperty(PropertyName = "Notes")]
        public string Notes { get; set; }
    }
}
