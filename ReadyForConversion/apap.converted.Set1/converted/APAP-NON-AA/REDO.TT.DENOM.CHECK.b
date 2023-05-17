SUBROUTINE REDO.TT.DENOM.CHECK
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.TT.DENOM.CHECK
*--------------------------------------------------------------------------------
*
* Description: This INPUT ROUTINE will send an error message showing the
* difference between transaction amount and denomination detail if that occurs.
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
* DATE          WHO            REFERENCE        DESCRIPTION
*
* 08-Apr-2011   H GANESH       PACS00032977     INITIAL CREATION
* 11-Jul-2011   J.Costa C.     PACS00086269     MESSAGE WAS APPEARING RANDOMLY
* 13-Sep-2011   Kavitha        PACS00055620     TELLER.DENOMINATION file was read to fetch denom values.
* 23-JAN-2012   J.Costa C.     PACS00163682     Fix to show complete error message
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_TT.COMMON
*
    $INSERT I_F.TELLER
    $INSERT I_F.VERSION
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER.DENOMINATION
*
    $INSERT I_F.USER
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
* Checks whether Denomination detail entered is correct
*
    DENOM.SUM   = 0
    Y.VAR1      = 1
*
    LOOP
    WHILE Y.VAR1 LE Y.DENOM.NUM
        Y.UNIT     = W.UNIT<1,Y.VAR1>
        IF Y.UNIT NE 0 AND Y.UNIT NE "" THEN
            Y.DENOM    = W.DENOM<1,Y.VAR1>
* PACS00126011-S
            GOSUB CHECK.DENOM
            GOSUB CALC.DENINP.ENRI  ;* VNL - 25OCT2012 S/E
*PACS00126011-E
        END
        Y.VAR1 += 1
    REPEAT

    IF WTRANS.AMOUNT NE DENOM.SUM THEN
        AV        = Y.VAR1 - 1
        WDIFER    = " ":TRIM(FMT(DENOM.SUM-WTRANS.AMOUNT,'R2,$#19'),' ','B')
        Y.ERR.MSG = 'EB-REDO.DENOM.MISMATCH':@FM:WDIFER
    END
*
    GOSUB CONTROL.MSG.ERROR

*
RETURN
*
* ==========
CHECK.DENOM:
* ==========

    CALL CACHE.READ(FN.TELLER.DENOM,Y.DENOM,R.TELLER.DENOM,DENOM.ERR)
    DEN.VALUE = R.TELLER.DENOM<TT.DEN.VALUE>

    DENOM.SUM += Y.UNIT * DEN.VALUE

*
RETURN
*
* ======================
GET.DATA.FOR.VALIDATION:
* ======================
*
    WAPP.LST = "TELLER"
    WFLD.LST = "L.DEBIT.AMOUNT" : @VM : "L.CREDIT.AMOUNT"
    YPOS = ""
    CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)
    WPOS.DB    = YPOS<1,1>
    WPOS.CR    = YPOS<1,2>
*
    BEGIN CASE
        CASE TT.TE.UNIT EQ AF       ;* This part is Credit Side
            WTRANS.AMOUNT  = R.NEW(TT.TE.LOCAL.REF)<1,WPOS.CR>
            W.DENOM        = R.NEW(TT.TE.DENOMINATION)
            GOSUB GET.DATA.CREDIT.TRAN

        CASE TT.TE.DR.UNIT EQ AF    ;* This part is Debit Side
            WTRANS.AMOUNT  = R.NEW(TT.TE.LOCAL.REF)<1,WPOS.DB>
            W.DENOM        = R.NEW(TT.TE.DR.DENOM)
            GOSUB GET.DATA.DEBIT.TRAN

    END CASE
*
RETURN
*
* ===================
GET.DATA.CREDIT.TRAN:
* ===================
*
    IF R.NEW(TT.TE.DR.CR.MARKER) EQ "CREDIT" THEN
        WTRANS.ACCOUNT = R.NEW(TT.TE.ACCOUNT.1)
    END ELSE
        WTRANS.ACCOUNT = R.NEW(TT.TE.ACCOUNT.2)
    END
*
RETURN
*
* ==================
GET.DATA.DEBIT.TRAN:
* ==================
*
    IF R.NEW(TT.TE.DR.CR.MARKER) EQ "DEBIT" THEN
        WTRANS.ACCOUNT = R.NEW(TT.TE.ACCOUNT.1)
    END ELSE
        WTRANS.ACCOUNT = R.NEW(TT.TE.ACCOUNT.2)
    END
*
RETURN
*
* =============
ANALISE.FIELDS:
* =============
*
    WNOINPUT   = RAISE(R.VERSION(EB.VER.NOINPUT.FIELD))
    WF.UNIT    = TT.TE.UNIT
    WF.DR.UNIT = TT.TE.DR.UNIT
*
    GOSUB REPLACE.BLANKS
*
    LOCATE WF.UNIT IN WNOINPUT<1> SETTING TEST.POS THEN
        R.NEW(TT.TE.UNIT) = R.NEW(TT.TE.DR.UNIT)
    END
*
    LOCATE WF.DR.UNIT IN WNOINPUT<1> SETTING TEST.POS THEN
        R.NEW(TT.TE.DR.UNIT) = R.NEW(TT.TE.UNIT)
    END
*
RETURN
*
* =============
REPLACE.BLANKS:
* =============
*
    Y.VAR1      = 1
*
    LOOP
    WHILE Y.VAR1 LE Y.DENOM.NUM
        IF R.NEW(TT.TE.DR.UNIT) NE "" THEN
            IF R.NEW(TT.TE.DR.UNIT)<1,Y.VAR1> EQ "" AND R.NEW(TT.TE.DR.DENOM)<1,Y.VAR1>[1,3] EQ LCCY THEN
                R.NEW(TT.TE.DR.UNIT)<1,Y.VAR1> = 0
            END
        END
*
        IF R.NEW(TT.TE.UNIT) NE "" THEN
            IF R.NEW(TT.TE.UNIT)<1,Y.VAR1> EQ "" AND R.NEW(TT.TE.DENOMINATION)<1,Y.VAR1>[1,3] EQ LCCY THEN

                R.NEW(TT.TE.UNIT)<1,Y.VAR1> = 0
            END
        END
        Y.VAR1 += 1
    REPEAT
*
RETURN
*
* ================
CALC.DENINP.ENRI:
* ================
*
    IF AF EQ TT.TE.UNIT THEN
        OFS$ENRI<TT.TE.UNIT>           = ""
        WSUM.AMT.FMT                   = TRIM(FMT(DENOM.SUM,'R2,$#19'),' ','B')
        OFS$ENRI<TT.TE.UNIT,Y.VAR1>    = "TOTAL CAPTURADO " : WSUM.AMT.FMT
    END
*
    IF AF TT.TE.DR.UNIT THEN
        OFS$ENRI<TT.TE.DR.UNIT>        = ""
        WSUM.AMT.FMT                   = TRIM(FMT(DENOM.SUM,'R2,$#19'),' ','B')
        OFS$ENRI<TT.TE.DR.UNIT,Y.VAR1> = "TOTAL CAPTURADO " : WSUM.AMT.FMT
    END
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
        ETEXT           = Y.ERR.MSG
        CALL STORE.END.ERROR
        ETEXT           = ""
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1
    Y.ERR.MSG       = ""
    Y.FLG.ERR       = ""
*
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.TELLER.DENOM = 'F.TELLER.DENOMINATION'
    F.TELLER.DENOM = ''
    CALL OPF(FN.TELLER.DENOM,F.TELLER.DENOM)
*
RETURN
*
* ---------------
OPEN.FILES:
* ---------------
*

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
                IF MESSAGE NE "VAL" THEN
                    R.NEW.LAST(AF)<1,AV> = COMI
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2
                IF R.NEW(TT.TE.RECORD.STATUS) EQ "IHLD" THEN
                    R.NEW(AF) = R.NEW.LAST(AF)
                END
                W.UNIT      = R.NEW(AF)
                Y.DENOM.NUM = DCOUNT(W.UNIT,@VM)

                IF Y.DENOM.NUM NE AV THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 3
                GOSUB ANALISE.FIELDS
                W.UNIT      = R.NEW(AF)
                Y.DENOM.NUM = DCOUNT(W.UNIT,@VM)
                GOSUB GET.DATA.FOR.VALIDATION
                CALL F.READ(FN.ACCOUNT,WTRANS.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ERR.ACCT)
                GOSUB CHECK.CONTROL
                IF Y.FLG.ERR THEN
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
*
*-------------
CHECK.CONTROL:
*--------------
    IF R.ACCOUNT THEN
        WSTOCK.CONTROL = R.ACCOUNT<AC.STOCK.CONTROL.TYPE>
        IF WSTOCK.CONTROL NE "DENOM" THEN
            Y.FLG.ERR = 1
        END
    END
    ELSE
        Y.FLG.ERR = 1
    END
*
RETURN
*
*--------------
END
