* @ValidationCode : MjotMjA3NTM3MDYyNTpDcDEyNTI6MTY4MTE4OTk5NjAyODpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 10:43:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VIN.MTS.SUSPEND
*
* ====================================================================================
*
*    - Gets the information related to the AA specified in input parameter
*
*    - Generates BULK OFS MESSAGES to apply payments to corresponding AA
*
* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :
*
*
* Incoming:
* ---------
*
*
*
* Outgoing:

* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : pgarzongavilanes
* Date            : 2011-04-21
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM, New condition added
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.ID
*
*************************************************************************
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
*
    LOCATE Y.TT.CCY IN Y.TID.CCY<1> SETTING POS THEN
        IF Y.TYPE EQ "C" THEN
            IF ABS(Y.TID.CHECK<POS>) NE Y.TT.AMT THEN
                Y.ERR.MSG = "EB-DIFFERENT.BALANCE:&":@FM:Y.TID.CHECK<POS>
                AF = TT.TE.AMOUNT.LOCAL.1
            END
            IF (Y.DR.CR EQ "DEBIT" AND Y.TID.CHECK<POS> GE 0) OR (Y.DR.CR EQ "CREDIT" AND Y.TID.CHECK<POS> LE 0) THEN
                Y.ERR.MSG = "EB-TRANS.&.DOES.NOT.CORRESPOND:&":@FM:Y.TR.CODE:@VM:Y.TID.CHECK<POS>
                AF = TT.TE.AMOUNT.LOCAL.1
            END
        END

        IF Y.TYPE EQ "E" THEN
            IF ABS(Y.TID.CASH<POS>) NE Y.TT.AMT THEN
                Y.ERR.MSG = "EB-DIFFERENT.BALANCE:&":@FM:Y.TID.CASH<POS>
                AF = TT.TE.AMOUNT.LOCAL.1
            END
            IF (Y.DR.CR EQ "DEBIT" AND Y.TID.CASH<POS> GE 0) OR (Y.DR.CR EQ "CREDIT" AND Y.TID.CASH<POS> LE 0) THEN
                Y.ERR.MSG = "EB-TRANS.&.DOES.NOT.CORRESPOND:&":@FM:Y.TR.CODE:@VM:Y.TID.CHECK<POS>
                AF = TT.TE.AMOUNT.LOCAL.1
            END

        END
    END

    GOSUB CONTROL.MSG.ERROR

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

*
* =========
OPEN.FILES:
* =========
*

    CALL OPF(FN.TID, F.TID)

RETURN


*
* =========
INITIALISE:
* =========
*
    FN.TID    = 'F.TELLER.ID'
    F.TID     = ''
    Y.TID.ID  = R.NEW(TT.TE.TELLER.ID.1)  ;**CAJERO
    R.TID     = ''
    Y.ERR.TID = ''

    Y.TR.CODE = R.NEW(TT.TE.TRANSACTION.CODE)
    Y.DR.CR   = R.NEW(TT.TE.DR.CR.MARKER)
    Y.TT.CCY  = R.NEW(TT.TE.CURRENCY.1)
    Y.TT.AMT  = R.NEW(TT.TE.AMOUNT.LOCAL.1)
    Y.TYPE    = System.getVariable("CURRENT.TYPE")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN            ;** R22 Auto Conversion - Start
        Y.TYPE = ""
    END                                        ;** R22 Auto Conversion - End
;*** E:EFECTIVO , C:CHEQUE

    Y.ERR.MSG = ''

*** READ TELLER.ID -> CCY, CASH, CHECK
    WCAMPO    = "L.INITIAL.ID"
    WCAMPO<2> = "L.CH.CASH"
    WCAMPO<3> = "L.CH.CHECK"
    WCAMPO<4> = "L.CH.CCY"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)

    CALL MULTI.GET.LOC.REF("TELLER.ID",WCAMPO,YPOS)
    WPOSLI    = YPOS<1,1>
    WPOSCASH  = YPOS<1,2>
    WPOSCHECK = YPOS<1,3>
    WPOSCCY   = YPOS<1,4>


    LOOP.CNT = 1
    MAX.LOOPS = 1

RETURN

*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    PROCESS.GOAHEAD = 1
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
***CAMPOS DE TELLER.ID

                CALL F.READ(FN.TID, Y.TID.ID, R.TID, F.TID, Y.ERR.TID)

                Y.TID.CCY     = R.TID<TT.TID.LOCAL.REF,WPOSCCY>
                Y.TID.CASH    = R.TID<TT.TID.LOCAL.REF,WPOSCASH>
                Y.TID.CHECK   = R.TID<TT.TID.LOCAL.REF,WPOSCHECK>
                Y.TID.TRAN.ID = R.TID<TT.TID.LOCAL.REF,WPOSLI>


        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*

END
