*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.VIN.MTS.HANDLE.FT
*
* =======================================================================
*
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2011/AUG/05
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.VERSION
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER.ID
    $INSERT I_System
    $INSERT I_GTS.COMMON
*
*
* DEBUG
*
    IF OFS$SOURCE.ID EQ 'FASTPATH' THEN
        R.VERSION(EB.VER.GTS.CONTROL) = 1
    END

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
    RETURN
*--------
PROCESS:
*--------
*
    IF R.NEW(FT.RECORD.STATUS) NE "IHLD" THEN
        CALL REDO.NV.DELETE.FT
    END
*
    RETURN
*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
*   Paragraph that control the error in the subroutine
*
    ETEXT           = Y.ERR.MSG
    CALL STORE.END.ERROR
    ETEXT           = ""
*
    RETURN
*
* =================
GET.TELLER.ID.INFO:
* =================
*
    WFOUND          = ""
    PROCESS.GOAHEAD = ""
*
    LOOP
        REMOVE WTTP.ID FROM TELLER.NO SETTING TELLER.POS
    WHILE WTTP.ID:TELLER.POS AND NOT(WFOUND) DO
        CALL F.READ(FN.TELLER.ID,WTTP.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ)
        IF R.TELLER.ID THEN
            IF R.TELLER.ID<TT.TID.STATUS> EQ "OPEN" THEN
                WFOUND          = 1
                PROCESS.GOAHEAD = "1"
                WTM.FIRST.ID    = R.TELLER.ID<TT.TID.LOCAL.REF,WPOSLI>
                WTT.ID = WTTP.ID
                CALL System.setVariable("CURRENT.TID.ID",WTT.ID)
            END
        END
    REPEAT
*
    IF NOT(WFOUND) THEN
        Y.ERR.MSG       = "EB-NOTELLER.ASSIGNED"
        AF              = WFN.AMOUNT.LOCAL
        PROCESS.GOAHEAD = ""
    END
*
    RETURN

*
* ---------
INITIALISE:
* ---------
*


    PROCESS.GOAHEAD    = 1
*
    Y.ERR.MSG = ""
*
    WAPP.LST  = "TELLER.ID" : FM : "FUNDS.TRANSFER"
    WCAMPO    = "L.INITIAL.ID"
    WCAMPO    = CHANGE(WCAMPO,FM,VM)
    WFLD.LST  = WCAMPO
    WCAMPO    = "L.NEXT.VERSION"
    WCAMPO<2> = "L.INITIAL.ID"
    WCAMPO    = CHANGE(WCAMPO,FM,VM)
    WFLD.LST := FM : WCAMPO
    YPOS = ''
    CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)
    WPOSLI    = YPOS<1,1>
*
    WPOSNV    = YPOS<2,1>
    WPOS.LI   = YPOS<2,2>
*
    FN.TELLER.ID = "F.TELLER.ID"
    F.TELLER.ID  = ""
*
    FN.TELLER.USER = "F.TELLER.USER"
    F.TELLER.USER  = ""
*
    WTM.AUTOR.PROCESS = System.getVariable("CURRENT.AUTOR.PROCESS")
    WTM.PROC.AUTOR    = System.getVariable("CURRENT.PROC.AUTOR")
    WTT.ID            = System.getVariable("CURRENT.TID.ID")
    WTM.RESULT        = System.getVariable("CURRENT.WTM.RESULT")
*
    IF NOT(WTT.ID) OR WTT.ID EQ "CURRENT.TID.ID" THEN
        Y.OPERATOR = OPERATOR
        CALL F.READ(FN.TELLER.USER,Y.OPERATOR,R.TELLER.USER,F.TELLER.USER,ERR.MSJ)
        IF R.TELLER.USER THEN
            TELLER.NO  = R.TELLER.USER
            GOSUB GET.TELLER.ID.INFO
        END ELSE
            Y.ERR.MSG = "EB-NOTELLER.ASSIGNED"
            AF        = WFN.AMOUNT.LOCAL
            PROCESS.GOAHEAD = ""
            GOSUB CONTROL.MSG.ERROR
        END
    END
*
*WFN.AMOUNT.LOCAL = FT.DEBIT.AMOUNT
    WFN.AMOUNT.LOCAL = FT.CREDIT.AMOUNT ;* Changed
*
    RETURN
*
* =========
OPEN.FILES:
* =========
*
*
    RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT  = 1
    MAX.LOOPS = 3
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
        CASE LOOP.CNT EQ 1
            CALL F.READ(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ)
            IF R.TELLER.ID THEN
                WINITIAL.ID   = R.TELLER.ID<TT.TID.LOCAL.REF,WPOSLI>
*WVCCY         = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCCY>))
*WVALCASH      = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCASH>))
*WVALCHECK     = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCHECK>))
            END

            IF (WINITIAL.ID EQ "" AND R.NEW(FT.LOCAL.REF)<1,WPOSNV> EQ "") OR ((WTM.AUTOR.PROCESS = "A" OR WTM.PROC.AUTOR = "A") AND V$FUNCTION NE "D") THEN
                PROCESS.GOAHEAD    = ""
            END

        CASE LOOP.CNT EQ 2
*R.NEW(FT.LOCAL.REF)<1,WPOS.LI> = WINITIAL.ID  ;* Changed
*WCASH.BALANCE  = SUM(WVALCASH) ;* Changed
*WCHECK.BALANCE = SUM(WVALCHECK) ;* Changed
*IF R.NEW(FT.LOCAL.REF)<1,WPOSNV> EQ "" AND (WCASH.BALANCE NE 0 AND WCHECK.BALANCE NE 0) THEN ;* Changed
            IF WTM.RESULT EQ "CURRENT.WTM.RESULT" THEN
                WTM.RESULT = 0          ;* Changed
                E = ''
            END ELSE          ;* Changed
                IF WTM.RESULT EQ "" THEN
                    WTM.RESULT = 0
                END
            END

            IF R.NEW(FT.LOCAL.REF)<1,WPOSNV> EQ "" AND WTM.RESULT NE 0 THEN     ;* Changed
                Y.ERR.MSG = "EB-TRAN.VALUE.NE.BALANCE:&":FM:WTM.RESULT          ;* Changed
                AF        = FT.CREDIT.AMOUNT
                PROCESS.GOAHEAD = ""
            END

        CASE LOOP.CNT EQ 3
            IF R.VERSION(EB.VER.NO.OF.AUTH) EQ 0 AND OFS$SOURCE.ID NE 'FASTPATH' THEN
                R.VERSION(EB.VER.NO.OF.AUTH) = 1
            END

            IF V$FUNCTION NE "D" THEN
                PROCESS.GOAHEAD = ""
            END

        END CASE
*       Message Error
        IF Y.ERR.MSG THEN
            GOSUB CONTROL.MSG.ERROR
        END
*       Increase
        LOOP.CNT += 1
*
    REPEAT
*
    RETURN
*
END

