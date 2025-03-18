let product xs =
  fold_left (fun acc x -> acc * x) 1 xs;;

let product2 xs =
    List.fold_left (fun acc x -> acc * x) 1 xs;;
