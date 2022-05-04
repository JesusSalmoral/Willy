(deffacts estadoInicial "Estado inicial del sistema"
    (hice nada) ; Hecho para la última acción que realizó Willy
    (nMovimientos 0) ; Número de pasos que ha dado Willy
)

(defrule moverWilly "Mueve a willy en una dirección elegida al azar, siempre que no haya amenazas actualmente"
    (directions $? ?direction $?)
    ?h <- (hice $?)
    (not(or(percepts Pull) (percepts Noise) (percepts Noise Pull))) ; No se detecta ningún peligro
    (< nMovimientos 1000) ; No se ha alcanzado el número máximo de pasos
    =>
    (retract ?h)
    (hice ?h) ; Apuntar el movimiento que se hizo para que se puede volver a él si hay un peligro
    (+ nMovimientos 1) ; Incrementar el número de pasos
    (moveWilly ?direction)
)

(defrule moverYRezarWilly "Mover a willy en una dirección aleatoria, en caso de detectar peligro y no tener apuntado el último movimiento"
    (directions $? ?direction $?)
    ?h <- (hice nada)
    (or(percepts Pull) (percepts Noise) (percepts Noise Pull)) ; Se detecta algún peligro
    (< nMovimientos 1000) ; No se ha alcanzado el número máximo de pasos
        =>
    (retract ?h)
    (hice ?h) ; Apuntar el movimiento que se hizo para que se puede volver a él si hay un peligro
    (+ nMovimientos 1) ; Incrementar el número de pasos
    (moveWilly ?direction)
)

(defrule volverNorthWilly "Retroceder cuando el movimiento realizado previamente fue al norte"
    (directions $? south $?)
    ?h <- (hice north) ; Condición para que esta regla se ejecute sólo para volver de un movimiento hacia arriba
    (or(percepts Pull) (percepts Noise) (percepts Noise Pull)) ; Se detecta algún peligro
    (< nMovimientos 1000) ; No se ha alcanzado el número máximo de pasos
        =>
    (retract ?h) 
    ; No hace falta apuntar lo que se hizo
    (+ nMovimientos 1) ; Incrementar el número de pasos
    (moveWilly south); Mover a willy en la dirección contraria
)

(defrule volverSouthWilly "Retroceder cuando el movimiento realizado previamente fue al sur"
    (directions $? north $?)
    ?h <- (hice south) ; Condición para que esta regla se ejecute sólo para volver de un movimiento hacia abajo
    (or(percepts Pull) (percepts Noise) (percepts Noise Pull)) ; Se detecta algún peligro
    (< nMovimientos 1000) ; No se ha alcanzado el número máximo de pasos
    =>
    (retract ?h)
    ; No hace falta apuntar lo que se hizo
    (moveWilly north) ; Mover a willy en la dirección contraria
    (+ nMovimientos 1) ; Incrementar el número de pasos
)

(defrule volverWestWilly "Retroceder cuando el movimiento realizado previamente fue al oeste"
    (directions $? east $?) 
    ?h<-(-------) ; Condición para que esta regla se ejecute sólo para volver de un movimiento hacia la izquierda
    (-------) ; Se detecta algún peligro
    (-------) ; No se ha alcanzado el número máximo de pasos
        =>
    (retract ?h)
    ; No hace falta apuntar lo que se hizo
    (-------) ; Mover a willy en la dirección contraria
    (-------) ; Incrementar el número de pasos
)

(defrule volverEastWilly "Retroceder cuando el movimiento realizado previamente fue al este"
    (directions $? west $?)
    ?h <- (-------) ; Condición para que esta regla se ejecute sólo para volver de un movimiento hacia la derecha
    (-------) ; Se detecta algún peligro
    (-------) ; No se ha alcanzado el número máximo de pasos
        =>
    (retract ?h)
    ; No hace falta apuntar lo que se hizo
    (-------) ; Mover a willy en la dirección contraria
    (-------) ; Incrementar el número de pasos
)

(defrule fireWilly "En caso de percibir algún sonido, dispara en una dirección aleatoria"
    (hasLaser)
    (percepts $? Noise $?)
    (directions $? ?direction $?)
    =>
    (fireLaser ?direction)
)