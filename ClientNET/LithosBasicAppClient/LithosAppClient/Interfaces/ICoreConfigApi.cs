using LithosAppClient.Models.Response;
using LithosAppClient.Models.RequestBody;

namespace LithosAppClient.Interfaces
{
    public interface ICoreConfigApi
    {
        ResponseRootobject GetAll(string tgtGrp);
        ResponseRootobject GetAllGroups();
        ResponseRootobject GetOneRecord(string tgtRecord);
        ResponseRootobject DeleteOneRecord(string tgtRecord);
        ResponseRootobject CreateOneRecord(PostRequestRoot reqObj);
        ResponseRootobject UpdateOneRecord(string tgtRecord, PutRequestRoot reqObj);
    }
}
