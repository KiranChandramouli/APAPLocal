****Rutina de validacion para el proceso de reprecio manual
*** si la actividad es diferente de LENDING-CHANGE-PRINCIPALINT o LENDING-CHANGE-PENALTINT
*** entoces se genera una alerta de error
SUBROUTINE L.APAP.REP.PRIN.PEN
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY

    Y.ACTIVIDAD = R.NEW(AA.ARR.ACT.ACTIVITY)
    Y.ACTIVIDAD = TRIM(Y.ACTIVIDAD)
    IF Y.ACTIVIDAD NE '' THEN
        IF Y.ACTIVIDAD NE 'LENDING-CHANGE-PRINCIPALINT' THEN
            IF Y.ACTIVIDAD NE 'LENDING-CHANGE-PENALTINT' THEN
                AF = AA.ARR.ACT.ACTIVITY
                MENSAJE = "SOLO PUEDE UTILIZAR LAS ACTIVIDADES LENDING-CHANGE-PRINCIPALINT Y LENDING-CHANGE-PENALTINT"
                E = MENSAJE
                CALL ERR
                RETURN
            END
        END
    END

END
