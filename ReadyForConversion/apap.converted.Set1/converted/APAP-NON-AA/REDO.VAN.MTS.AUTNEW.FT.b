*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.VAN.MTS.AUTNEW.FT
*
* =============================================================================
*
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2011/Apr/06
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.VERSION
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER.ID
    $INSERT I_F.USER
    $INSERT I_System
*
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_F.REDO.MULTITXN.PARAMETER



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
    GOSUB STORE.TELLER.ID.INFO
*
    IF WTM.FIRST.ID NE "" THEN  ;* Si ya hay FIRST.ID, valida el ESTADO de RTC
        GOSUB VALIDATE.TRANSACTION.CHAIN
    END
*
    CALL System.setVariable("CURRENT.TID.ID",WTT.ID)
    CALL System.setVariable("CURRENT.CONTROL.FILE","TELLER")
    CALL System.setVariable("CURRENT.WTM.FIRST.ID",WTM.FIRST.ID)
    CALL System.setVariable("CURRENT.AUTOR.PROCESS",WTM.AUTOR.PROCESS)
    CALL System.setVariable("CURRENT.PROC.AUTOR",WTM.PROC.AUTOR)
    CALL System.setVariable("CURRENT.WTM.LAST.ID",WTM.LAST.ID)
*
RETURN
*
* ===================
STORE.TELLER.ID.INFO:
* ===================
*
    IF WTM.FIRST.ID NE "" THEN
        R.NEW(WPOS.LR)<1,WPOSTCCY>   = R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCCY>
        R.NEW(WPOS.LR)<1,WPOSTCASH>  = R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCASH>
        R.NEW(WPOS.LR)<1,WPOSTCHECK> = R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCHECK>
    END ELSE
        IF R.NEW(WPOS.LR)<1,WPOS.LI> NE "" THEN
            WTM.AUTOR.PROCESS = "A"
            WTM.PROC.AUTOR    = "A"
            WTM.FIRST.ID      = R.NEW(WPOS.LR)<1,WPOS.LI>
        END ELSE
            WTM.FIRST.ID             = ID.NEW
        END
    END
*
RETURN

*
*---------------------------
VALIDATE.TRANSACTION.CHAIN:
*---------------------------
*
    CALL F.READ(FN.REDO.TRANSACTION.CHAIN,WTM.FIRST.ID,R.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN,ERR.MSJ)
    IF R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AUTH> EQ "U" OR R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AUTH> EQ "AP" THEN
        WTID.NUMBER  = DCOUNT(R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID>,@VM)
        WTM.LAST.ID  = R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID,WTID.NUMBER>
        WTM.AUTOR.PROCESS = "A"
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
                WTT.ID          = WTTP.ID
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
* ===================
GET.LOCAL.FIELDS.POS:
* ===================
*
    WAPP.LST = "TELLER.ID" : @FM : "USER" : @FM : APPLICATION
    WCAMPO    = "L.INITIAL.ID"
    WCAMPO<2> = "L.CH.CASH"
    WCAMPO<3> = "L.CH.CHECK"
    WCAMPO<4> = "L.CH.CCY"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    WFLD.LST  = WCAMPO : @FM : WCAMPO
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
    WPOSLI     = YPOS<1,1>
    WPOSCASH   = YPOS<1,2>
    WPOSCHECK  = YPOS<1,3>
    WPOSCCY    = YPOS<1,4>
    WPOSULI    = YPOS<2,1>
    WPOSUCASH  = YPOS<2,2>
    WPOSUCHECK = YPOS<2,3>
    WPOSUCCY   = YPOS<2,4>
    WPOSNV     = YPOS<3,1>
    WPOSTCASH  = YPOS<3,2>
    WPOSTCHECK = YPOS<3,3>
    WPOSTCCY   = YPOS<3,4>
    WPOSTA     = YPOS<3,5>
    WPOS.LI    = YPOS<3,6>
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
    CALL System.setVariable("CURRENT.TID.CHECK","") ;* Changed
    CALL System.setVariable("CURRENT.SIDE","")
    CALL System.setVariable("CURRENT.CATEGORI","")
    CALL System.setVariable("CURRENT.CATEGNEW","")
    CALL System.setVariable("CURRENT.WTM.MONEDA","")
    CALL System.setVariable("CURRENT.WTM.TYPE","")
    CALL System.setVariable("CURRENT.WTM.TRID","")
    CALL System.setVariable("CURRENT.WTM.AMOUNT","")
    CALL System.setVariable("CURRENT.WTM.RESULT","0")         ;* Changed
    CALL System.setVariable("CURRENT.CHANGED","")
    CALL System.setVariable("CURRENT.CONTROL.FILE","")
    CALL System.setVariable("CURRENT.FLOW",APPLICATION:PGM.VERSION)     ;* Changed
*
RETURN
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD    = 1
*
    Y.ERR.MSG           = ""
    WTM.AUTOR.PROCESS   = "NO"
    WTM.PROC.AUTOR      = "NO"
    WTM.LAST.ID         = ""
    WTM.FIRST.ID        = ""
    FLAG.PROCESS        = ""
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
    GOSUB GET.LOCAL.FIELDS.POS
*
    FN.REDO.MULTITXN.PARAMETER = 'F.REDO.MULTITXN.PARAMETER'
    F.REDO.MULTITXN.PARAMETER = ''
    CALL OPF(FN.REDO.MULTITXN.PARAMETER,F.REDO.MULTITXN.PARAMETER)

    CALL CACHE.READ(FN.REDO.MULTITXN.PARAMETER,'SYSTEM',R.RMP,RMP.ERR)


    BEGIN CASE
        CASE APPLICATION EQ "TELLER"
            WPOS.LR          = TT.TE.LOCAL.REF
            WFN.AMOUNT.LOCAL = TT.TE.AMOUNT.LOCAL.1
        CASE APPLICATION EQ "FUNDS.TRANSFER"
            WPOS.LR          = FT.LOCAL.REF
*WFN.AMOUNT.LOCAL = FT.DEBIT.AMOUNT
            WFN.AMOUNT.LOCAL = FT.CREDIT.AMOUNT ;* Changed
            IF R.NEW(FT.DEBIT.ACCT.NO) EQ '' AND R.RMP<RMP.CHECK.ACCOUNT> NE '' THEN
                Y.DEB.AC = LCCY:R.RMP<RMP.CHECK.ACCOUNT>
                CALL INT.ACC.OPEN(Y.DEB.AC,PRETURN.CODE)
                R.NEW(FT.DEBIT.ACCT.NO)= LCCY:R.RMP<RMP.CHECK.ACCOUNT>
            END
    END CASE
*
    GOSUB RESET.USER.VARIABLES
*
RETURN
*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
    IF Y.ERR.MSG THEN
        ETEXT           = Y.ERR.MSG
        CALL STORE.END.ERROR
        ETEXT           = ""
    END
*
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
                    IF R.NEW(WPOS.LR)<1,WPOS.LI> NE "" THEN
                        WTM.FIRST.ID      = R.NEW(WPOS.LR)<1,WPOS.LI>
                        CALL System.setVariable("CURRENT.WTM.FIRST.ID",WTM.FIRST.ID)
                        CALL System.setVariable("CURRENT.AUTOR.PROCESS","A")
                        CALL System.setVariable("CURRENT.PROC.AUTOR","A")
                    END
                END

            CASE LOOP.CNT EQ 3
                Y.OPERATOR = OPERATOR
                CALL F.READ(FN.TELLER.USER,Y.OPERATOR,R.TELLER.USER,F.TELLER.USER,ERR.MSJ)
                IF R.TELLER.USER THEN
                    TELLER.NO  = R.TELLER.USER
                    GOSUB GET.TELLER.ID.INFO
                END ELSE
                    Y.ERR.MSG = "EB-NOTELLER.ASSIGNED"
                    AF        = WFN.AMOUNT.LOCAL
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
END
