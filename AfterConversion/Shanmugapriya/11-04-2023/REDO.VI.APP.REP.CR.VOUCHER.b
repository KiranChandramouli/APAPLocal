* @ValidationCode : MjozMTUyMjIwNTc6Q3AxMjUyOjE2ODExODk5OTU3NDY6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 10:43:15
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
SUBROUTINE REDO.VI.APP.REP.CR.VOUCHER
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :Balagurunathan
*  Program   Name    :REDO.VI.APPROVE.CR.VOUCHER
***********************************************************************************
*Description: This routine is to settle the transaction when it is approved manually
*             This is a version routine attached to VERSION REDO.VISA.SETTLEMENT.05TO37,APPROVE as
*             input routine
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*23.05.2012   Balagurunathan  ODR-2010-08-0469  INITIAL CREATION
*11.04.2023   Conversion Tool    R22            Auto Conversion     - FM TO @FM, VM TO @VM, F TO CACHE
*11.04.2023   Shanmugapriya M    R22            Manual Conversion   - No changes
*
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CURRENCY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_F.REDO.VISA.OUTGOING
    $INSERT I_F.REDO.MERCHANT.CATEG
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_F.REDO.VISA.STLMT.05TO37
    $INSERT I_F.REDO.VISA.STLMT.PARAM


    GOSUB INIT
    GOSUB GET.LOCAL.REF
    GOSUB PROCESS
RETURN

*****
INIT:
******

    TRANSACTION.ID = ''
    PROCESS = ''
    GTSMODE  =''
    OFSRECORD  = ''
    OFS.MSG.ID = ''
    OFS.ERR = ''
    OFS.STRING = ''
    OFS.ERR = ''

    FN.ATM.REVERSAL = 'F.ATM.REVERSAL'
    F.ATM.REVERSAL  =''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

    FN.ACCOUNT ='F.ACCOUNT'
    F.ACCOUNT =''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.MERCHANT.CATEG='F.REDO.MERCHANT.CATEG'
    F.REDO.MERCHANT.CATEG=''
    CALL OPF(FN.REDO.MERCHANT.CATEG,F.REDO.MERCHANT.CATEG)

    FN.AC.LOCKED.EVENTS='F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS=''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    FN.REDO.APAP.H.PARAMETER='F.REDO.APAP.H.PARAMETER'
    FN.REDO.VISA.STLMT.PARAM='F.REDO.VISA.STLMT.PARAM'

    FN.FT.TXN.TYPE.CONDITION='F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.CONDITION=''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

    FN.REDO.APAP.H.PARAMETER='F.REDO.APAP.H.PARAMETER'
    CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,'SYSTEM',R.REDO.APAP.H.PARAMETER,PARAMETER.ERROR)
    FN.AC.LOCKED.EVENTS='F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS=''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)
RETURN

PROCESS:

    CARD.NUMBER=R.NEW(VISA.SETTLE.ACCOUNT.NUMBER)
    CARD.NUM.EXT=R.NEW(VISA.SETTLE.ACCT.NUM.EXT)

    IF CARD.NUM.EXT EQ 0 THEN
        CARD.NUMBER = R.NEW(VISA.SETTLE.ACCOUNT.NUMBER)
    END ELSE
        CARD.NUMBER = CARD.NUMBER:FMT(CARD.NUM.EXT,"R0%3")
    END

    ATM.REV.ID=CARD.NUMBER:'.':R.NEW(VISA.SETTLE.AUTH.CODE)
    CALL F.READ(FN.ATM.REVERSAL,ATM.REV.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.REVERSAL.ERR)

    IF R.ATM.REVERSAL EQ '' THEN
        ETEXT = "EB-NO.TXN.DETAILS"
        CALL STORE.END.ERROR
        RETURN
    END

*   IF R.ATM.REVERSAL<AT.REV.TXN.REF> EQ '' OR R.ATM.REVERSAL<AT.REV.TXN.REF>[1,4] EQ 'ACLK' THEN
*       ETEXT = 'EB-UN.SETTLED.TXN'
*       CALL STORE.END.ERROR
*   END

    IF R.NEW(VISA.SETTLE.CARD.ACCEPTOR.ID)[15,1] NE 'P' THEN

        GOSUB NEXT.PROCESS

    END ELSE

        GOSUB TXN.CERITOS.PTS
    END


RETURN



*-----------------------------------------------------------------------
GET.LOCAL.REF:
*-----------------------------------------------------------------------
    LOC.REF.APPLICATION="FUNDS.TRANSFER":@FM:"ACCOUNT"
    LOC.REF.FIELDS='AT.UNIQUE.ID':@VM:'POS.COND':@VM:'BIN.NO':@VM:'AT.AUTH.CODE':@VM:'ATM.TERM.ID':@VM:'L.STLMT.ID':@VM:'L.STLMT.APPL':@FM:'L.AC.AV.BAL'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.AT.UNIQUE.ID=LOC.REF.POS<1,1>
    POS.POS.COND=LOC.REF.POS<1,2>
    POS.BIN.NO=LOC.REF.POS<1,3>
    POS.AT.AUTH.CODE=LOC.REF.POS<1,4>
    POS.ATM.TERM.ID=LOC.REF.POS<1,5>
    POS.STLMT.ID=LOC.REF.POS<1,6>
    POS.STLMT.APPL=LOC.REF.POS<1,7>
    POS.L.AC.AV.BAL=LOC.REF.POS<2,1>

RETURN
**************
NEXT.PROCESS:
**************
    Y.FTTC.ID=R.ATM.REVERSAL<AT.REV.FTTC.ID>
    CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION, Y.FTTC.ID, R.FT.TXN.TYPE.CONDITION, Y.ERR)       ;** R22 Auto conversion - F TO CACHE


    TXN.ID=R.ATM.REVERSAL<AT.REV.TXN.REF>


*FT6.COMM.TYPES
*FT6.CHARGE.TYPES
    Y.COMM=R.FT.TXN.TYPE.CONDITION<FT6.COMM.TYPES>
    Y.CHG=R.FT.TXN.TYPE.CONDITION<FT6.CHARGE.TYPES>

    Y.CCY.CODE= R.NEW(VISA.SETTLE.DEST.CCY.CODE)
    Y.TXN.AMT=R.NEW(VISA.SETTLE.DEST.AMT)


    IF Y.CCY.CODE AND Y.CCY.CODE NE '214' THEN


        DEAL.CURRENCY='USD'
        DEAL.AMOUNT=  Y.TXN.AMT

        CCY.MARKET=R.FT.TXN.TYPE.CONDITION<FT6.DEFAULT.DEAL.MKT>


    END ELSE


        DEAL.CURRENCY='DOP'
        DEAL.AMOUNT=  Y.TXN.AMT



    END


    Y.TC.CODE=R.NEW(VISA.SETTLE.TRANSACTION.CODE)

*FT.DEBIT.ACCT.NO
*FT.DEBIT.CURRENCY
*FT.CREDIT.ACCT.NO
*FT.CREDIT.CURRENCY
*FT.CREDIT.AMOUNT
*FT.DEBIT.AMOUNT


    Y.TC.CODE.REP=Y.TC.CODE:'2'

    LOCATE Y.TC.CODE.REP IN R.REDO.APAP.H.PARAMETER<PARAM.TC.CODE,1> SETTING POS THEN
        IF Y.CCY.CODE AND Y.CCY.CODE NE '214' THEN
            DR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.FOR.DR.ACCT,POS>
            CR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.FOR.CR.ACCT,POS>
        END ELSE
            DR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.DR.ACCT,POS>
            CR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.CR.ACCT,POS>
        END

    END


    BEGIN CASE

        CASE  Y.TC.CODE EQ 26

            R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>=R.ATM.REVERSAL<AT.REV.ACCOUNT.NUMBER>    ;*DR ACCOUNT IS CUSTOMER ACCOUNT
            R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>=DR.ACCT
            R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>=DEAL.CURRENCY
            R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>=Y.TXN.AMT

        CASE Y.TC.CODE EQ '06' OR Y.TC.CODE EQ '25' OR Y.TC.CODE EQ '27'

            R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>=CR.ACCT
            R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>=R.ATM.REVERSAL<AT.REV.ACCOUNT.NUMBER>
            R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>=DEAL.CURRENCY
            R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>=Y.TXN.AMT

        CASE OTHERWISE


    END CASE
    R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>=R.ATM.REVERSAL<AT.REV.FTTC.ID>
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.AT.UNIQUE.ID>=ATM.REV.ID
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.POS.COND>=R.ATM.REVERSAL<AT.REV.POS.COND>
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.BIN.NO>=CARD.NUMBER[1,6]
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.AT.AUTH.CODE>=FIELD(ATM.REV.ID,'.',2)
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.ATM.TERM.ID>=R.NEW(VISA.SETTLE.TERMINAL.ID)
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.STLMT.ID>=ID.NEW
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.STLMT.APPL>="REDO.VISA.STLMT.05TO37"

    APP.NAME = 'FUNDS.TRANSFER'
    OFSVERSION = "FUNDS.TRANSFER,VOUCHER"
    OFSFUNCT = 'I'
    OFS.SOURCE.ID = 'REDO.VISA.OUTGOING'
    NO.OF.AUTH = '0'

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.FUNDS.TRANSFER,OFS.STRING)


    OFS.STRING.FINAL = OFS.STRING
    CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)




RETURN

****************
TXN.CERITOS.PTS:
****************

*    Y.FTTC.ID=R.ATM.REVERSAL<AT.REV.FTTC.ID>
*    CALL F.READ(FN.FT.TXN.TYPE.CONDITION,Y.FTTC.ID,R.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION,Y.ERR)


    TXN.ID=R.ATM.REVERSAL<AT.REV.TXN.REF>


*FT6.COMM.TYPES
*FT6.CHARGE.TYPES
*    Y.COMM=R.FT.TXN.TYPE.CONDITION<FT6.COMM.TYPES>
*    Y.CHG=R.FT.TXN.TYPE.CONDITION<FT6.CHARGE.TYPES>

    Y.CCY.CODE= R.NEW(VISA.SETTLE.DEST.CCY.CODE)
    Y.TXN.AMT = R.NEW(VISA.SETTLE.DEST.AMT)


    IF Y.CCY.CODE AND Y.CCY.CODE NE '214' THEN


        DEAL.CURRENCY='USD'
        DEAL.AMOUNT=  Y.TXN.AMT

*        CCY.MARKET=R.FT.TXN.TYPE.CONDITION<FT6.DEFAULT.DEAL.MKT>


    END ELSE


        DEAL.CURRENCY='DOP'
        DEAL.AMOUNT=  Y.TXN.AMT



    END


    Y.TC.CODE=R.NEW(VISA.SETTLE.TRANSACTION.CODE)

*FT.DEBIT.ACCT.NO
*FT.DEBIT.CURRENCY
*FT.CREDIT.ACCT.NO
*FT.CREDIT.CURRENCY
*FT.CREDIT.AMOUNT
*FT.DEBIT.AMOUNT


    Y.TC.CODE=Y.TC.CODE:'2'
    LOCATE Y.TC.CODE : "P" IN R.REDO.APAP.H.PARAMETER<PARAM.TC.CODE,1> SETTING POS THEN
        IF Y.CCY.CODE EQ '214' THEN
            DR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.DR.ACCT,POS>
            CR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.CR.ACCT,POS>
        END ELSE
            DR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.FOR.DR.ACCT,POS>
            CR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.FOR.CR.ACCT,POS>
        END
        Y.VERSION=R.REDO.APAP.H.PARAMETER<PARAM.FT.VERSION,POS>
    END



    R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>=DR.ACCT
    R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>=CR.ACCT
    R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>=DEAL.CURRENCY
    R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>=Y.TXN.AMT


    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.AT.UNIQUE.ID>=ATM.REV.ID
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.POS.COND>=R.ATM.REVERSAL<AT.REV.POS.COND>
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.BIN.NO>=CARD.NUMBER[1,6]
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.AT.AUTH.CODE>=FIELD(ATM.REV.ID,'.',2)
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.ATM.TERM.ID>=R.NEW(VISA.SETTLE.TERMINAL.ID)
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.STLMT.ID>=ID.NEW
    R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.STLMT.APPL>="REDO.VISA.STLMT.05TO37"

    APP.NAME = 'FUNDS.TRANSFER'
    OFSVERSION = "FUNDS.TRANSFER,VOUCHER"
    OFSFUNCT = 'I'
    OFS.SOURCE.ID = Y.VERSION
    NO.OF.AUTH = '0'

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.FUNDS.TRANSFER,OFS.STRING)


    OFS.STRING.FINAL = OFS.STRING
    CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)




RETURN



END
