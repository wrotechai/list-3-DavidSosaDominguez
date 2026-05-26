; Task 1 — Package transport.  ===  WRITE YOUR MODEL HERE  ===
;
; Design a logical model for transporting packages between locations using
; vehicles, then run a planner and analyse the plan (length, cost, the effect
; of the transport topology).
;
; Minimum: a :strips :typing model where packages are LOADED onto vehicles,
; vehicles MOVE between locations, and packages are UNLOADED at the destination.
; The autograder checks that the model is typed and that the plan carries
; packages with vehicles (it must use several distinct actions, e.g.
; load / move / unload — packages may not "teleport").
;
; Optional extensions you may use (graded in the report / by the teacher):
;   :negative-preconditions   negative conditions, e.g. (not (at ?p ?l))
;   :conditional-effects      optional conditional effects
;   :action-costs / :numeric-fluents   action costs and a (:metric ...)
;   :durative-actions         action durations
;   multiple transport modes  road / air / water with different vehicles
;
; NOTE: pyperplan (used in CI) supports :strips, :typing and
; :negative-preconditions. If you add :action-costs / :durative-actions /
; :numeric-fluents, make sure the model also solves with Fast Downward —
; the autograder falls back to it. Test at https://editor.planning.domains.

(define (domain package-transport)
  (:requirements :strips :typing)

  (:types
    location  - object   ; generic location (super-type)
    road-loc  - location ; reachable by truck
    airport   - location ; reachable by plane
    port-loc  - location ; reachable by ship
    vehicle   - object
    package   - object
  )

  (:predicates
    (at          ?p - package ?l - location)           ; package is at location
    (in          ?p - package ?v - vehicle)            ; package is loaded on vehicle
    (vehicle-at  ?v - vehicle ?l - location)           ; vehicle is at location
    (road-connected ?from - road-loc ?to - road-loc)   ; road link
    (air-connected  ?from - airport  ?to - airport)    ; air link
    (sea-connected  ?from - port-loc ?to - port-loc)   ; sea link
  )

  ; ── LOAD: put a package onto a vehicle (both at the same location) ──
  (:action load
    :parameters (?p - package ?v - vehicle ?l - location)
    :precondition (and
      (at         ?p ?l)
      (vehicle-at ?v ?l)
    )
    :effect (and
      (in  ?p ?v)
      (not (at ?p ?l))
    )
  )

  ; ── UNLOAD: take a package off a vehicle at the current location ──
  (:action unload
    :parameters (?p - package ?v - vehicle ?l - location)
    :precondition (and
      (in         ?p ?v)
      (vehicle-at ?v ?l)
    )
    :effect (and
      (at  ?p ?l)
      (not (in ?p ?v))
    )
  )

  ; ── DRIVE: truck moves along a road connection ──
  (:action drive
    :parameters (?v - vehicle ?from - road-loc ?to - road-loc)
    :precondition (and
      (vehicle-at     ?v ?from)
      (road-connected ?from ?to)
    )
    :effect (and
      (vehicle-at     ?v ?to)
      (not (vehicle-at ?v ?from))
    )
  )

  ; ── FLY: plane moves along an air connection ──
  (:action fly
    :parameters (?v - vehicle ?from - airport ?to - airport)
    :precondition (and
      (vehicle-at    ?v ?from)
      (air-connected ?from ?to)
    )
    :effect (and
      (vehicle-at    ?v ?to)
      (not (vehicle-at ?v ?from))
    )
  )

  ; ── SAIL: ship moves along a sea connection ──
  (:action sail
    :parameters (?v - vehicle ?from - port-loc ?to - port-loc)
    :precondition (and
      (vehicle-at    ?v ?from)
      (sea-connected ?from ?to)
    )
    :effect (and
      (vehicle-at    ?v ?to)
      (not (vehicle-at ?v ?from))
    )
  )
)
