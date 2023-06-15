* @ValidationCode : MjotMTc5MTQwMjE0ODpDcDEyNTI6MTY4MTI5OTY3NzA5ODpJVFNTOi0xOi0xOjEyMDY6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 17:11:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1206
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VUN.MTS.AUTOR.NV
*-------------------------------------------------------------
* =============================================================================
*
*  AFTER UNAU routine that UPDATES balances and records transaction details
*  in USER and REDO.TRANSACTION.CHAIN
*
* =============================================================================
*
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2011/AGO/21
*
*=======================================================================
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM, F TO CACHE, SM TO @SM, ++ TO += 1
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
*
    $INSERT I_F.VERSION
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER.ID
    $INSERT I_F.USER
    $INSERT I_F.FT.TXN.TYPE.CONDITION

*
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_F.REDO.MULTITXN.PARAMETER
*
*
*    DEBUG
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


    BEGIN CASE
        CASE WINITIAL.ID EQ "" AND NEXT.VERSION NE ""
            GOSUB FIRST.TXN

        CASE WINITIAL.ID NE "" AND NEXT.VERSION NE ""
            GOSUB TXN.MIDDLE

        CASE WINITIAL.ID NE "" AND NEXT.VERSION EQ ""
            GOSUB LAST.TXN

    END CASE
*
    IF Y.ERR.MSG THEN
        GOSUB CONTROL.MSG.ERROR
    END ELSE
        WTRAN.AMOUNT = 0
        IF NEXT.VERSION NE "" THEN
            WNEXT.VERSION = NEXT.VERSION:" ":"I":" ":"F3"
*      CALL EB.SET.NEW.TASK(WNEXT.VERSION)
            CALL EB.SET.NEXT.TASK(WNEXT.VERSION)
        END
    END
*
RETURN
*
* ---------------
FIRST.TXN:
*  --------------
*
* For FIRST TRANSACTION in a set of related transactions
*
    WINITIAL.ID                    = ID.NEW
    WTM.FIRST.ID                   = ID.NEW
    R.NEW(FT.LOCAL.REF)<1,WPOS.LI> = ID.NEW
*
    RTR= ""
*
    CALL F.READU(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ,RTR)
    R.TELLER.ID<TT.TID.LOCAL.REF,WPOSLI>    = ID.NEW
    R.TELLER.ID<TT.TID.LOCAL.REF,WCCY>      = WTM.CCY
    IF WTM.TYPE EQ "CHECK" THEN
        R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK> = WTRAN.AMOUNT
    END ELSE
        R.TELLER.ID<TT.TID.LOCAL.REF,WCASH>  = WTRAN.AMOUNT
    END
*
    CALL F.WRITE(FN.TELLER.ID,WTT.ID,R.TELLER.ID)
    R.REDO.INIT.ID.NV = ID.NEW
    CALL F.WRITE(FN.REDO.INIT.ID.NV,WTT.ID,R.REDO.INIT.ID.NV)
    CALL System.setVariable("CURRENT.INDA.ID",R.REDO.INIT.ID.NV)
*
    IF R.FT.TXN.TYPE.CONDITION THEN
        TRANSDESC = R.FT.TXN.TYPE.CONDITION<FT6.DESCRIPTION,1,WLANG>
    END
    R.REDO.TRANSACTION.CHAIN                     = ""
    R.REDO.TRANSACTION.CHAIN<RTC.TELLER.ID>      = WTT.ID
    R.REDO.TRANSACTION.CHAIN<RTC.BRANCH.CODE>    = R.NEW(FT.CO.CODE)
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.DATE>     = TODAY
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID>       = WINITIAL.ID
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.DESC>     = TRANSDESC
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.CCY>      = WTM.CCY
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.TYPE>     = WTM.TYPE
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.VERS>     = APPLICATION:PGM.VERSION
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AMOUNT>   = WTRAN.AMOUNT
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.STATUS>   = R.NEW(FT.RECORD.STATUS)
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AUTH>     = "P"
    GOSUB UPDATE.CHAIN.BALANCE
    IF R.NEW(FT.LOCAL.REF)<1,POS.CERT.CHEQUE.NO> THEN         ;* Changed
        GOSUB UPDATE.CHEQUE.NOS   ;* Changed
    END     ;* Changed
    CALL F.WRITE(FN.REDO.TRANSACTION.CHAIN,WINITIAL.ID,R.REDO.TRANSACTION.CHAIN)
*
RETURN
*
* ---------
TXN.MIDDLE:
* ---------
*
* For transactions in the middle of a set of transactions
*
    RTR = ""
    CALL F.READU(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ,RTR)
    LOCATE WTM.CCY IN WVCCY<1> SETTING YPOS THEN
        IF WTM.TYPE EQ "CHECK" THEN
            WVALCHECK<YPOS> += WTRAN.AMOUNT
            IF WVALCHECK<YPOS> LT 0 THEN
                WVALCASH<YPOS> +=  WVALCHECK<YPOS>
                WVALCHECK<YPOS> = 0
            END
        END ELSE
            WVALCASH<YPOS> += WTRAN.AMOUNT
        END
    END ELSE
        WVCCY<-1> = WTM.CCY
        IF WTM.TYPE EQ "CHECK" THEN
            WVALCHECK<-1> = WTRAN.AMOUNT
        END ELSE
            WVALCASH<-1> = WTRAN.AMOUNT
        END
    END
    R.TELLER.ID<TT.TID.LOCAL.REF,WCCY>   = LOWER(LOWER(WVCCY))
    R.TELLER.ID<TT.TID.LOCAL.REF,WCASH>  = LOWER(LOWER(WVALCASH))
    R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK> = LOWER(LOWER(WVALCHECK))

    CALL F.WRITE(FN.TELLER.ID,WTT.ID,R.TELLER.ID)
*
    GOSUB UPDATE.REDO.TRANSACTION.CHAIN
*
RETURN
*
* ---------------
LAST.TXN:
*  --------------
*
* LAST transaction in a set of related transactions
*
    WTM.LAST.ID = ID.NEW
*
    CALL F.READU(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ,YNN)
*
* Operator control fields should be initialized
*
    R.TELLER.ID<TT.TID.LOCAL.REF,WPOSLI> = ""
    R.TELLER.ID<TT.TID.LOCAL.REF,WCCY>   = ""
    R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK> = ""
    R.TELLER.ID<TT.TID.LOCAL.REF,WCASH>  = ""
    CALL F.WRITE(FN.TELLER.ID,WTT.ID,R.TELLER.ID)
*
    GOSUB UPDATE.REDO.TRANSACTION.CHAIN
*
    Y.STR           = "ENQ NOFILE.REDO.NV.E.AUTHOR @ID EQ " : WTM.FIRST.ID
    OFS$NEW.COMMAND = Y.STR
*
RETURN
*
* ----------------------------
UPDATE.REDO.TRANSACTION.CHAIN:
* ----------------------------
*
* Local table REDO.TRANSACTION.CHAIN is updated with transaction information
*
    RTR         = ""
*CALL F.READ(FN.FT.TXN.TYPE.CONDITION,TRANSID,R.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION,ERR.MSJ)
    IF R.FT.TXN.TYPE.CONDITION THEN
        TRANSDESC = R.FT.TXN.TYPE.CONDITION<FT6.DESCRIPTION,1,WLANG>
    END
    CALL F.READU(FN.REDO.TRANSACTION.CHAIN,WINITIAL.ID,R.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN,ERR.MSJ,RTR)
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID,-1>       = ID.NEW
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.DESC,-1>     = TRANSDESC
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.VERS,-1>     = APPLICATION:PGM.VERSION
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.CCY,-1>      = WTM.CCY
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.TYPE,-1>     = WTM.TYPE
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AMOUNT,-1>   = WTRAN.AMOUNT
    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.STATUS,-1>   = R.NEW(FT.RECORD.STATUS)
    IF NEXT.VERSION EQ "" THEN
        R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AUTH>   = "U"
    END
    IF R.NEW(FT.LOCAL.REF)<1,POS.CERT.CHEQUE.NO> THEN         ;* Changed
        GOSUB UPDATE.CHEQUE.NOS   ;* Changed
    END     ;* Changed

    GOSUB UPDATE.CHAIN.BALANCE
    WTM.FIRST.ID = R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID,1>
    CALL F.WRITE(FN.REDO.TRANSACTION.CHAIN,WINITIAL.ID,R.REDO.TRANSACTION.CHAIN)
*
RETURN
*
*--------------------
UPDATE.CHEQUE.NOS:
*--------------------
    Y.CHEQUE.NOS = R.NEW(FT.LOCAL.REF)<1,POS.CERT.CHEQUE.NO>
    CHANGE @SM TO @FM IN Y.CHEQUE.NOS
    CHANGE @VM TO @FM IN Y.CHEQUE.NOS
    Y.CNQ.CNT = DCOUNT(Y.CHEQUE.NOS,@FM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.CNQ.CNT
        Y.CHQ.ID = Y.CHEQUE.NOS<Y.VAR1>
        LOCATE Y.CHQ.ID IN R.REDO.TRANSACTION.CHAIN<RTC.CHEQUE.NO,1> SETTING RTC.POS ELSE
            R.REDO.TRANSACTION.CHAIN<RTC.CHEQUE.NO,-1>     = Y.CHQ.ID
            R.REDO.TRANSACTION.CHAIN<RTC.CHEQUE.STATUS,-1> = 'N'
        END

        Y.VAR1 += 1                  ;** R22 Auto conversion - ++ TO += 1
    REPEAT

RETURN
*--------------------
UPDATE.CHAIN.BALANCE:
* -------------------
*
* Updates BALANCE control fields in REDO.TRANSACTION.CHAIN table
*
    IF WTRAN.AMOUNT GT 0 THEN
        IF WTM.TYPE EQ "CASH" THEN
            R.REDO.TRANSACTION.CHAIN<RTC.TOTAL.CASH>   += WTRAN.AMOUNT
        END ELSE
            R.REDO.TRANSACTION.CHAIN<RTC.TOTAL.CHECK>  += WTRAN.AMOUNT
        END
    END
*
    IF WTM.TYPE EQ "CASH" THEN
        R.REDO.TRANSACTION.CHAIN<RTC.CASH.BALANCE>  += WTRAN.AMOUNT
    END ELSE
        R.REDO.TRANSACTION.CHAIN<RTC.CHECK.BALANCE> += WTRAN.AMOUNT
        IF R.REDO.TRANSACTION.CHAIN<RTC.CHECK.BALANCE> LT 0 THEN
            R.REDO.TRANSACTION.CHAIN<RTC.CASH.BALANCE> += R.REDO.TRANSACTION.CHAIN<RTC.CHECK.BALANCE>
            R.REDO.TRANSACTION.CHAIN<RTC.CHECK.BALANCE> = 0
        END
    END
*
    GOSUB UPDATE.CASHIER.BALANCES
*
RETURN
*
* ======================
UPDATE.CASHIER.BALANCES:
* ======================
*
* Updates REDO.TRANSACTION.CHAIN with OPERATOR balances after each transaction
*
    WVCCY     = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCCY>)
    WVALCASH  = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCASH>)
    WVALCHECK = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK>)
*
    R.REDO.TRANSACTION.CHAIN<RTC.CCY.INFO>   = WVCCY
    R.REDO.TRANSACTION.CHAIN<RTC.CASH.INFO>  = WVALCASH
    R.REDO.TRANSACTION.CHAIN<RTC.CHECK.INFO> = WVALCHECK
*
    CCY.BALANCE   = WVCCY
    CASH.BALANCE  = WVALCASH
    CHECK.BALANCE = WVALCHECK
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
        AF              = FT.DEBIT.AMOUNT
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
    PROCESS.GOAHEAD    = 1
*
    Y.ERR.MSG          = ""
*
    WLANG = R.USER<EB.USE.LANGUAGE>
*
    TRANSID  = R.NEW(FT.TRANSACTION.TYPE)
*

    WTT.ID              = System.getVariable("CURRENT.TID.ID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN                       ;** R22 Auto Conversion - Start
        WTT.ID = ""
    END                                                      ;** R22 Auto Conversion - End
    WTM.AUTOR.PROCESS   = System.getVariable("CURRENT.AUTOR.PROCESS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN                       ;** R22 Auto Conversion - Start
        WTM.AUTOR.PROCESS = ""
    END                                                      ;** R22 Auto Conversion - End
    WTM.PROC.AUTOR      = System.getVariable("CURRENT.PROC.AUTOR")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN                       ;** R22 Auto Conversion - Start
        WTM.PROC.AUTOR = ""
    END                                                      ;** R22 Auto Conversion - End

*
    FN.FT.TXN.TYPE.CONDITION = "F.FT.TXN.TYPE.CONDITION"
    F.FT.TXN.TYPE.CONDITION  = ""

    FN.REDO.TRANSACTION.CHAIN = "F.REDO.TRANSACTION.CHAIN"
    F.REDO.TRANSACTION.CHAIN  = ""

    FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER"
    F.FUNDS.TRANSFER  = ""

    FN.TELLER.ID = "F.TELLER.ID"
    F.TELLER.ID  = ""

    FN.REDO.MULTITXN.PARAMETER = 'F.REDO.MULTITXN.PARAMETER'
    F.REDO.MULTITXN.PARAMETER = ''

    FN.REDO.INIT.ID.NV = 'F.REDO.INIT.ID.NV'
    F.REDO.INIT.ID.NV = ''
    CALL OPF(FN.REDO.INIT.ID.NV,F.REDO.INIT.ID.NV)



*
    WAPP.LST = "TELLER.ID" : @FM : "FUNDS.TRANSFER"
    WCAMPO    = "L.INITIAL.ID"
    WCAMPO<2> = "L.CH.CASH"
    WCAMPO<3> = "L.CH.CHECK"
    WCAMPO<4> = "L.CH.CCY"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    WFLD.LST  = WCAMPO
    WCAMPO    = "L.NEXT.VERSION"
    WCAMPO<2> = "L.ACTUAL.VERSIO"
    WCAMPO<3> = "L.INITIAL.ID"
    WCAMPO<4> = "CERT.CHEQUE.NO"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    WFLD.LST := @FM : WCAMPO
    YPOS = ''
    CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)
    WPOSLI    = YPOS<1,1>
    WCASH     = YPOS<1,2>
    WCHECK    = YPOS<1,3>
    WCCY      = YPOS<1,4>
*
    WPOSNV    = YPOS<2,1>
    WPOSACV   = YPOS<2,2>
    WPOS.LI   = YPOS<2,3>
    POS.CERT.CHEQUE.NO = YPOS<2,4>
*
    NEXT.VERSION = R.NEW(FT.LOCAL.REF)<1,WPOSNV>

*IF PGM.VERSION MATCHES ',REDO.MULTI.AA.ACCRAP.UPD.TR':VM:',REDO.MULTI.AA.ACRP.UPD.TR':VM:',REDO.MULTI.AA.ACPOAP.TR' THEN      ;* Changed
    WTRAN.AMOUNT = R.NEW(FT.CREDIT.AMOUNT) * -1     ;* Changed
*END ELSE
*WTRAN.AMOUNT = R.NEW(FT.DEBIT.AMOUNT) * -1 ;* Changed
*END
    WRMP.ID           = "SYSTEM"          ;* Changed
    CALL CACHE.READ(FN.REDO.MULTITXN.PARAMETER,WRMP.ID,R.REDO.MULTITXN.PARAMETER,ERR.MSJ)   ;* Changed

*
RETURN
*
* ---------------
OPEN.FILES:
* ---------------
*
    CALL OPF(FN.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN)
    CALL OPF(FN.REDO.MULTITXN.PARAMETER,F.REDO.MULTITXN.PARAMETER)

*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
*DEBUG

    LOOP.CNT  = 1   ;   MAX.LOOPS = 2
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                CALL F.READ(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ)

                WINITIAL.ID  = R.TELLER.ID<TT.TID.LOCAL.REF,WPOSLI>
                IF (WINITIAL.ID EQ "" AND NEXT.VERSION EQ "") OR WTM.AUTOR.PROCESS EQ "A" OR WTM.PROC.AUTOR EQ "A" THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2

                CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION, TRANSID, R.FT.TXN.TYPE.CONDITION, ERR.MSJ)      ;** R22 Auto conversion - F TO CACHE

                WVCCY     = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCCY>))
                WVALCASH  = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCASH>))
                WVALCHECK = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK>))
                WTM.CCY   = R.NEW(FT.DEBIT.CURRENCY)

                IF R.FT.TXN.TYPE.CONDITION<FT6.TXN.CODE.DR> EQ R.REDO.MULTITXN.PARAMETER<RMP.CHECK.TRANSACT> THEN       ;* Changed
                    IF R.NEW(FT.LOCAL.REF)<1,POS.CERT.CHEQUE.NO> NE '' THEN
                        WTM.TYPE    = "CHECK"         ;* Changed
                    END ELSE
                        WTM.TYPE = "CASH"
                    END
                END ELSE      ;* Changed
                    WTM.TYPE = "CASH"     ;* Changed
                END ;* Changed

*WTM.TYPE  = "CASH"          ;* Changed

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
