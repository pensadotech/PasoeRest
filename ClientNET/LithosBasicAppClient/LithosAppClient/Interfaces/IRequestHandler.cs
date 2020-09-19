using System;
using System.Collections.Generic;
using System.Text;

namespace LithosAppClient.Interfaces
{
    public interface IRequestHandler
    {
        //Methods
        string GET(string url, string qryParam);

        string DELETE(string url);

        string POST(string url, object JsonBody);

        string PUT(string url, object JsonBody);
    }
}
