let matrix_mult (a, b, c, d) (e, f, g, h) =
  (a *. e +. b *. g,
   a *. f +. b *. h,
   c *. e +. d *. g,
   c *. f +. d *. h);;

let matrix_id = (1., 0., 0., 1.);;

let matrix_expt m k =
  let rec aux acc i =
    if i = 0 then acc
    else aux (matrix_mult acc m) (i - 1)
  in
  aux matrix_id k;;

let fib_matrix k =
  let fib_m = (1., 1., 1., 0.) in
  let (a, b, c, d) = matrix_expt fib_m k in b;;  (* lub c – oba to F_k *)
  (* a = F_{k+1}, b = F_k, c = F_k, d = F_{k-1} *)
