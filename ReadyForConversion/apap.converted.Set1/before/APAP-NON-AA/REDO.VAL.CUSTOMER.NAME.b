*-----------------------------------------------------------------------------
* <Rating>-60</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.VAL.CUSTOMER.NAME
*--------------------------------------------------------------------------------------------------------------------------------
* DESCRIPTION :
* Note    : Passport number number validation will not be done against Padrones interface, user manually checks for non apap customers
*--------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Ganesh R
* PROGRAM NAME : REDO.INP.CUSTOMER.TYPE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------------------------------
* Date          Author             Reference      Description
* 07-07-2011    Riyas              CR014          Initial creation
* 11-10-2011    Shankar Raju       PACS00142987   Removing C$SPARE & Making CUSTOMER.NAME field as inputable field if
*                                                 Client is Non-APAP & using Passport.
* 09-Sep-2013   Vignesh Kumaar R   PACS00306447   CURRENT VARIABLE ISSUE [UPDATED PACK]
*-----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
*
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_REDO.ID.CARD.CHECK.COMMON
*
    FN.CUSTOMER.L.CU.PASS.NAT = 'F.CUSTOMER.L.CU.PASS.NAT'
    F.CUSTOMER.L.CU.PASS.NAT = ''
    CALL OPF(FN.CUSTOMER.L.CU.PASS.NAT,F.CUSTOMER.L.CU.PASS.NAT)

    GOSUB INIT

    IF OFS$OPERATION EQ 'PROCESS' THEN
        GET.CUSTOMER.NAME = R.NEW(REDO.CUS.PRF.CUSTOMER.NAME)

        IF NOT(GET.CUSTOMER.NAME) THEN
            ETEXT = 'EB-MAND.INP'
            CALL STORE.END.ERROR
        END
    END

    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
    RETURN
*
*---------------------------------------------------------------------------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------------------------------------------------------------------------
*
*  PASSPORT.CUST.ID   = "NA"

    IF OFS$HOT.FIELD EQ 'CUSTOMER.NAME' THEN
        CUSTOMER.FULL.NAME = COMI
    END ELSE
        CUSTOMER.FULL.NAME = R.NEW(REDO.CUS.PRF.CUSTOMER.NAME)
    END

*  PASSPORT.NUMBER    = R.NEW(REDO.CUS.PRF.IDENTITY.NUMBER)
    SELECT.ID = ""
    SELECT.NR = ""
    SELECT.ERR = ""
    R.CUSTOMER.L.CU.PASS.NAT = ""
    PASSPORT.NUMBER    = R.NEW(REDO.CUS.PRF.IDENTITY.NUMBER)
    SELECT.COMMAND = "SELECT ":FN.CUSTOMER.L.CU.PASS.NAT:" WITH @ID LIKE ":"'...":PASSPORT.NUMBER:"...'"
    CALL EB.READLIST(SELECT.COMMAND,SELECT.ID,'',SELECT.NR,SELECT.ERR)
    PASAPORTE.ID = SELECT.ID<1>
    CALL F.READ(FN.CUSTOMER.L.CU.PASS.NAT,PASAPORTE.ID,R.CUSTOMER.L.CU.PASS.NAT,F.CUSTOMER.L.CU.PASS.NAT,ERR.CUSTOMER.L.CU.PASS.NAT)
    IF R.CUSTOMER.L.CU.PASS.NAT THEN
        CHANGE '*' TO FM IN R.CUSTOMER.L.CU.PASS.NAT
        PASSPORT.CUST.ID = R.CUSTOMER.L.CU.PASS.NAT<2>
    END ELSE
        PASSPORT.CUST.ID   = "NA"
    END
    VAR.CUS.DETAILS    = "PASAPORTE*":PASSPORT.NUMBER:"*":CUSTOMER.FULL.NAME:"*":PASSPORT.CUST.ID

* Fix for PACS00306447 [CURRENT VARIABLE ISSUE #1]

*    CALL System.setVariable("CURRENT.VAR.DETAILS",VAR.CUS.DETAILS)

    IF VAR.CUS.DETAILS NE '' THEN
        R.NEW(REDO.CUS.PRF.VAR.NV.INFO) = VAR.CUS.DETAILS
    END

* End of Fix

*
    RETURN
*
* ================
CONTROL.MSG.ERROR:
* ================
*
*   Paragraph that control the error in the subroutine
*
    IF Y.ERR.MSG THEN
        ETEXT = Y.ERR.MSG
        CALL STORE.END.ERROR
    END
*
    RETURN
*
* =================
GET.USER.VARIABLES:
* =================
*
    WVAR.NAME = "CURRENT.CLIENTE.APAP"
    WVAR.VAL  = ""
    WPOS.X    = 0
*
    CALL System.getUserVariables( U.VARNAMES, U.VARVALS )
*
    LOOP
        REMOVE WWVAR FROM WVAR.NAME SETTING WVAR.POS
    WHILE WWVAR : WVAR.POS DO
        WPOS.X += 1
        LOCATE WWVAR IN U.VARNAMES SETTING YPOS.VAR THEN
            WVAR.VAL<WPOS.X> = U.VARVALS<YPOS.VAR>
        END
    REPEAT
*

* Fix for PACS00306447 [CURRENT VARIABLE ISSUE #2]

    WVAR.VAL = R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE)

* End of Fix

    RETURN
*
* ===
INIT:
* ===
*
    PROCESS.GOAHEAD    = 1
*
    RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
        CASE LOOP.CNT EQ 1
            IF R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) NE "NO CLIENTE APAP" OR R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) NE "PASAPORTE" THEN
                PROCESS.GOAHEAD = ""
            END

        CASE LOOP.CNT EQ 2
            GOSUB GET.USER.VARIABLES
            IF WVAR.VAL EQ "" THEN
                Y.ERR.MSG       = "EB-USER.VARIABLE.&.NOT.DEFINED":FM:WVAR.NAME
                PROCESS.GOAHEAD = ""
            END

        CASE LOOP.CNT EQ 3
            Y.CLIENTE.APAP = WVAR.VAL
            Y.CUS.TYPE     = R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE)

            IF Y.CUS.TYPE NE Y.CLIENTE.APAP THEN
                Y.ERR.MSG       = "EB-CLIENTE.APAP"
                PROCESS.GOAHEAD = ""
            END

        END CASE
*       Message Error
        GOSUB CONTROL.MSG.ERROR
*       Increase
        LOOP.CNT += 1
*
    REPEAT
*
    RETURN

END
