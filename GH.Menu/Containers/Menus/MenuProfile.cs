
namespace GH.Menu.Containers.Menus
{
    using System;
    using System.Collections.Generic;

    using GH.Menu.Containers.Page;

    public class MenuProfile : List<PageProfile>, IContainerProfile<PageProfile>
    {
        public string name;

        public bool useWindow = true;

        public MenuThemeType theme = MenuThemeType.BlankTheme;

        public double? lineSpacing;

        public double? height;

        public double width;

        public Action onShow;

        public Action OnShow;

        public Action OnOk;

        public MenuProfile(string name, double width, Action OnOk)
        {
            this.name = name;
            this.width = width;
            this.OnOk = OnOk;
        }

        public MenuProfile(string name, double width, Action OnOk, bool useWindow, Action onShow, double? lineSpacing, double? height)
        {
            this.useWindow = useWindow;
            this.name = name;
            this.lineSpacing = lineSpacing;
            this.height = height;
            this.width = width;
            this.onShow = onShow;
            this.OnOk = OnOk;
        }

        // Windowed menu
        public string icon { get; set; }

        public string title { get; set; }

        // todo: menuBar

        public bool? statusBar { get; set; }

        public string background { get; set; }

        public Action onHide { get; set; }

        // Windowed wizard menu
        public Action OnPageChange { get; set; }
    }
}
