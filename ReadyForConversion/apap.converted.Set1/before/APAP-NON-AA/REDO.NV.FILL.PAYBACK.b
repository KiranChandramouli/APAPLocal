*-----------------------------------------------------------------------------
* <Rating>-73</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.NV.FILL.PAYBACK
******************************************************************************
* =============================================================================
*
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2011/SEP/22
*
* ======================================================================
*
*  PACS00128530 - Show cash amount available for PAYBACK versions
*
* ======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_F.VERSION
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.ID
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
*--------
PROCESS:
*--------
*
    CCY.BALANCE  = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCCY>)
    CASH.BALANCE = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCASH>)
*
    WTID.NUMBER = DCOUNT(CCY.BALANCE,VM)
    IF WTID.NUMBER GT 1 THEN
        Y.ERR.MSG = "EB-SEVERAL.PENDING.BALANCES.&":FM:WTID.NUMBER
        AF = TT.TE.AMOUNT.LOCAL.1
        GOSUB CONTROL.MSG.ERROR
    END ELSE
        WCCY = CCY.BALANCE
        R.NEW(TT.TE.CURRENCY.1)           = WCCY
        R.NEW(TT.TE.LOCAL.REF)<1,WPOS.LI>  = WINITIAL.ID
        R.NEW(TT.TE.LOCAL.REF)<1,WPOS.AMT> = CASH.BALANCE * -1
        IF WCCY EQ LCCY THEN
            R.NEW(TT.TE.AMOUNT.LOCAL.1) = CASH.BALANCE
        END ELSE
            R.NEW(TT.TE.AMOUNT.FCY.1) = CASH.BALANCE
        END
        CALL REDO.HANDLE.COMM.TAX.FIELDS
        CALL System.setVariable("CURRENT.WTM.RESULT","0")
        CALL System.setVariable("CURRENT.WTM.MONEDA",WCCY)
        CALL System.setVariable("CURRENT.WTM.TYPE","CASH")
    END
*
    RETURN
*
* =================
GET.TELLER.ID.INFO:
* =================
*
    WFOUND = ""
*
    LOOP
        REMOVE WTT.ID FROM TELLER.NO SETTING TELLER.POS
    WHILE WTT.ID:TELLER.POS AND NOT(WFOUND) DO
        CALL F.READ(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ)
        IF R.TELLER.ID THEN
            IF R.TELLER.ID<TT.TID.STATUS> EQ "OPEN" THEN
                WFOUND      = "1"
                WINITIAL.ID = R.TELLER.ID<TT.TID.LOCAL.REF,WPOSLI>
                R.NEW(TT.TE.TELLER.ID.2) = WTT.ID      ;* PACS00588615
            END
        END
    REPEAT
*
    RETURN
*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
    ETEXT           = Y.ERR.MSG
    CALL STORE.END.ERROR
    ETEXT           = ""
*
    RETURN
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD    = 1
*
    Y.ERR.MSG          = ""
*
    WTM.AUTOR.PROCESS = System.getVariable("CURRENT.AUTOR.PROCESS")
    WTM.PROC.AUTOR    = System.getVariable("CURRENT.PROC.AUTOR")
*
    FN.TELLER.ID = "F.TELLER.ID"
    F.TELLER.ID  = ""
*
    FN.TELLER.USER = "F.TELLER.USER"
    F.TELLER.USER  = ""
*
    WAPP.LST = "TELLER.ID" : FM : "TELLER"
    WCAMPO    = "L.INITIAL.ID"
    WCAMPO<2> = "L.CH.CASH"
    WCAMPO<3> = "L.CH.CHECK"
    WCAMPO<4> = "L.CH.CCY"
    WCAMPO    = CHANGE(WCAMPO,FM,VM)
    WFLD.LST  = WCAMPO
    WCAMPO    = "L.NEXT.VERSION"
    WCAMPO<2> = "L.CH.CASH"
    WCAMPO<3> = "L.CH.CHECK"
    WCAMPO<4> = "L.CH.CCY"
    WCAMPO<5> = "L.TRAN.AUTH"
    WCAMPO<6> = "L.INITIAL.ID"
    WCAMPO<7> = "L.TRAN.AMOUNT"
    WCAMPO    = CHANGE(WCAMPO,FM,VM)
    WFLD.LST := FM : WCAMPO
    CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)
    WPOSLI    = YPOS<1,1>
    WPOSCASH  = YPOS<1,2>
    WPOSCHECK = YPOS<1,3>
    WPOSCCY   = YPOS<1,4>
*
    WPOSNV     = YPOS<2,1>
    WPOSTCASH  = YPOS<2,2>
    WPOSTCHECK = YPOS<2,3>
    WPOSTCCY   = YPOS<2,4>
    WPOSTA     = YPOS<2,5>
    WPOS.LI    = YPOS<2,6>
    WPOS.AMT   = YPOS<2,7>
    WPOS.LR    = TT.TE.LOCAL.REF
*
    IF R.NEW(TT.TE.LOCAL.REF)<1,WPOS.LI> NE "" THEN
        PROCESS.GOAHEAD    = ""
    END
*
    RETURN
*
*---------------
OPEN.FILES:
*---------------
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
            CALL F.READ(FN.TELLER.USER,OPERATOR,R.TELLER.USER,F.TELLER.USER,ERR.MSJ)
            IF R.TELLER.USER THEN
                TELLER.NO  = R.TELLER.USER
            END ELSE
                Y.ERR.MSG = "EB-NOTELLER.ASSIGNED"
                AF = TT.TE.AMOUNT.LOCAL.1
                PROCESS.GOAHEAD = ""
            END

        CASE LOOP.CNT EQ 2
            GOSUB GET.TELLER.ID.INFO
            IF NOT(WFOUND) THEN
                Y.ERR.MSG = "EB-NOTELLER.ASSIGNED"
                AF = TT.TE.AMOUNT.LOCAL.1
                PROCESS.GOAHEAD = ""
            END

        CASE LOOP.CNT EQ 3
            IF WINITIAL.ID EQ "" THEN
                Y.ERR.MSG = "EB-NO.NEXT.VERSION.PROCESS.FOR.TELLER.&":FM:WTT.ID
                AF = TT.TE.AMOUNT.LOCAL.1
                PROCESS.GOAHEAD = ""
            END

        END CASE
*
        IF Y.ERR.MSG THEN
            GOSUB CONTROL.MSG.ERROR
        END
*
        LOOP.CNT += 1
*
    REPEAT
*
    RETURN
*
END
