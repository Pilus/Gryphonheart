

namespace Lua
{
    using System;
    using System.Linq;

    public static class LuaMath
    {
        /// <summary>
        /// Returns the absolute value of the number.
        /// </summary>
        public static double abs(double value)
        {
            return System.Math.Abs(rad(value));
        }

        /// <summary>
        /// Returns the arc cosine of the value in degrees.
        /// </summary>
        public static double acos(double value)
        {
            return System.Math.Acos(rad(value));
        }

        /// <summary>
        /// Returns the arc sine of the value in degrees.
        /// </summary>
        public static double asin(double value)
        {
            return System.Math.Asin(rad(value));
        }

        /// <summary>
        /// Returns the arc tangent of the value in degrees.
        /// </summary>
        public static double atan(double value)
        {
            return System.Math.Atan(rad(value));
        }

        /// <summary>
        /// Returns the arc tangent of Y/X in degrees.
        /// </summary>
        public static double atan2(double y, double x)
        {
            return System.Math.Atan(y/x);
        }

        /// <summary>
        /// Returns the ceiling of value.
        /// </summary>
        public static double ceil(double value)
        {
            return System.Math.Ceiling(rad(value));
        }

        /// <summary>
        /// Returns the cosine of the degree value.
        /// </summary>
        public static double cos(double value)
        {
            return System.Math.Cos(rad(value));
        }

        /// <summary>
        /// Returns the degree equivalent of the radian value.
        /// </summary>
        public static double deg(double radians)
        {
            return (radians*180)/System.Math.PI;
        }

        /// <summary>
        /// Returns the radian equivalent of the degree value.
        /// </summary>
        public static double rad(double degrees)
        {
            return (degrees*System.Math.PI)/180;
        }

        /// <summary>
        /// Returns the exponent of value.
        /// </summary>
        public static double exp(double value)
        {
            return System.Math.Exp(value);
        }

        /// <summary>
        /// Returns the floor of value.
        /// </summary>
        public static double floor(double value)
        {
            return System.Math.Floor(value);
        }

        /// <summary>
        /// Extract mantissa and exponent from a floating point number.
        /// </summary>
        public static Tuple<int, int> frexp(double value)
        {
            throw new System.NotImplementedException();
        }

        /// <summary>
        /// Load exponent of a floating point number.
        /// </summary>
        public static double ldexp(int value, int exponent)
        {
            throw new System.NotImplementedException();
        }

        /// <summary>
        /// Returns the natural logarithm (log base e) of value.
        /// </summary>
        public static double log(double value)
        {
            return System.Math.Log(value);
        }

        /// <summary>
        /// Returns the base-10 logarithm of value.
        /// </summary>
        public static double log10(double value)
        {
            return System.Math.Log10(value);
        }

        /// <summary>
        /// Returns the numeric maximum of the input values.
        /// </summary>
        public static double max(params double[] values)
        {
            return values.Max(v => v);
        }

        /// <summary>
        /// Returns the numeric maximum of the input values.
        /// </summary>
        public static int max(params int[] values)
        {
            return values.Max(v => v);
        }

        /// <summary>
        /// Returns the numeric minimum of the input values.
        /// </summary>
        public static int min(params int[] values)
        {
            return values.Min(v => v);
        }


        /// <summary>
        /// Returns the numeric minimum of the input values.
        /// </summary>
        public static double min(params double[] values)
        {
            return values.Min(v => v);
        }

        /// <summary>
        /// Returns floating point modulus of value.
        /// </summary>
        public static double mod(double value, int modulus)
        {
            return value % modulus;
        }

        /// <summary>
        /// Returns a random number (optionally bounded integer value)
        /// </summary>
        public static double random(int upper)
        {
            var random = new Random();
            return random.Next(upper);
        }

        /// <summary>
        /// Returns a random number (optionally bounded integer value)
        /// </summary>
        public static double random(int lower, int upper)
        {
            var random = new Random();
            return random.Next(lower, upper);
        }

        /// <summary>
        /// Returns the sine of the degree value.
        /// </summary>
        public static double sin(double value)
        {
            return System.Math.Sin(rad(value));
        }

        /// <summary>
        /// Return the square root of value.
        /// </summary>
        public static double sqrt(double value)
        {
            return System.Math.Sqrt(value);
        }

        /// <summary>
        /// Returns the tangent of the degree value.
        /// </summary>
        public static double tan(double value)
        {
            return System.Math.Tan(rad(value));
        }
    }
}
