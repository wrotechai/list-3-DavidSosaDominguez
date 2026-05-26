; Task 1 — Package transport problem.  ===  WRITE YOUR PROBLEM HERE  ===
;
; Declare your locations, vehicles and packages, the initial state, and a goal
; that requires every package to reach its destination. Design the topology
; (which locations are connected, by which transport mode) so you can analyse
; its effect on the plan.

(define (problem deliver-packages)
  (:domain package-transport)

  (:objects
    ; Road locations (truck network)
    warsaw   lodz   wroclaw        - road-loc
    ; Airports (plane network)
    warsaw-airport  krakow-airport - airport
    ; Ports (ship network)
    gdansk-port  szczecin-port     - port-loc

    ; Vehicles
    truck1  - vehicle   ; road
    plane1  - vehicle   ; air
    ship1   - vehicle   ; sea

    ; Packages
    pkg1  pkg2  pkg3   - package
  )

  (:init
    ; ── initial total cost ──────────────────────────────────────────
    (= (total-cost) 0)

    ; ── road costs (truck, bidirectional) ───────────────────────────
    ;   warsaw ── lodz (3)  ── wroclaw (4 more = 7 total)
    (= (move-cost warsaw  lodz)     3)
    (= (move-cost lodz    warsaw)   3)
    (= (move-cost lodz    wroclaw)  4)
    (= (move-cost wroclaw lodz)     4)

    ; ── air costs (plane, bidirectional) ────────────────────────────
    (= (move-cost warsaw-airport  krakow-airport) 2)
    (= (move-cost krakow-airport  warsaw-airport) 2)

    ; ── sea costs (ship, bidirectional) ─────────────────────────────
    (= (move-cost gdansk-port   szczecin-port) 5)
    (= (move-cost szczecin-port gdansk-port)   5)

    ; ── road topology ───────────────────────────────────────────────
    ;   warsaw ── lodz ── wroclaw  (linear corridor)
    (road-connected warsaw  lodz)
    (road-connected lodz    warsaw)
    (road-connected lodz    wroclaw)
    (road-connected wroclaw lodz)

    ; ── air topology ────────────────────────────────────────────────
    (air-connected warsaw-airport  krakow-airport)
    (air-connected krakow-airport  warsaw-airport)

    ; ── sea topology ────────────────────────────────────────────────
    (sea-connected gdansk-port   szczecin-port)
    (sea-connected szczecin-port gdansk-port)

    ; ── vehicle starting positions ──────────────────────────────────
    (vehicle-at truck1 warsaw)
    (vehicle-at plane1 warsaw-airport)
    (vehicle-at ship1  gdansk-port)

    ; ── package starting positions ──────────────────────────────────
    (at pkg1 warsaw)         ; pkg1: warsaw  → wroclaw  (truck, 2 hops)
    (at pkg2 warsaw-airport) ; pkg2: warsaw-airport → krakow-airport (plane)
    (at pkg3 gdansk-port)    ; pkg3: gdansk-port → szczecin-port (ship)
  )

  (:goal
    (and
      (at pkg1 wroclaw)        ; truck delivered pkg1
      (at pkg2 krakow-airport) ; plane delivered pkg2
      (at pkg3 szczecin-port)  ; ship  delivered pkg3
    )
  )

  (:metric minimize (total-cost))
)
