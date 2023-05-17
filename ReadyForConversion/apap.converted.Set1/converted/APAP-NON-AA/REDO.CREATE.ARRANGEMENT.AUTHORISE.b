SUBROUTINE REDO.CREATE.ARRANGEMENT.AUTHORISE
*-------------------------------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino
* Date         : 15.06.2011
* Description  : Authorization routine for APAP Fabrica de Credito
*                intented to register de information in the following apps:
*                - LIMIT
*                - COLLATERAL.RIGHT
*                - COLLATERAL
*                - INSURANCE
*                - AA
*-------------------------------------------------------------------------------------------------
* Modification History:
*
* Version   Date            Who               Reference      Description
* 2.0       2011-06-15      lpazmino          CR.180         Complete Refactoring
* 3.0       2011-09-09      jarmas            CR.180         Amends
*-------------------------------------------------------------------------------------------------
* Input/Output: NA
* Dependencies: NA
*-------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CREATE.ARRANGEMENT


    GOSUB INIT
    GOSUB PROCESS.MESSAGE

RETURN

*----------
INIT:
*----------
    Y.RESULT = ''

RETURN
*----------------
PROCESS.MESSAGE:
*----------------
* JP20110909
* Si este prestamo ya tiene un estatus, es decir ya fue authorizado
* por lo tanto ya no debe crear los registros en Limit, Coll, Polizas, & AA

    IF R.NEW(REDO.FC.STATUS.TEMPLATE) EQ "INPROGESS" OR R.NEW(REDO.FC.STATUS.TEMPLATE) EQ "OK" THEN
        RETURN
    END

    IF MESSAGE EQ 'AUT'  THEN   ;* Only during commit
        BEGIN CASE
            CASE V$FUNCTION EQ 'I'
                GOSUB PROCESS.INPUT.AUT
            CASE V$FUNCTION EQ 'R'
* Aqui va la llamada a la funcion q reversa los registros creados anteriormente
* Polizas, Coll.rigth, Coll y Limit
                CALL REDO.FC.S.REV.AA
        END CASE
    END
*
RETURN
*--------------------
PROCESS.INPUT.AUT:
*--------------------

* Llamadas dinamicas de las rutinas
    CALL REDO.FC.S.AUTHORISE(Y.RESULT)

    IF Y.RESULT EQ 'OK' THEN
        R.NEW(REDO.FC.STATUS.TEMPLATE) = 'INPROGRESS'
    END

    IF Y.RESULT EQ 'FAIL' THEN
        R.NEW(REDO.FC.STATUS.TEMPLATE) = 'FAIL'
    END

RETURN

END
