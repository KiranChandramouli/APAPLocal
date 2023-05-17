SUBROUTINE REDO.VIN.MTS.RESTART
*----------------------------------------------------------------------------------------------------------------------
*
*    - Gets the information related to the AA specified in input parameter
*
*    - Generates BULK OFS MESSAGES to apply payments to corresponding AA
*
*----------------------------------------------------------------------------------------------------------------------
* Modification History:
*=====================
* Date          Who                  Reference         Description
* ------        -----                -------------     -------------
* 29/04/2011    pgarzongavilanes                       Initial Creation
* 25/07/2013    Vignesh Kumaar MR    PACS00309053      CHANGE IN THEIR.REFERENCE EB-RTC.STATUS.&.NOT.CORRECT-:&
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.ID
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_System
*
*----------------------------------------------------------------------------------------------------------------------
*

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN
*
* ======
PROCESS:
* ======

    CALL F.READ(FN.TID, Y.TID.ID, R.TID, F.TID, Y.ERR.TID)
*** TELLER.ID LOCAL FIELDS VALUES
    Y.TID.CCY = R.TID<TT.TID.LOCAL.REF,WPOSCCY>
    Y.TID.CASH = R.TID<TT.TID.LOCAL.REF,WPOSCASH>
    Y.TID.CHECK = R.TID<TT.TID.LOCAL.REF,WPOSCHECK>
    Y.TID.TRAN.ID = R.TID<TT.TID.LOCAL.REF,WPOSLI>

    IF Y.TYPE EQ '' THEN
        Y.ERR.MSG = "EB-NOT.TYPE.OF.TRANSACTION"
        GOSUB CONTROL.MSG.ERROR
    END


    CALL F.READ(FN.RTC, Y.RTC.ID, R.RTC, F.RTC, Y.ERR.RTC)
    Y.RTC.STATUS = R.RTC<RTC.TRANS.AUTH>


    IF Y.RTC.STATUS EQ 'S' OR Y.RTC.STATUS EQ 'SR' THEN
*CRT "ESTADO CORRECTO"
    END
    ELSE

* Fix for PACS00309053 [CHANGE IN THEIR.REFERENCE EB-RTC.STATUS.&.NOT.CORRECT-:&]

*        Y.ERR.MSG = "EB-RTC.STATUS.&.NOT.CORRECT-:&" : FM : Y.RTC.STATUS
        Y.ERR.MSG = "ESTATUS NO ES CORRECTO-:&":Y.RTC.STATUS
        AF = TT.TE.OUR.REFERENCE

* End of Fix

        GOSUB CONTROL.MSG.ERROR
    END

    LOCATE Y.TT.CCY IN Y.TID.CCY<1> SETTING POS THEN

        IF Y.TYPE EQ "C" THEN
            GOSUB VALIDATE.CHECK
        END

        IF Y.TYPE EQ "E" THEN
            GOSUB VALIDATE.CASH
        END

    END
*    CRT "FIN RUTINA INPUT"
*
RETURN

*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
*   Paragraph that control the error in the subroutine
*

    IF Y.ERR.MSG THEN
        ETEXT           = Y.ERR.MSG
        CALL STORE.END.ERROR
        ETEXT           = ""
    END
*
RETURN

*
* =========
VALIDATE.CHECK:
* =========
*

    W.CHECK.INFO = SUM(R.RTC<RTC.CHECK.INFO>)

    IF W.CHECK.INFO EQ 0 OR R.RTC<RTC.CHECK.INFO> EQ '' THEN
        Y.ERR.MSG = "EB-NOT.CHEQUE.BALANCE"
        AF = TT.TE.OUR.REFERENCE  ;* Fix for PACS00309053
        GOSUB CONTROL.MSG.ERROR
    END

    IF R.RTC<RTC.TRANS.AUTH> EQ "S" AND Y.TID.CHECK<POS> NE 0 AND Y.TID.CHECK<POS> NE '' THEN
        Y.ERR.MSG = "EB-CHECK.BALANCE.AVAILABLE:&" : @FM : Y.TID.CHECK<POS>
        AF = TT.TE.TELLER.ID.1
        GOSUB CONTROL.MSG.ERROR
    END

RETURN


*
* =========
VALIDATE.CASH:
* =========
*
    W.CASH.INFO = SUM(R.RTC<RTC.CASH.INFO>)

    IF W.CASH.INFO EQ 0 OR R.RTC<RTC.CASH.INFO> EQ '' THEN
        Y.ERR.MSG = "EB-NOT.CASH.BALANCE"
        AF = TT.TE.OUR.REFERENCE  ;* Fix for PACS00309053
        GOSUB CONTROL.MSG.ERROR
    END

    IF R.RTC<RTC.TRANS.AUTH> EQ "S" AND Y.TID.CASH<POS> NE 0 AND Y.TID.CASH<POS> NE '' THEN
        Y.ERR.MSG = "EB-CASH.BALANCE.AVAILABLE:&" : @FM : Y.TID.CASH<POS>
        AF = TT.TE.TELLER.ID.1
        GOSUB CONTROL.MSG.ERROR

    END


RETURN

*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.RTC, F.RTC)
    CALL OPF(FN.TID, F.TID)

RETURN

*
* =========
INITIALISE:
* =========
*
    FN.RTC = 'F.REDO.TRANSACTION.CHAIN'
    F.RTC = ''
    Y.RTC.ID = R.NEW(TT.TE.OUR.REFERENCE) ;* Fix for PACS00309053 **TRANSACCION A REINICIAR
    R.RTC = ''
    Y.ERR.RTC = ''

    FN.TID = 'F.TELLER.ID'
    F.TID = ''
    Y.TID.ID = R.NEW(TT.TE.TELLER.ID.1)   ;**CAJERO
    R.TID = ''
    Y.ERR.TID = ''


*** READ TELLER.ID -> CCY, CASH, CHECK
    WCAMPO    = "L.INITIAL.ID"
    WCAMPO<2> = "L.CH.CASH"
    WCAMPO<3> = "L.CH.CHECK"
    WCAMPO<4> = "L.CH.CCY"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    YPOS = ''
    CALL MULTI.GET.LOC.REF("TELLER.ID",WCAMPO,YPOS)
    WPOSLI    = YPOS<1,1>
    WPOSCASH  = YPOS<1,2>
    WPOSCHECK = YPOS<1,3>
    WPOSCCY   = YPOS<1,4>

    Y.TT.CCY = R.NEW(TT.TE.CURRENCY.1)
    Y.TT.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
    Y.TYPE   = System.getVariable("CURRENT.TYPE")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.TYPE = ""
    END
;*** E:EFECTIVO , C:CHEQUE

***Y.TYPE = "E"

    LOOP.CNT = 1
    MAX.LOOPS = 1
    PROCESS.GOAHEAD = 1

RETURN

*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1

        END CASE

        LOOP.CNT +=1
    REPEAT
*

RETURN
*

END
