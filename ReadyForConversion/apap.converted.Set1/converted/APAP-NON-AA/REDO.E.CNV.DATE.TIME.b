SUBROUTINE REDO.E.CNV.DATE.TIME
***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : GANESH
* PROGRAM NAME : REDO.E.CNV.DATE.TIME
*----------------------------------------------------------


* DESCRIPTION : This is conversion routine which is attache
*               to CURR.NO to fetch the DATE.TIME of 40 statuses
*
*
*------------------------------------------------------------

*    LINKED WITH :
*    IN PARAMETER: NONE
*    OUT PARAMETER: NONE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*07.09.2010      GANESH            ODR-2010-08-0179        INITIAL CREATION
*----------------------------------------------------------------------


*-------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.H.SOLICITUD.CK


    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*-------------------------------------------------------------
INIT:
*Initialising
*-------------------------------------------------------------
    VAR.CURR.NO = O.DATA
    VAR.ID = ID
    VAR.DATE.TIME = ''
RETURN

*-------------------------------------------------------------
OPENFILES:
*Opening File

    FN.REDO.H.SOLICITUD.CK = 'F.REDO.H.SOLICITUD.CK$HIS'
    F.REDO.H.SOLICITUD.CK = ''
    CALL OPF(FN.REDO.H.SOLICITUD.CK,F.REDO.H.SOLICITUD.CK)

RETURN
*-------------------------------------------------------------
PROCESS:

*Fetch the DATE.TIME of 40 statuses
    VAR.PREV.CURR = VAR.CURR.NO - 1
    LOOP
    WHILE VAR.PREV.CURR GT 0
*Formatting the ID to read teh History record

        VAL.REC.ID = VAR.ID:';':VAR.PREV.CURR

*Reading the History record with ID formed
        CALL F.READ(FN.REDO.H.SOLICITUD.CK,VAL.REC.ID,R.REDO.H.SOLICITUD.CK,F.REDO.H.SOLICITUD.CK,ERR.SOLICITUD)
        VAR.REC.STATUS = R.REDO.H.SOLICITUD.CK<REDO.H.SOL.CHEQUE.STATUS>

*Checking for the Status if Equal to 40
        IF VAR.REC.STATUS EQ 40 THEN
            VAR.DATE.TIME = R.REDO.H.SOLICITUD.CK<REDO.H.SOL.DATE.TIME>
        END
        VAR.PREV.CURR -= 1
    REPEAT
    O.DATA = VAR.DATE.TIME
RETURN
END
