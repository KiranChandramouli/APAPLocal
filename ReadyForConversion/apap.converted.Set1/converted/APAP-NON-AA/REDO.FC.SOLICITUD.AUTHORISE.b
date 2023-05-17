SUBROUTINE REDO.FC.SOLICITUD.AUTHORISE
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.FC.SOLICITUD

*** <region name= MAIN PROCESS LOGIC>
*** <desc>Main process logic</desc>
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*** </region>


*** <region name= PROCESS>
*** <desc>Process</desc>
PROCESS:
    IF R.OLD(FC.SL.ESTATUS) NE R.NEW(FC.SL.ESTATUS) THEN
        BEGIN CASE
            CASE R.NEW(FC.SL.ESTATUS) EQ "REFERIDA"
                R.NEW(FC.SL.FEC.SOLICITA) = TODAY
            CASE R.NEW(FC.SL.ESTATUS) EQ "PREAPROBADA"
                R.NEW(FC.SL.FEC.PREAPROB) = TODAY
            CASE R.NEW(FC.SL.ESTATUS) EQ "FORMALIZADA"
                R.NEW(FC.SL.FEC.FRMNEG) = TODAY
            CASE R.NEW(FC.SL.ESTATUS) EQ "APROBADA"
                R.NEW(FC.SL.FEC.APROBADO) = TODAY
        END CASE
    END

    GOSUB CONCAT.FILE.LISTENER
RETURN
*** </region>

*** <region name= INITIALISE>
*** <desc>Initialise</desc>
INITIALISE:
* Concat file
    FN.REDO.FC.CUST.SOLICITUD = 'F.REDO.FC.CUST.SOLICITUD'
* ID Cliente
    Y.CUST.ID = R.NEW(FC.SL.CUSTOMER)
    Y.SOL.ID = ID.NEW

RETURN
*** </region>

*** <region name= CONCAT.FILE.LISTENER>
*** <desc>Concat File Listener</desc>
CONCAT.FILE.LISTENER:
    CALL CONCAT.FILE.UPDATE(FN.REDO.FC.CUST.SOLICITUD,Y.CUST.ID,Y.SOL.ID,'I','AR')
RETURN
*** </region>

END
