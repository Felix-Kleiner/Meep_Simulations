(set! geometry-lattice (make lattice (size 100 20 no-size)))
(set! geometry (list
;------make waveguide-----
(make block (center 25 0 0)(size 50 0.4 infinity)
(material (make dielectric (epsilon 12))))
;-------make taper----(block + 2 triangles for inverse taper)
(make block (center -20 0 0)(size 40 0.1 infinity)
(material (make dielectric (epsilon 12))))
(make block (center -10.0000 0.1500 2.5000)
                (size 5.0002 5.0040 20.6156)
                (e1 0.0000 0.0500 5.0000)
                (e2 0.0000 0.2000 5.0000)
                (e3 -20.0000 0.0500 5.0000)
                (material (make dielectric (epsilon 12))))
		(make block (center -10.0000 -0.1500 2.5000)
                (size 5.0002 5.0040 20.6156)
                (e1 0.0000 -0.0500 5.0000)
                (e2 0.0000 -0.2000 5.0000)
                (e3 -20.0000 -0.0500 5.0000)
                (material (make dielectric (epsilon 12))))))
				
(define-param fcen 0.64516129)
(define-param df 0.1)
(define-param nfreq 100)
(define-param sx 4)
(define-param dpml 1)
(define-param w 0.4)

(set! sources (list
               (make source
                 (src (make gaussian-src (frequency fcen) (fwidth df)))
                 (component Ey)
                 (center -44 0)
                 (size 0 w))))
				 
(set! pml-layers (list (make pml (thickness dpml))))
(set! resolution 10)

(define trans ;transmitted flux                                          
        (add-flux fcen df nfreq
                  (make flux-region
                    (center (- (* -0.5 sx) dpml 1) 0) (size 0 (* w 2)))))

					
(run-sources+ (stop-when-fields-decayed
               50 Ey
               (vector3 (- (* -0.5 sx) dpml 1) 0)
               1e-3)
              (at-beginning output-epsilon)
              (during-sources
               (in-volume (volume (center 0 0) (size 100 0))
                (to-appended "hz-slice" (at-every 0.4 output-hfield-z)))))
(display-fluxes trans) ; print out the flux spectrum
