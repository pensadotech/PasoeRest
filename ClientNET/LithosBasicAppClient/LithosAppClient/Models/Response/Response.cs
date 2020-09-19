using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace LithosAppClient.Models.Response
{
    public class Response
    {
        [JsonProperty(PropertyName = "pgmExec")]
        public string PgmExec { get; set; }

        [JsonProperty(PropertyName = "successMsg")]
        public string SucessMsg { get; set; }

        [JsonProperty(PropertyName = "sucess")]
        public bool SucessFlag { get; set; }

        [JsonProperty(PropertyName = "coreConfigTable")]
        public CoreConfigTableWrapper coreConfigTableWrapper { get; set; }

    }
}
