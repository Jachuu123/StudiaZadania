
        let rec fib n =
            match n with
            | 0 -> 0
            | 1 -> 1
            | _ -> fib (n - 1) + fib (n - 2);;

        let fib_iter n =
            let rec aux i a b =
                (* i – aktualny indeks, 
                 a – F_i, b – F_{i+1} *)
                if i = n then a
                else aux (i + 1) b (a + b)
            in
            aux 0 0 1;;

(*(c) Porównanie czasu
fib n (wersja rekurencyjna „z definicji”) wykonuje bardzo dużo wywołań rekurencyjnych (w przybliżeniu proporcjonalnie do 
𝜙
𝑛
ϕ 
n
 , gdzie 
𝜙
ϕ to złoty podział).
fib_iter n (wersja z akumulatorami) jest liniowa względem n.
Z tego powodu fib_iter działa znacząco szybciej dla większych wartości n.*)