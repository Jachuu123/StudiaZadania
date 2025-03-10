let rec matrix_expt_fast m k =
  if k = 0 then matrix_id
  else if k mod 2 = 0 then
    let half = matrix_expt_fast m (k / 2) in
    matrix_mult half half
  else
    matrix_mult m (matrix_expt_fast m (k - 1));;

let fib_fast k =
  let fib_m = (1., 1., 1., 0.) in
  let (a, b, _, _) = matrix_expt_fast fib_m k in
  (* a = F_{k+1}, b = F_k *)
  b;;
