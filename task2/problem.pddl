; Task 2 — Vacuum robot problem.  ===  WRITE YOUR PROBLEM HERE  ===
;
; Goal: all rooms are clean — (and (clean pokoj1) (clean pokoj2) (clean pokoj3)).

(define (problem clean-all-rooms)
  (:domain vacuum-robot)

  (:objects
    robot                    - robot
    pokoj1  pokoj2  pokoj3   - room
  )

  (:init
    ; robot starts in pokoj1
    (at robot pokoj1)

    ; all rooms are dirty at the start
    (dirty pokoj1)
    (dirty pokoj2)
    (dirty pokoj3)

    ; corridor topology: pokoj1 -- pokoj2 -- pokoj3 (bidirectional)
    (connected pokoj1 pokoj2)
    (connected pokoj2 pokoj1)
    (connected pokoj2 pokoj3)
    (connected pokoj3 pokoj2)
  )

  (:goal
    (and
      (clean pokoj1)
      (clean pokoj2)
      (clean pokoj3)
    )
  )
)
