using System;

namespace Zadanie1
{
    public class RandomStream : IntStream
    {
        private Random rng;

        public RandomStream()
        {
            rng = new Random();
        }

        // Zwraca losowe liczby w zakresie int.MinValue..int.MaxValue
        public override int Next()
        {
            return rng.Next(int.MinValue, int.MaxValue);
        }

        public override bool Eos()
        {
            return false;
        }

        public override void Reset()
        {
            rng = new Random();
        }
    }
}
