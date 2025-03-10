let rec suffixes xs =
  match xs with
  | [] -> [[]]
  | _ :: t ->
    (* xs jest jednym sufiksem, następne sufiksy to rekurencyjnie suffixes t *)
    xs :: suffixes t;;
