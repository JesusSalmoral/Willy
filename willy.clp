; -=-=-=-=-=-=-=-= HECHOS INICIALES -=-=-=-=-=-=-=-=-=-=

(deffacts estadoInicial "Estado inicial del sistema"
    (hice nada) ; Hecho para la última acción que realizó Willy
    (nMovimientos 0) ; Número de pasos que ha dado Willy
    (Willy-position 0 0)
)

; -=-=-=-=-=-=-=-= PLANTILLAS -=-=-=-=-=-=-=-=-=-=

(deftemplate visited
    (slot x)
    (slot y)
)

; -=-=-=-=-=-=-=-= REGLAS -=-=-=-=-=-=-=-=-=-=

(defrule moveWilly
   (directions $? ?direction $?)
   ?m <- (nMovimientos ?n)
   ?h <- (hice $?)
   =>
   (retract ?m ?h)
   (assert (hice ?direction))
   (moveWilly ?direction)
   (assert (nMovimientos (+ ?n 1))) ; Incrementar el número de pasos
)

(defrule moverWilly "Mueve a willy en una dirección elegida al azar, siempre que no haya amenazas actualmente"
    (directions $? ?direction $?)
    ?h <- (hice $?)
    ?m <- (nMovimientos ?c)
    (percepts) ; No se detecta ningún peligro
    (test (< ?c 1000)) ; No se ha alcanzado el número máximo de pasos
    =>
    (retract ?h)
    (retract ?m)
    (assert (hice ?direction)) ; Apuntar el movimiento que se hizo para que se puede volver a él si hay un peligro
    (assert (nMovimientos (+ ?c 1))) ; Incrementar el número de pasos
    (assert (moveWilly ?direction))
)

(defrule moverYRezarWilly "Mover a willy en una dirección aleatoria, en caso de detectar peligro y no tener apuntado el último movimiento"
    (directions $? ?direction $?)
    ?h <- (hice nada)
    ?m <- (nMovimientos ?c)
    (or(percepts Pull) (percepts Noise)) ; Se detecta algún peligro
    (test(< ?c 1000)) ; No se ha alcanzado el número máximo de pasos
        =>
    (retract ?h)
    (retract ?m)
    (assert (hice ?direction)) ; Apuntar el movimiento que se hizo para que se puede volver a él si hay un peligro
    (assert (nMovimientos (+ ?c 1))) ; Incrementar el número de pasos
    (moveWilly ?direction)
)

(defrule volverNorthWilly "Retroceder cuando el movimiento realizado previamente fue al norte"
    (declare (salience 10))
    (directions $? south $?)
    ?h <- (hice north) ; Condición para que esta regla se ejecute sólo para volver de un movimiento hacia arriba
    ?m <- (nMovimientos ?n) 
    (or (percepts Pull) (percepts Noise)) ; Se detecta algún peligro
    (test (< ?n 1000)) ; No se ha alcanzado el número máximo de pasos
         =>
    (retract ?h ?m)
    (assert (hice nada)); No hace falta apuntar lo que se hizo
    (assert (nMovimientos (+ ?n 1))) ; Incrementar el número de pasos
    (moveWilly south); Mover a willy en la dirección contraria
)

(defrule volverSouthWilly "Retroceder cuando el movimiento realizado previamente fue al sur"
    (declare (salience 10))
    (directions $? north $?)
    ?h <- (hice south) ; Condición para que esta regla se ejecute sólo para volver de un movimiento hacia abajo
    ?m <- (nMovimientos ?n)
    (or (percepts Pull) (percepts Noise)) ; Se detecta algún peligro
    (test (< ?n 1000)) ; No se ha alcanzado el número máximo de pasos
    =>
    (retract ?h ?m)
    (assert (hice nada)); No hace falta apuntar lo que se hizo
    (moveWilly north) ; Mover a willy en la dirección contraria
    (assert (nMovimientos (+ ?n 1))) ; Incrementar el número de pasos
)

(defrule volverWestWilly "Retroceder cuando el movimiento realizado previamente fue al oeste"
    (declare (salience 10))
    (directions $? east $?) 
    ?h<-(hice west) ; Condición para que esta regla se ejecute sólo para volver de un movimiento hacia la izquierda
    ?m <- (nMovimientos ?n)
    (or (percepts Pull) (percepts Noise)) ; Se detecta algún peligro
    (test (< ?n 1000)) ; No se ha alcanzado el número máximo de pasos
        =>
    (retract ?h ?m)
    (assert (hice east)); No hace falta apuntar lo que se hizo
    (moveWilly east) ; Mover a willy en la dirección contraria
    (assert (nMovimientos (+ ?n 1))) ; Incrementar el número de pasos
)

(defrule volverEastWilly "Retroceder cuando el movimiento realizado previamente fue al este"
    (declare (salience 10))
    (directions $? west $?)
    ?h <- (hice east) ; Condición para que esta regla se ejecute sólo para volver de un movimiento hacia la derecha
    ?m <- (nMovimientos ?n)
    (or (percepts Pull) (percepts Noise)) ; Se detecta algún peligro
    (test (< ?n 1000)) ; No se ha alcanzado el número máximo de pasos
        =>
    (retract ?h ?m)
    (assert (hice nada)); No hace falta apuntar lo que se hizo
    (moveWilly west) ; Mover a willy en la dirección contraria
    (assert (nMovimientos (+ ?n 1))) ; Incrementar el número de pasos
)

(defrule fireWilly "En caso de percibir algún sonido, dispara en una dirección aleatoria"
    (declare (salience 20))
    (hasLaser)
    (percepts $? Noise $?)
    (hice ?direction)
    =>
    (fireLaser ?direction)
)