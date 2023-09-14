* @ValidationCode : MjozMzUwMTg4NjE6Q3AxMjUyOjE2ODE3OTc1NDg3MTg6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Apr 2023 11:29:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*
SUBROUTINE REDO.NV.DELETE.FT
*
* =============================================================================
*
*  Used when a TT transaction part of a transaction chain is DELETED
*
*  Updates TELLER.ID balances
*  Updates REDO.TRANSACTION.CHAIN balances and status
*
*=======================================================================
*
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2011 / MAY / 04
*
*=======================================================================
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*18-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,IF CONDITION ADDED
*18-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-------------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
*
    $INSERT I_F.VERSION
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER.ID
    $INSERT I_F.FT.TXN.TYPE.CONDITION
*
    $INSERT I_F.REDO.MULTITXN.PARAMETER
    $INSERT I_F.REDO.TRANSACTION.CHAIN
*
* DEBUG
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
* ---------------
PROCESS:
*  --------------
*
    WVCCY     = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCCY>)
    WVALCASH  = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCASH>)
    WVALCHECK = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK>)

    LOCATE NV.CCY IN WVCCY<1> SETTING YPOS THEN
        WEFECTIVO = WVALCASH<YPOS>
        WCHEQUE   = WVALCHECK<YPOS>
    END
*
    GOSUB UPDATE.TELLER.ID
*
    GOSUB UPDATE.REDO.TRANSACTION.CHAIN
*
    IF Y.ERR.MSG THEN
        GOSUB CONTROL.MSG.ERROR
    END
*
RETURN
*
* ---------------
UPDATE.TELLER.ID:
*  --------------
*
    RTR= ""
*
    CALL F.READU(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ,RTR)
    R.TELLER.ID<TT.TID.LOCAL.REF,WPOSLI>    = WINITIAL.ID
    LOCATE NV.CCY IN WVCCY<1> SETTING YPOS THEN
        IF NV.TYPE EQ "CHECK" THEN
            WVALCHECK<YPOS> += WTRAN.AMOUNT
        END ELSE
            WVALCASH<YPOS> += WTRAN.AMOUNT
        END
    END ELSE
        WVCCY<-1> = NV.CCY
        IF NV.TYPE EQ "CHECK" THEN
            WVALCHECK<-1> = WTRAN.AMOUNT
        END ELSE
            WVALCASH<-1> = WTRAN.AMOUNT
        END
    END
    R.TELLER.ID<TT.TID.LOCAL.REF,WCCY>   = LOWER(WVCCY)
    R.TELLER.ID<TT.TID.LOCAL.REF,WCASH>  = LOWER(WVALCASH)
    R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK> = LOWER(WVALCHECK)

    CALL F.WRITE(FN.TELLER.ID,WTT.ID,R.TELLER.ID)
*
RETURN
*
* ----------------------------
UPDATE.REDO.TRANSACTION.CHAIN:
* ----------------------------
    RTR         = ""
    CALL F.READU(FN.REDO.TRANSACTION.CHAIN,WINITIAL.ID,R.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN,ERR.MSJ,RTR)
    LOCATE ID.NEW IN R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID,1> SETTING Y.POS THEN
        R.REDO.TRANSACTION.CHAIN<RTC.TRANS.STATUS,Y.POS>   = "DEL"
    END
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AUTH>   = "P"

    GOSUB UPDATE.CHANGE.BALANCE

    GOSUB UPDATE.CASHIER.BALANCES
*
    CALL F.WRITE(FN.REDO.TRANSACTION.CHAIN,WINITIAL.ID,R.REDO.TRANSACTION.CHAIN)
*
RETURN
*
*--------------------
UPDATE.CHANGE.BALANCE:
* -------------------
*
    IF NV.AMOUNT LT 0 THEN
        IF NV.TYPE EQ "CASH" THEN
            R.REDO.TRANSACTION.CHAIN<RTC.TOTAL.CASH>   += NV.AMOUNT
        END ELSE
            R.REDO.TRANSACTION.CHAIN<RTC.TOTAL.CHECK>  += NV.AMOUNT
        END
    END
*
    IF NV.TYPE EQ "CASH" THEN
        R.REDO.TRANSACTION.CHAIN<RTC.CASH.BALANCE>  += NV.AMOUNT
    END ELSE
        R.REDO.TRANSACTION.CHAIN<RTC.CHECK.BALANCE> += NV.AMOUNT
    END
*
RETURN
*
* ======================
UPDATE.CASHIER.BALANCES:
* ======================
*
    WVCCY     = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCCY>)
    WVALCASH  = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCASH>)
    WVALCHECK = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK>)
*
    R.REDO.TRANSACTION.CHAIN<RTC.CCY.INFO>   = WVCCY
    R.REDO.TRANSACTION.CHAIN<RTC.CASH.INFO>  = WVALCASH
    R.REDO.TRANSACTION.CHAIN<RTC.CHECK.INFO> = WVALCHECK
*
RETURN
*
* ================
CONTROL.MSG.ERROR:
* ================
*
*   Paragraph that control the error in the subroutine
*
    ETEXT           = Y.ERR.MSG
    CALL STORE.END.ERROR
    ETEXT           = ""
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD    = 1
*
    Y.ERR.MSG          = ""
*
    WTT.ID             = System.getVariable("CURRENT.TID.ID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN     ;*R22 AUTO CODE CONVERSION.START
        WTT.ID = ""     ;*R22 AUTO CODE CONVERSION
    END    ;*R22 AUTO CODE CONVERSION.END

*
    FN.TELLER.TRANSACTION = "F.TELLER.TRANSACTION"
    F.TELLER.TRANSACTION  = ""

    FN.REDO.TRANSACTION.CHAIN = "F.REDO.TRANSACTION.CHAIN"
    F.REDO.TRANSACTION.CHAIN  = ""


    FN.TELLER.ID = "F.TELLER.ID"
    F.TELLER.ID  = ""

    FN.REDO.MULTITXN.PARAMETER = "F.REDO.MULTITXN.PARAMETER"
    F.REDO.MULTITXN.PARAMETER  = ""
*
    WAPP.LST  = "TELLER.ID" : @FM : "FUNDS.TRANSFER"
    WCAMPO    = "L.CH.CASH"
    WCAMPO<2> = "L.CH.CHECK"
    WCAMPO<3> = "L.CH.CCY"
    WCAMPO<4> = "L.INITIAL.ID"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM) : @FM : "L.INITIAL.ID"
    CALL MULTI.GET.LOC.REF(WAPP.LST,WCAMPO,YPOS)
    WCASH   = YPOS<1,1>
    WCHECK  = YPOS<1,2>
    WCCY    = YPOS<1,3>
    WPOSLI  = YPOS<1,4>
*
    WPOS.LI = YPOS<2,1>
*
    WINITIAL.ID  = R.NEW(FT.LOCAL.REF)<1,WPOS.LI>
    WTRAN.AMOUNT = R.NEW(FT.DEBIT.AMOUNT)
*
    WEFECTIVO    = 0
    WCHEQUE      = 0
    NV.AMOUNT    = WTRAN.AMOUNT
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
                IF WINITIAL.ID EQ "" THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2
                CALL F.READ(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ)
                IF NOT(R.TELLER.ID) THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 3
                CALL F.READ(FN.REDO.TRANSACTION.CHAIN,WINITIAL.ID,R.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN,ERR.MSJ)
                IF ERR.MSJ THEN
                    Y.ERR.MSG = ERR.MSJ
                    AF        = FT.DEBIT.AMOUNT
                    PROCESS.GOAHEAD = ""
                END ELSE
                    LOCATE ID.NEW IN R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID,1> SETTING Y.POS THEN
                        NV.CCY  = R.REDO.TRANSACTION.CHAIN<RTC.TRANS.CCY,Y.POS>
                        NV.TYPE = R.REDO.TRANSACTION.CHAIN<RTC.TRANS.TYPE,Y.POS>
                    END
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
