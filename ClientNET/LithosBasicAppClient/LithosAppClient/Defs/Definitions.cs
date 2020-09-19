using System;
using System.Collections.Generic;
using System.Text;

namespace LithosAppClient.Defs
{
    public static class Definitions
    {
        public const string configvarsUrl = "http://PROTEUS.lan:8810/rest/LithosAppService/configvars";
        public const string configvarUrl = "http://PROTEUS.lan:8810/rest/LithosAppService/configvar";

        // Examples
        // GET: http://PROTEUS.lan:8810/rest/LithosAppService/configvars
        // GET: http://PROTEUS.lan:8810/rest/LithosAppService/configvars?cfgGrp=TSTGRP01
        // GET: http://PROTEUS.lan:8810/rest/LithosAppService/configvars/Groups
        // GET: http://PROTEUS.lan:8810/rest/LithosAppService/configvar/97
        // DELETE: http://PROTEUS.lan:8810/rest/LithosAppService/configvar/117
        // PUT: http://PROTEUS.lan:8810/rest/LithosAppService/configvar/117
        // POST: http://PROTEUS.lan:8810/rest/LithosAppService/configvar




    }
}
