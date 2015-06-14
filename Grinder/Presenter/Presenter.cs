namespace Grinder.Presenter
{
    using Model;
    using View;

    public class Presenter
    {
        private IModel model;
        private IView view;

        public Presenter(IModel model, IView view)
        {
            this.model = model;
            this.view = view;
        }
    }
}