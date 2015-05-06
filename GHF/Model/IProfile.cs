namespace GHF.Model
{
    using GH.ObjectHandling;

    public interface IProfile : IIdObject<string>
    {
        string FirstName { get; set; }
        string LastName { get; set; }

        string MiddleNames { get; set; }

        string Title { get; set; }

        string Appearance { get; set; }

        IDetails Details { get; set; }
    }
}