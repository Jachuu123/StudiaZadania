using System;
// Używamy namespace Zadanie1 (strumienie) i Zadanie3 (leniwe listy)
using Zadanie1;
using Zadanie3;

namespace MojaAplikacja
{
    class Program
    {
        static void Main(string[] args)
        {
            TestZadanie1();
            Console.WriteLine();
            TestZadanie3();
        }

        static void TestZadanie1()
        {
            Console.WriteLine("=== TEST (Zad 1) IntStream ===");
            IntStream stream = new IntStream();
            for (int i = 0; i < 10; i++)
            {
                if (!stream.Eos())
                {
                    Console.Write(stream.Next() + " ");
                }
            }
            Console.WriteLine();

            // Reset
            stream.Reset();
            Console.WriteLine("Po resecie: " + stream.Next());

            Console.WriteLine("\n=== TEST (Zad 1) FibStream ===");
            FibStream fib = new FibStream();
            for (int i = 0; i < 10; i++)
            {
                if (!fib.Eos())
                {
                    Console.Write(fib.Next() + " ");
                }
                else
                {
                    Console.WriteLine("Koniec strumienia Fib!");
                    break;
                }
            }
            Console.WriteLine();

            Console.WriteLine("\n=== TEST (Zad 1) RandomStream ===");
            RandomStream rs = new RandomStream();
            for (int i = 0; i < 5; i++)
            {
                Console.WriteLine(rs.Next());
            }

            Console.WriteLine("\n=== TEST (Zad 1) RandomWordStream ===");
            RandomWordStream rws = new RandomWordStream();
            for (int i = 0; i < 8; i++)
            {
                if (!rws.Eos())
                {
                    string word = rws.Next();
                    Console.WriteLine($"Słowo: {word} (dł: {word.Length})");
                }
                else
                {
                    Console.WriteLine("Koniec strumienia słów!");
                    break;
                }
            }
        }

        static void TestZadanie3()
        {
            Console.WriteLine("=== TEST (Zad 3) LazyIntList ===");
            LazyIntList lista = new LazyIntList();
            Console.WriteLine("Rozmiar początkowy listy: " + lista.size()); // 0

            int e40 = lista.element(40);
            Console.WriteLine($"element(40) = {e40}");         // 39
            Console.WriteLine("Rozmiar listy: " + lista.size()); // 40

            int e38 = lista.element(38);
            Console.WriteLine($"element(38) = {e38}");         // 37
            Console.WriteLine("Rozmiar listy: " + lista.size()); // 40

            Console.WriteLine($"element(50) = {lista.element(50)}");
            Console.WriteLine("Rozmiar listy: " + lista.size()); // 50

            Console.WriteLine("\n=== TEST (Zad 3) LazyPrimeList ===");
            LazyPrimeList primeList = new LazyPrimeList();
            Console.WriteLine("Size startowe: " + primeList.size()); // 0

            Console.WriteLine($"element(1) -> {primeList.element(1)}"); // 2
            Console.WriteLine($"element(2) -> {primeList.element(2)}"); // 3
            Console.WriteLine($"element(3) -> {primeList.element(3)}"); // 5
            Console.WriteLine($"element(10) -> {primeList.element(10)}"); // 29
            Console.WriteLine("Size: " + primeList.size()); // 10

            Console.WriteLine($"element(12) -> {primeList.element(12)}"); // 37
            Console.WriteLine("Size: " + primeList.size()); // 12

            Console.WriteLine($"element(8)  -> {primeList.element(8)}");  // 19
            Console.WriteLine("Size: " + primeList.size()); // 12
        }
    }
}
