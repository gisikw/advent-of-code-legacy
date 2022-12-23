:- initialization(main).
main :- 
  current_prolog_flag(argv, [_ | Rest]),
  Rest = [Part],
  atom_number(Part, P),
  ( P =:= 1 -> write("Part 1 not yet implemented"); write("Part 2 not yet implemented") ),
  nl,
  halt.
