
namespace GHD.UnitTests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using GHD.Document.Buffer;
    using Moq;
    using GHD.Document.Flags;
    using GHD.Document.Containers;

    [TestClass]
    public class DocumentBufferTests
    {
        [TestMethod]
        public void AppendPeekAndGetTextWithSameFlags()
        {
            // Arrange
            var elementFactoryMock = new Mock<IElementFactory>();

            var bufferUnderTest = new DocumentBuffer(elementFactoryMock.Object);
            var flags = new Flags()
            {
                Font = "x"
            };
            var text = "A string";
            var constraint = new DimensionConstraint() { MaxHeight = 12, MaxWidth = 100 };
            elementFactoryMock.Setup(fac => fac.Create(flags)).Returns((flags) => { return null; });

            // Act
            bufferUnderTest.Append(text, flags);
            var peekedObject = bufferUnderTest.Peek(constraint);
            var peekedText = bufferUnderTest.Peek(constraint, flags);
            var takenText = bufferUnderTest.Take(constraint, flags);
            bufferUnderTest.Append(text, flags);
            var takenObject = bufferUnderTest.Take(constraint);

            // Assert
            //peekedText
        }
    }
}
