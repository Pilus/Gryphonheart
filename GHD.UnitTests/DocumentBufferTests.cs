
namespace GHD.UnitTests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using GHD.Document.Buffer;
    using Moq;
    using GHD.Document.Flags;
    using GHD.Document.Containers;
    using GHD.Document.Elements;
    using GHD.Document;
    using GHD.UnitTests.Mocks;

    [TestClass]
    public class DocumentBufferTests
    {
        private Mock<ITextScoper> textScoperMock;
        private DocumentBuffer bufferUnderTest;

        [TestInitialize]
        public void TestInitialize()
        {
            this.textScoperMock = new Mock<ITextScoper>();
            var elementFactoryMock = new Mock<IElementFactory>();
            elementFactoryMock.Setup(fac => fac.Create(It.IsAny<Flags>(), It.IsAny<bool>())).Returns<Flags, bool>((f, allowZeroPosition) => new FormattedTextMock() { Flags = f, AllowZeroPosition = allowZeroPosition });
            this.bufferUnderTest = new DocumentBuffer(elementFactoryMock.Object, textScoperMock.Object);
        }

        [TestMethod]
        public void AppendPeekAndGetTextWithSameFlags()
        {
            // Arrange
            var flags = new Flags()
            {
                FontSize = 12,
                Font = "x"
            };
            var initialWidth = 30;
            var constraint = new DimensionConstraint() { MaxHeight = 12, MaxWidth = initialWidth };
            var text = "A string";

            // The whole text can fit within the given width
            textScoperMock.Setup(ts => ts.GetFittingText(flags.Font, flags.FontSize, text, initialWidth)).Returns(text);

            // Act
            bufferUnderTest.Append(text, flags);
            
            var peekedText = bufferUnderTest.Peek(constraint, flags);
            var takenText = bufferUnderTest.Take(constraint, flags);
            var bufferEmpty1 = bufferUnderTest.EndOfBuffer();

            bufferUnderTest.Append(text, flags);
            var peekedObject = (FormattedTextMock)bufferUnderTest.Peek(constraint);
            var takenObject = (FormattedTextMock)bufferUnderTest.Take(constraint);
            var bufferEmpty2 = bufferUnderTest.EndOfBuffer();

            // Assert
            Assert.AreEqual(text, peekedText);
            Assert.AreEqual(text, takenText);
            Assert.IsTrue(bufferEmpty1, "The buffer should be empty");

            Assert.AreEqual(text, peekedObject.Text);
            Assert.AreEqual(false, peekedObject.AllowZeroPosition);
            Assert.AreEqual(flags, peekedObject.Flags);
            Assert.AreEqual(text, takenObject.Text);
            Assert.AreEqual(false, takenObject.AllowZeroPosition);
            Assert.AreEqual(flags, takenObject.Flags);
            Assert.IsTrue(bufferEmpty2, "The buffer should be empty");
        }

        [TestMethod]
        public void AppendPeekAndGetTextWithSameFlagsTooLongForTheConstraints()
        {
            // Arrange
            var flags = new Flags()
            {
                FontSize = 12,
                Font = "x"
            };
            var initialWidth = 25;
            var constraint = new DimensionConstraint() { MaxHeight = 12, MaxWidth = initialWidth };
            var text = "A longer text string";
            var firstText = "A longer";
            var secondText = " text string";

            // The whole text can fit within the given width
            textScoperMock.Setup(ts => ts.GetFittingText(flags.Font, flags.FontSize, text, initialWidth)).Returns(firstText);
            textScoperMock.Setup(ts => ts.GetFittingText(flags.Font, flags.FontSize, secondText, initialWidth)).Returns(secondText);

            // Act
            bufferUnderTest.Append(text, flags);

            var peekedText = bufferUnderTest.Peek(constraint, flags);
            var takenText = bufferUnderTest.Take(constraint, flags);
            var additionalPeekedText = bufferUnderTest.Peek(constraint, flags);
            var additionalTakenText = bufferUnderTest.Take(constraint, flags);
            var bufferEmpty1 = bufferUnderTest.EndOfBuffer();

            bufferUnderTest.Append(text, flags);
            var peekedObject = (FormattedTextMock)bufferUnderTest.Peek(constraint);
            var takenObject = (FormattedTextMock)bufferUnderTest.Take(constraint);
            var additionalPeekedObject = (FormattedTextMock)bufferUnderTest.Peek(constraint);
            var additionalTakenObject = (FormattedTextMock)bufferUnderTest.Take(constraint);
            var bufferEmpty2 = bufferUnderTest.EndOfBuffer();

            // Assert
            Assert.AreEqual(firstText, peekedText);
            Assert.AreEqual(secondText, additionalPeekedText);
            Assert.AreEqual(firstText, takenText);
            Assert.AreEqual(secondText, additionalTakenText);
            Assert.IsTrue(bufferEmpty1, "The buffer should be empty");

            Assert.AreEqual(firstText, peekedObject.Text);
            Assert.AreEqual(false, peekedObject.AllowZeroPosition);
            Assert.AreEqual(flags, peekedObject.Flags);
            Assert.AreEqual(firstText, takenObject.Text);
            Assert.AreEqual(false, takenObject.AllowZeroPosition);
            Assert.AreEqual(flags, takenObject.Flags);
            Assert.AreEqual(secondText, additionalPeekedObject.Text);
            Assert.AreEqual(false, additionalPeekedObject.AllowZeroPosition);
            Assert.AreEqual(flags, additionalPeekedObject.Flags);
            Assert.AreEqual(secondText, additionalTakenObject.Text);
            Assert.AreEqual(false, additionalTakenObject.AllowZeroPosition);
            Assert.AreEqual(flags, additionalTakenObject.Flags);
            Assert.IsTrue(bufferEmpty2, "The buffer should be empty");
        }

        [TestMethod]
        public void AppendPeekAndGetTextWithElementSmallerThanWidth()
        {
            // Arrange
            var flags = new Flags()
            {
                FontSize = 12,
                Font = "x"
            };

            var constraint = new DimensionConstraint() { MaxHeight = 12, MaxWidth = 30 };

            // The whole text can fit within the given width
            var elementMock = new Mock<IElement>();
            elementMock.Setup(e => e.GetHeight()).Returns(12);
            elementMock.Setup(e => e.GetWidth()).Returns(25);

            // Act
            bufferUnderTest.Append(elementMock.Object);

            var peekedText = bufferUnderTest.Peek(constraint, flags);
            var takenText = bufferUnderTest.Take(constraint, flags);
            var bufferEmpty1 = bufferUnderTest.EndOfBuffer();

            var peekedObject = bufferUnderTest.Peek(constraint);
            var takenObject = bufferUnderTest.Take(constraint);
            var bufferEmpty2 = bufferUnderTest.EndOfBuffer();

            // Assert
            Assert.AreEqual(null, peekedText);
            Assert.AreEqual(null, takenText);
            Assert.IsFalse(bufferEmpty1, "The buffer should not be empty");

            Assert.AreEqual(elementMock.Object, peekedObject);
            Assert.AreEqual(elementMock.Object, takenObject);
            Assert.IsTrue(bufferEmpty2, "The buffer should be empty");
        }


        [TestMethod]
        public void AppendPeekAndGetTextWithElementLargerThanWidth()
        {
            // Arrange
            var flags = new Flags()
            {
                FontSize = 12,
                Font = "x"
            };

            var constraint = new DimensionConstraint() { MaxHeight = 12, MaxWidth = 30 };

            // The whole text can fit within the given width
            var elementMock = new Mock<IElement>();
            elementMock.Setup(e => e.GetHeight()).Returns(12);
            elementMock.Setup(e => e.GetWidth()).Returns(45);

            // Act
            bufferUnderTest.Append(elementMock.Object);

            var peekedText = bufferUnderTest.Peek(constraint, flags);
            var takenText = bufferUnderTest.Take(constraint, flags);
            var bufferEmpty1 = bufferUnderTest.EndOfBuffer();

            var peekedObject = bufferUnderTest.Peek(constraint);
            var takenObject = bufferUnderTest.Take(constraint);
            var bufferEmpty2 = bufferUnderTest.EndOfBuffer();

            // Assert
            Assert.AreEqual(null, peekedText);
            Assert.AreEqual(null, takenText);
            Assert.IsFalse(bufferEmpty1, "The buffer should not be empty");

            Assert.AreEqual(null, peekedObject);
            Assert.AreEqual(null, takenObject);
            Assert.IsFalse(bufferEmpty2, "The buffer should not be empty");
        }

        [TestMethod]
        public void AppendPeekAndGetTextWithTextLargerThanHeight()
        {
            // Arrange
            var flags = new Flags()
            {
                FontSize = 12,
                Font = "x"
            };

            var constraint = new DimensionConstraint() { MaxHeight = 12, MaxWidth = 30 };

            // The whole text can fit within the given width
            var elementMock = new Mock<IElement>();
            elementMock.Setup(e => e.GetHeight()).Returns(14);
            elementMock.Setup(e => e.GetWidth()).Returns(14);

            // Act
            bufferUnderTest.Append(elementMock.Object);

            var peekedText = bufferUnderTest.Peek(constraint, flags);
            var takenText = bufferUnderTest.Take(constraint, flags);
            var bufferEmpty1 = bufferUnderTest.EndOfBuffer();

            var peekedObject = bufferUnderTest.Peek(constraint);
            var takenObject = bufferUnderTest.Take(constraint);
            var bufferEmpty2 = bufferUnderTest.EndOfBuffer();

            // Assert
            Assert.AreEqual(null, peekedText);
            Assert.AreEqual(null, takenText);
            Assert.IsFalse(bufferEmpty1, "The buffer should not be empty");

            Assert.AreEqual(null, peekedObject);
            Assert.AreEqual(null, takenObject);
            Assert.IsFalse(bufferEmpty2, "The buffer should not be empty");
        }

        [TestMethod]
        public void AppendPeekAndGetTextWithTextNotFittingFlags()
        {
            // Arrange
            var flags1 = new Flags()
            {
                FontSize = 12,
                Font = "x"
            };
            var flags2 = new Flags()
            {
                FontSize = 14,
                Font = "y"
            };
            var initialWidth = 30;
            var constraint = new DimensionConstraint() { MaxHeight = 12, MaxWidth = initialWidth };
            var text = "A string";

            // Act
            bufferUnderTest.Append(text, flags1);

            var peekedText = bufferUnderTest.Peek(constraint, flags2);
            var takenText = bufferUnderTest.Take(constraint, flags2);
            var bufferEmpty = bufferUnderTest.EndOfBuffer();

            // Assert
            Assert.AreEqual(null, peekedText);
            Assert.AreEqual(null, takenText);
            Assert.IsFalse(bufferEmpty, "The buffer should not be empty");
        }
    }
}
