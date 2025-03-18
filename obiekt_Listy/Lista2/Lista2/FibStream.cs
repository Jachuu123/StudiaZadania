using System;

namespace Zadanie1
{
    public class FibStream : IntStream
    {
        private int fib1;    // F(n-2)
        private int fib2;    // F(n-1)

        public FibStream()
        {
            Reset();
        }

        public override int Next()
        {
            if (finished)
                return fib2;

            int result = fib2;

            if (fib1 > int.MaxValue - fib2)
            {
                finished = true;
            }
            else
            {
                int temp = fib1 + fib2;
                fib1 = fib2;
                fib2 = temp;
            }

            return result;
        }

        public override bool Eos()
        {
            return finished;
        }

        public override void Reset()
        {
            fib1 = 0;   // F(0)
            fib2 = 1;   // F(1)
            finished = false;
        }
    }
}
