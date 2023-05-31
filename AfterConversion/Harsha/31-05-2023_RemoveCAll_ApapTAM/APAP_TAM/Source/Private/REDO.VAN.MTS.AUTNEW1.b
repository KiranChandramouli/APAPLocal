$PACKAGE APAP.TAM
SUBROUTINE REDO.VAN.MTS.AUTNEW1
*
* =============================================================================
*
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2011/Apr/06
*
* ======================================================================
*
*  PACS00128530 - Show cash amount available for PAYBACK versions

** 18-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 18-04-2023 Skanda R22 Manual Conversion - No changes
*
* ======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_GTS.COMMON
*
    $INSERT I_F.VERSION
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.ID
*
    $INSERT I_F.REDO.TRANSACTION.CHAIN ;* R22 Auto conversion
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
    WFOUND = ""
*
    LOOP
        REMOVE WTT.ID FROM TELLER.NO SETTING TELLER.POS
    WHILE WTT.ID:TELLER.POS AND NOT(WFOUND) DO
        CALL F.READ(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ)
        IF R.TELLER.ID THEN
            IF R.TELLER.ID<TT.TID.STATUS> EQ "OPEN" THEN
                R.NEW(TT.TE.TELLER.ID.1) = WTT.ID
                CALL System.setVariable("CURRENT.TID.ID",WTT.ID)
                GOSUB PROCESS.TELLER.ID.RECORD
            END
        END
    REPEAT
** PACS00245686 - S
*      IF CCY.BALANCE NE LCCY THEN
*         GOSUB POPULATE.TT.FCY
*      END
** PACS00245686 - E
    GOSUB VALIDATE.TRANSACTION.CHAIN
*
** PACS00255145 - S
    IF CCY.BALANCE NE "" AND CCY.BALANCE NE LCCY AND R.REDO.TRANSACTION.CHAIN NE "" THEN
        GOSUB POPULATE.TT.FCY
    END
** PACS00255145 - E
*
    CALL System.setVariable("CURRENT.WTM.FIRST.ID",WTM.FIRST.ID)
    CALL System.setVariable("CURRENT.AUTOR.PROCESS",WTM.AUTOR.PROCESS)
    CALL System.setVariable("CURRENT.PROC.AUTOR",WTM.PROC.AUTOR)
    CALL System.setVariable("CURRENT.WTM.LAST.ID",WTM.LAST.ID)
*
RETURN
*
* =======================
PROCESS.TELLER.ID.RECORD:
* =======================
*
    WFOUND           = 1
    NV.AMOUNT        = 0
    NV.CCY           = ""
    NV.TYPE          = ""
    WTM.LAST.ID      = ""
    WINITIAL.ID      = R.TELLER.ID<TT.TID.LOCAL.REF,WPOSLI>
    IF WINITIAL.ID NE "" THEN
        WTM.FIRST.ID                          = WINITIAL.ID
        WTM.AUTOR.PROCESS                     = "NO"
        WTM.PROC.AUTOR                        = "NO"
        R.NEW(TT.TE.LOCAL.REF)<1,WPOSTCCY>    = R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCCY>
        R.NEW(TT.TE.LOCAL.REF)<1,WPOSTCASH>   = R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCASH>
        R.NEW(TT.TE.LOCAL.REF)<1,WPOSTCHECK>  = R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCHECK>
        CCY.BALANCE                           = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCCY>)
        CASH.BALANCE                          = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCASH>)
        CHECK.BALANCE                         = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCHECK>)
    END ELSE
        IF R.NEW(TT.TE.LOCAL.REF)<1,WPOS.LI> NE "" THEN
            WTM.AUTOR.PROCESS = "A"
            WTM.PROC.AUTOR    = "A"
            WTM.FIRST.ID      = R.NEW(TT.TE.LOCAL.REF)<1,WPOS.LI>
        END ELSE
            WTM.FIRST.ID      = ID.NEW
            WTM.PROC.AUTOR    = "NO"
            WTM.AUTOR.PROCESS = "NO"
        END
        CCY.BALANCE      = ""
        CASH.BALANCE     = ""
        CHECK.BALANCE    = ""
    END
*
RETURN
*
*---------------------------
VALIDATE.TRANSACTION.CHAIN:
*---------------------------
*
    CALL F.READ(FN.REDO.TRANSACTION.CHAIN,WTM.FIRST.ID,R.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN,ERR.MSJ)
    IF R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AUTH> EQ "U" OR R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AUTH> EQ "AP" THEN ;* R22 Auto conversion
        WTID.NUMBER = DCOUNT(R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID>,@VM)
        WTM.LAST.ID  = R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID,WTID.NUMBER>
        WTM.AUTOR.PROCESS = "A"
    END ELSE
        WTM.AUTOR.PROCESS = "NO"
        WTM.PROC.AUTOR    = "NO"
    END
*
    IF WTM.AUTOR.PROCESS EQ "A" THEN
        IF R.NEW(WPOS.LR)<1,WPOSTA> NE "A" THEN
            R.NEW(WPOS.LR)<1,WPOSTA> = "A"
        END ELSE
            R.NEW(WPOS.LR)<1,WPOSTA> = "X"
        END
    END
*
RETURN
*
*---------------
POPULATE.TT.FCY:
*---------------
* Populating related CURRENCY side within a transaction chain which is using Foreign currency
*
    WCCY = CCY.BALANCE
    IF WCCY NE LCCY THEN
        Y.TT.CCY1 = R.NEW(TT.TE.CURRENCY.1) ; Y.TT.CCY2 = R.NEW(TT.TE.CURRENCY.2)
        IF Y.TT.CCY1 EQ LCCY AND Y.TT.CCY2 EQ "" THEN
            R.NEW(TT.TE.CURRENCY.1) = CCY.BALANCE
        END
*
        IF Y.TT.CCY2 EQ LCCY AND Y.TT.CCY1 EQ "" THEN
            R.NEW(TT.TE.CURRENCY.2) = CCY.BALANCE
        END
    END
*
RETURN
*
*------------
GET.WTM.VARS:
*------------
*
    IF R.NEW(TT.TE.LOCAL.REF)<1,WPOS.LI> NE "" THEN
        WTM.AUTOR.PROCESS = "A"
        WTM.PROC.AUTOR    = "A"
        WTM.FIRST.ID      = R.NEW(TT.TE.LOCAL.REF)<1,WPOS.LI>
    END
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
* ===================
RESET.USER.VARIABLES:
* ===================
*
    CALL System.setVariable("CURRENT.TID.ID","")
    CALL System.setVariable("CURRENT.TID.CCY","")
    CALL System.setVariable("CURRENT.TID.CASH","")
    CALL System.setVariable("CURRENT.WTM.FIRST.ID","")
    CALL System.setVariable("CURRENT.AUTOR.PROCESS","")
    CALL System.setVariable("CURRENT.PROC.AUTOR","")
    CALL System.setVariable("CURRENT.SIDE","")
    CALL System.setVariable("CURRENT.CATEGORI","")
    CALL System.setVariable("CURRENT.CATEGNEW","")
    CALL System.setVariable("CURRENT.WTM.MONEDA","")
    CALL System.setVariable("CURRENT.WTM.TYPE","")
    CALL System.setVariable("CURRENT.WTM.TRID","")
    CALL System.setVariable("CURRENT.WTM.AMOUNT","")
    CALL System.setVariable("CURRENT.WTM.RESULT","")
    CALL System.setVariable("CURRENT.CHANGED","")
    CALL System.setVariable("CURRENT.FLOW",APPLICATION:PGM.VERSION)
*
RETURN
*
* ---------
INITIALISE:
* ---------
    PROCESS.GOAHEAD    = 1
*
    Y.ERR.MSG          = ""
    NV.CCY             = ""
    NV.TYPE            = ""
    NV.AMOUNT          = ""
    WTM.AUTOR.PROCESS   = "NO"
    WTM.PROC.AUTOR      = "NO"
*
    FN.TELLER.ID = "F.TELLER.ID"
    F.TELLER.ID  = ""
*
    FN.TELLER.USER = "F.TELLER.USER"
    F.TELLER.USER  = ""
*
    FN.REDO.TRANSACTION.CHAIN = "F.REDO.TRANSACTION.CHAIN"
    F.REDO.TRANSACTION.CHAIN  = ""
*
    WAPP.LST = "TELLER.ID" : @FM : "TELLER"
    WCAMPO    = "L.INITIAL.ID"
    WCAMPO<2> = "L.CH.CASH"
    WCAMPO<3> = "L.CH.CHECK"
    WCAMPO<4> = "L.CH.CCY"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    WFLD.LST  = WCAMPO
    WCAMPO    = "L.NEXT.VERSION"
    WCAMPO<2> = "L.CH.CASH"
    WCAMPO<3> = "L.CH.CHECK"
    WCAMPO<4> = "L.CH.CCY"
    WCAMPO<5> = "L.TRAN.AUTH"
    WCAMPO<6> = "L.INITIAL.ID"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    WFLD.LST := @FM : WCAMPO

    YPOS = ''
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
    WPOS.LR    = TT.TE.LOCAL.REF
*
    GOSUB RESET.USER.VARIABLES
*
    IF OFS$SOURCE.ID EQ 'FASTPATH' THEN
*        R.NEW(WPOS.LR)<1,WPOSTA> = "X"
        R.NEW(TT.TE.OUR.REFERENCE) = ID.NEW
    END
RETURN
*
*---------------
OPEN.FILES:
*---------------
*
RETURN


*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
    LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                IF V$FUNCTION EQ "D" THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2
                IF V$FUNCTION EQ "A" THEN
                    PROCESS.GOAHEAD  = ""
                    TELLER.NO        = R.NEW(TT.TE.TELLER.ID.1)
                    GOSUB GET.WTM.VARS      ;* Code Review - 2012MAY30
                END

            CASE LOOP.CNT EQ 3
                CALL F.READ(FN.TELLER.USER,OPERATOR,R.TELLER.USER,F.TELLER.USER,ERR.MSJ)
                IF R.TELLER.USER THEN
                    TELLER.NO  = R.TELLER.USER
                END ELSE
                    Y.ERR.MSG = "EB-NOTELLER.ASSIGNED"
                    AF = TT.TE.AMOUNT.LOCAL.1
                    PROCESS.GOAHEAD = 0
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
