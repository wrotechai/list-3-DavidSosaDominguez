; Task 2 — Vacuum robot.  ===  WRITE YOUR MODEL HERE  ===
;
; A robot must visit all rooms and clean them. Fill in the predicates,
; the move action, and the clean action so a planner can find a plan that
; makes every room clean.
;
; Objects you will declare in problem.pddl: one robot, rooms pokoj1..pokoj3.
;
; Suggested predicates (from the assignment):
;   (at ?r - robot ?p - room)   ; the robot is in a room
;   (dirty ?p - room)           ; the room is dirty
;   (clean ?p - room)           ; the room is clean
;
; Suggested actions:
;   move   — move the robot between two rooms
;   clean  — clean the room the robot is currently in
;
; Tip: test it at https://editor.planning.domains before pushing.

(define (domain vacuum-robot)
  (:requirements :strips :typing)
  (:types robot room)

  (:predicates
    (at        ?r - robot ?p - room)    ; the robot is in a room
    (dirty     ?p - room)               ; the room is dirty
    (clean     ?p - room)               ; the room is clean
    (connected ?from - room ?to - room) ; adjacency between rooms
  )

  ; Move the robot from one room to an adjacent room
  (:action move
    :parameters (?r - robot ?from - room ?to - room)
    :precondition (and
      (at ?r ?from)
      (connected ?from ?to)
    )
    :effect (and
      (at ?r ?to)
      (not (at ?r ?from))
    )
  )

  ; Clean the room the robot is currently in (must be dirty)
  (:action clean
    :parameters (?r - robot ?p - room)
    :precondition (and
      (at    ?r ?p)
      (dirty ?p)
    )
    :effect (and
      (clean ?p)
      (not (dirty ?p))
    )
  )
)
