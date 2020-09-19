using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace LithosAppClient.Models.RequestBody
{
    public class PutRequestRoot
    {
        [JsonProperty(PropertyName = "request")]
        public PutRequest PutRequest { get; set; }
    }
}
