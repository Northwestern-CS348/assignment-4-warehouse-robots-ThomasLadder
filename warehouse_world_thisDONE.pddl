(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

       (:action robotMove
      :parameters (?r - robot ?a - location ?b - location)
      :precondition (and (connected ?a ?b) (at ?r ?a) (not (no-robot ?a)))
      :effect (and (at ?r ?b) (not (at ?r ?a)) (no-robot ?a) (not (no-robot ?b))) 
    )

    (:action robotMoveWithPallette
      :parameters (?r - robot ?a - location ?b - location ?p - pallette)
      :precondition (and (connected ?a ?b) (at ?r ?a) (not (no-robot ?a)) (at ?p ?a) (not (no-pallette ?a)) (no-pallette ?b))
      :effect (and (at ?r ?b) (not (at ?r ?a)) (no-robot ?a) (not (no-robot ?b)) (at ?p ?b) (not (at ?p ?a?)) (no-pallette ?a) (not (no-pallette ?b)) )
    )
    
    (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (packing-location ?l) (at ?p ?l) (available ?l) (contains ?p ?si) (orders ?o ?si) (not (no-pallette ?l)))
      :effect (and (includes ?s ?si) (not (contains ?p ?si)))
    )

    (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)) (ships ?s ?o))
      :effect (and (complete ?s) (available ?l) (not (packing-at ?s ?l))) 
    )

)
