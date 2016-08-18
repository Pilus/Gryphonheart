//-----------------------–-----------------------–--------------
// <copyright file="Page.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Menu.Containers.Page
{
    using System.Linq;

    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    using CsLuaFramework.Wrapping;

    using GH.Menu.Containers.Line;

    using Lua;

    /// <summary>
    /// Container for lines.
    /// </summary>
    public class Page : BaseContainer<ILine, LineProfile>, IPage
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="Page"/> class.
        /// </summary>
        /// <param name="wrapper">Wrapper to use in object creation.</param>
        public Page(IWrapper wrapper) : base("Page", wrapper)
        {
        }

        /// <summary>
        /// Gets the name of the page.
        /// </summary>
        public string Name { get; private set; }

        /// <summary>
        /// Prepares the page with a given profile.
        /// </summary>
        /// <param name="profile">The profile to prepare with.</param>
        /// <param name="handler">The menu handler.</param>
        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            var pageProfile = (PageProfile)profile;
            this.Name = pageProfile.name;
        }

        /// <summary>
        /// Shows the page.
        /// </summary>
        public void Show()
        {
            this.Frame.Show();
        }

        /// <summary>
        /// Hides the page.
        /// </summary>
        public void Hide()
        {
            this.Frame.Hide();
        }

        /// <summary>
        /// Gets the preferred width of the page.
        /// </summary>
        /// <returns>The preferred width. Null if it is flexible.</returns>
        public double? GetPreferredWidth()
        {
            var gotLineWithNoLimit = this.Content.Any(line => line.GetPreferredWidth() == null);
            
            if (!gotLineWithNoLimit && this.Content.Any())
            {
                return this.Content.Max(line => line.GetPreferredWidth());
            }

            return null;
        }

        /// <summary>
        /// Gets the preferred height of the page.
        /// </summary>
        /// <returns>The preferred height. Null if it is flexible.</returns>
        public double? GetPreferredHeight()
        {
            var heights = this.Content.Select(line => line.GetPreferredHeight()).ToArray();

            if (!heights.Any(h => h == null))
            {
                return heights.Sum() + (this.Layout.lineSpacing * LuaMath.max(this.Content.Count - 1, 0));
            }

            return null;
        }

        /// <summary>
        /// Set the position and dimensions of the page relative to its given parent, anchoring top left to top left.
        /// </summary>
        /// <param name="parent">The parent of the page.</param>
        /// <param name="xOff">X offset.</param>
        /// <param name="yOff">Y offset, where positive is downwards.</param>
        /// <param name="width">The width of the object.</param>
        /// <param name="height">The height of the object.</param>
        public void SetPosition(IFrame parent, double xOff, double yOff, double width, double height)
        {
            height = this.GetPreferredHeight() ?? height;

            this.Frame.SetParent(parent);
            this.Frame.SetWidth(width);
            this.Frame.SetHeight(height);
            this.Frame.SetPoint(FramePoint.TOPLEFT, parent, FramePoint.TOPLEFT, xOff, -yOff);

            var heights = this.Content.Select(line => line.GetPreferredHeight()).ToArray();
            var numFlexible = heights.Count(h => h == null);
            
            var heightPrFlexObject = 
                numFlexible > 0 ? 
                (height - ((this.Layout.lineSpacing * (this.Content.Count - 1)) + heights.OfType<double>().Sum())) / numFlexible :
                0;

            var heightUsed = 0.0;
            for (var index = 0; index < this.Content.Count; index++)
            {
                var line = this.Content[index];
                var lineHeight = heights[index] ?? heightPrFlexObject;
                line.SetPosition(this.Frame, 0, heightUsed, width, lineHeight);
                heightUsed += lineHeight + this.Layout.lineSpacing;
            }
        }
    }
}