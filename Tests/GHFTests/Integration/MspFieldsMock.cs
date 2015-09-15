namespace Tests.GHFTests.Integration
{
    using System.Collections.Generic;
    using GHF.Model.MSP;

    public class MspFieldsMock : Dictionary<string, string>, IMSPFields
    {
    }
}