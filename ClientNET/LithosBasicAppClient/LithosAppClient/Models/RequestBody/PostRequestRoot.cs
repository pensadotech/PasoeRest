using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace LithosAppClient.Models.RequestBody
{
    public class PostRequestRoot
    {   
        [JsonProperty(PropertyName = "request")]
        public PostRequest PostRequest { get; set; }
    }
}
