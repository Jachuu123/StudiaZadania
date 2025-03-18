using System;

namespace Zadanie1
{
    public class IntStream
    {
        protected int current;
        protected bool finished;

        public IntStream()
        {
            current = 0;
            finished = false;
        }
        //virtual znaczy że klasy dziedziczone mogą nadpisywać tą metodę używając override
        public virtual int Next()
        {
            if (current == int.MaxValue)
            {
                finished = true;
                return current;
            }

            int result = current;
            current++;
            return result;
        }

        public virtual bool Eos()
        {
            return finished;
        }

        public virtual void Reset()
        {
            current = 0;
            finished = false;
        }
    }
}
