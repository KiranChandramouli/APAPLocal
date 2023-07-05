* @ValidationCode : Mjo4Nzc2NTkwNzU6Q3AxMjUyOjE2ODg0NTM1ODE0MzE6SVRTUzE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Jul 2023 12:23:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------
* <Rating>-141</Rating>
*----------------------------------------------------------------------------
SUBROUTINE REDO.V.INP.AML.FT.CHK
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S & GANESH R
* Program Name  : REDO.V.INP.AML.FT.CHK
* ODR NUMBER    : ODR-2009-10-0472 (FIX FOR HD1054079(PACS00023982) & HD1053862 (PACS00023968) )
*-------------------------------------------------------------------------

* Description : This i/p routine is triggered when FT transaction is made
* In parameter : None
* out parameter : None
*--------------------------------------------------------------------------------
*MODIFICATION HISTORY:
* DATE        WHO                REFERENCE        DESCRIPTION
* 15-04-11    RIYAS              PACS00023989     REMOVE THE CONDITION OF CHECK TRANSACTION CODE IN IN STATEMENT
* 08-10-13    Vignesh Kumaar R   PACS00306796     Commented the RTE forms
* 16-12-14    Vignesh Kumaar R   PACS00392651     AA OVERPAYMENT THROUGH CASH/CHEQUE
* 28.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 28.04.2023       Shanmugapriya M       R22            Manual Conversion   - FM TO @FM, VM TO @VM
* 03-07-2023       Narmadha V                       Manual R22 Conversion     Commented insert file, commented variable regarding I_F.T24.FUND.SERVICES file
*                                                                             IMPACT- Field validation on TFS and TOT.TODAY.TXN.AMT amount calculation will empact
*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TRANSACTION
    $INSERT I_F.CURRENCY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.REDO.AML.PARAM
    $INSERT I_F.DEAL.SLIP.FORMAT
    $INSERT I_DEAL.SLIP.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.OVERRIDE
    $INSERT I_RC.COMMON
    $INSERT I_F.VERSION
* $INSERT I_F.T24.FUND.SERVICES ;* Manual R22 Conversion- Commnted insert file
    $INSERT I_F.REDO.AA.OVERPAYMENT ;*

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------------------
*****
INIT:
*****


* OFS$DEAL.SLIP.PRINTING = 1
    V$FUNCTION = "I"
    SAVE.APPLICATION = APPLICATION

RETURN

**********
OPEN.FILES:
*Opening Files

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT=''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.FTTC='F.FT.TXN.TYPE.CONDITION'
    F.FTTC=''
    CALL OPF(FN.FTTC,F.FTTC)

    FN.TRANSACTION='F.TRANSACTION'
    F.TRANSACTION=''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FN.CURRENCY='F.CURRENCY'
    F.CURRENCY=''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

    FN.ACCT.ENT.TODAY='F.ACCT.ENT.TODAY'
    F.ACCT.ENT.TODAY=''
    CALL OPF(FN.ACCT.ENT.TODAY,F.ACCT.ENT.TODAY)

    FN.STMT.ENTRY='F.STMT.ENTRY'
    F.STMT.ENTRY=''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.STMT.ENTRY.DETAIL='F.STMT.ENTRY.DETAIL'
    F.STMT.ENTRY.DETAIL=''
    CALL OPF(FN.STMT.ENTRY.DETAIL,F.STMT.ENTRY.DETAIL)

    FN.REDO.AML.PARAM='F.REDO.AML.PARAM'
    F.REDO.AML.PARAM=''
    CALL OPF(FN.REDO.AML.PARAM,F.REDO.AML.PARAM)

    FN.OVERRIDE='F.OVERRIDE'
    F.OVERRIDE=''
    CALL OPF(FN.OVERRIDE,F.OVERRIDE)

    FN.T24.FUND.SERVICES = 'F.T24.FUND.SERVICES'
    F.T24.FUND.SERVICES = ''
    CALL OPF(FN.T24.FUND.SERVICES,F.T24.FUND.SERVICES)

* Fix for PACS00392651 [AA OVERPAYMENT THROUGH CASH/CHEQUE]

    FN.REDO.AA.OVERPAYMENT = 'F.REDO.AA.OVERPAYMENT'
    F.REDO.AA.OVERPAYMENT = ''
    CALL OPF(FN.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT)

* End of Fix

    LRF.APP='TRANSACTION':@FM:'CURRENCY':@FM:'FUNDS.TRANSFER'
    LRF.FIELD='L.TR.AML.CHECK':@FM:'L.CU.AMLBUY.RT':@FM:'L.RTE.FORM':@VM:'L.ACT.INT':@VM:'L.NATIONALITY': @VM : 'L.PEP.INTERM' : @VM :'L.TYPE.PEP.INT'
    LRF.POS=''
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)

    POS.L.TR.AML.CHECK=LRF.POS<1,1>
    POS.L.CU.AMLBUY.RT=LRF.POS<2,1>
    POS.L.RTE.FORM=LRF.POS<3,1>
* ///////// Intermediary set fields //
* PACS00371128 - 20140826 - S
    POS.FT.ACT.INT = LRF.POS<3,2>
    POS.FT.NATIONA = LRF.POS<3,3>
* PACS00371128 - 20140826 - E
    POS.FT.INT     = LRF.POS<3,4>
    POS.FT.NAT     = LRF.POS<3,5>
* ////////////////////////////////////
    POS.FT.INTERM = LRF.POS<3,6>
    POS.FT.TYPE = LRF.POS<3,7>

RETURN
*-------------------------------------------
PROCESS:
*-------------------------------------------

**Checks for the currency and raise the overrides by calling the STORE.OVERRIDE and produce DEAL SLIP

    FT.TXN.CODE=R.NEW(FT.TRANSACTION.TYPE)
    FT.TXN.CCY=R.NEW(FT.CREDIT.CURRENCY)
    FT.TXN.AMT=R.NEW(FT.DEBIT.AMOUNT)
    IF FT.TXN.AMT EQ '' THEN
        FT.TXN.AMT = R.NEW(FT.CREDIT.AMOUNT)
    END
    FT.ACCT.NO=R.NEW(FT.CREDIT.ACCT.NO)
    FT.ACCT.DT.NO=R.NEW(FT.DEBIT.ACCT.NO)

*****READ TRANSACTION TABLE*****
    R.TRANSACTION=''
    TRANS.ERR=''
    CALL F.READ(FN.FTTC,FT.TXN.CODE,R.FTTC,F.FTTC,ERR.FTTC)
    FT.TXN.CODE.ID=R.FTTC<FT6.TXN.CODE.DR>

    CALL F.READ(FN.TRANSACTION,FT.TXN.CODE.ID,R.TRANSACTION,F.TRANSACTION,TRANS.ERR)
    FT.TR.AML.CHECK=R.TRANSACTION<AC.TRA.LOCAL.REF><1,POS.L.TR.AML.CHECK>
    IF FT.TR.AML.CHECK EQ 'Y' THEN
        GOSUB PROCESS1
    END
RETURN

*********
PROCESS1:

*Raising the Override
    TOT.TODAY.TXN.AMT=FT.TXN.AMT
    FT.LCCY=LCCY
    IF FT.TXN.CCY NE FT.LCCY THEN
        CALL F.READ(FN.CURRENCY,FT.TXN.CCY,R.CURRENCY,F.CURRENCY,CURR.ERR)
        CUR.AMLBUY.RATE=R.CURRENCY<EB.CUR.LOCAL.REF,POS.L.CU.AMLBUY.RT>
        TOT.TODAY.TXN.AMT=FT.TXN.AMT*CUR.AMLBUY.RATE
    END
    CALL F.READ(FN.ACCOUNT,FT.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    CUS.ACC.ID=R.ACCOUNT<AC.CUSTOMER>
    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUS.ACC.ID,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,CUS.ACC.ERR)
    GOSUB PROCESS2
    Y.PARAM.ID='SYSTEM'
    CALL CACHE.READ(FN.REDO.AML.PARAM,Y.PARAM.ID,R.AML.PARAM,AML.ERR)
    Y.AMT.LIMIT.LCY=R.AML.PARAM<AML.PARAM.AMT.LIMIT.LCY>
    TOT.TODAY.TXN.AMT = FIELD(TOT.TODAY.TXN.AMT,'.',1)
    Y.AMT.LIMIT.LCY = FIELD(Y.AMT.LIMIT.LCY,'.',1)

    GOSUB GET.OVERPYMT.AMOUNT   ;* Fix for PACS00392651
    TOT.TODAY.TXN.AMT += Y.GET.OVER.PAY.AMT

    IF TOT.TODAY.TXN.AMT GE Y.AMT.LIMIT.LCY THEN
* CURR.NO=DCOUNT(R.NEW(FT.OVERRIDE),VM) + 1
        CURR.NO = ''
        TEXT='AML.TXN.AMT.EXCEED'
        CALL STORE.OVERRIDE(CURR.NO)

    END
    GOSUB PROCESS3
RETURN


*------------------*
GET.OVERPYMT.AMOUNT:
*------------------*
* Fix for PACS00392651 [AA OVERPAYMENT THROUGH CASH/CHEQUE]

    Y.GET.OVER.PAY.AMT = 0
    SEL.CMD.OVER = ''
    SEL.LIST.OVER = ''

    SEL.CMD.OVER = 'SELECT ':FN.REDO.AA.OVERPAYMENT:' WITH @ID LIKE ':CUS.ACC.ID:'.':TODAY:'... AND PAYMENT.METHOD EQ CASH AND STATUS NE REVERSADO'
    CALL EB.READLIST(SEL.CMD.OVER,SEL.LIST.OVER,'','',SEL.ERR)
    LOOP
        REMOVE OVER.ID FROM SEL.LIST.OVER SETTING OVER.POS
    WHILE OVER.ID:OVER.POS
        CALL F.READ(FN.REDO.AA.OVERPAYMENT,OVER.ID,R.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT,REDO.AA.OVERPAYMENT.ERR)
        Y.GET.OVER.PAY.AMT += R.REDO.AA.OVERPAYMENT<REDO.OVER.AMOUNT>

    REPEAT
RETURN



PROCESS3:

*Checking for Overrides

    VAR.OVERRIDE.ID='AML.TXN.AMT.EXCEED'
    CALL F.READ(FN.OVERRIDE,VAR.OVERRIDE.ID,R.OVERRIDE,F.OVERRIDE,ERR.MSG)

* Getting the Override Message

    VAR.MESSAGE1=R.OVERRIDE<EB.OR.MESSAGE>
    VAR.MESSAGE2='YES'

*Getting the Override Message Values

    VAR.OFS.OVERRIDE1=OFS$OVERRIDES<1>
    VAR.OFS.OVERRIDE2=OFS$OVERRIDES<2>

*Converting to FM for locate Purpose

    CHANGE @VM TO @FM IN VAR.OFS.OVERRIDE1
    CHANGE @VM TO @FM IN VAR.OFS.OVERRIDE2
    GOSUB PROCESS4
RETURN

PROCESS4:
*Checking for the override Message
    LOCATE VAR.MESSAGE1 IN VAR.OFS.OVERRIDE1 SETTING POS1 ELSE
        POS1 = ''
    END
    LOCATE VAR.MESSAGE2 IN VAR.OFS.OVERRIDE2 SETTING POS2 ELSE
        POS2 = ''
    END

*Setting the local reference Field Value
    IF POS1 THEN
        R.NEW(FT.LOCAL.REF)<1,POS.L.RTE.FORM>='YES'
    END

*Generating the Deal Slip
    VAR.RTE.CHK=R.NEW(FT.LOCAL.REF)<1,POS.L.RTE.FORM>
*    IF VAR.RTE.CHK EQ 'YES' AND POS2 NE '' THEN
*        OFS$DEAL.SLIP.PRINTING = 1
*        OFS$DEAL.SLIP.PRINTING = ''
*        CALL PRODUCE.DEAL.SLIP('AML.FT.RTE.FORM')
*        GOSUB GET.HOLD.ID
*        CALL REDO.V.AUT.RTE.REPRINT(Y.HID)
*        PRT.ADVICED.PRODUCED = ""
*    END

RETURN

*----------------------------
PROCESS2:
*-----------------------------
*Gets the total and gives the amount for raising the Overrides

    LOOP
        REMOVE Y.ACC.ID FROM R.CUSTOMER.ACCOUNT SETTING Y.POS
    WHILE Y.ACC.ID:Y.POS
        CALL F.READ(FN.ACCT.ENT.TODAY,Y.ACC.ID,R.ACCT.ENT.TODAY,F.ACCT.ENT.TODAY,ACCT.ENT.ERR)
        LOOP
            REMOVE Y.STMT.ENTRY FROM R.ACCT.ENT.TODAY SETTING Y.STMT.POS
        WHILE Y.STMT.ENTRY:Y.STMT.POS
            CALL F.READ(FN.STMT.ENTRY,Y.STMT.ENTRY,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ERR)
            IF R.STMT.ENTRY EQ '' THEN
                CALL F.READ(FN.STMT.ENTRY.DETAIL,Y.STMT.ENTRY,R.STMT.ENTRY,F.STMT.ENTRY.DETAIL,STMT.ERR)
            END
            STMT.TXN.CODE=R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
            STMT.VAL.DATE=R.STMT.ENTRY<AC.STE.VALUE.DATE>
            GOSUB TOT.AMT
        REPEAT
    REPEAT
RETURN
*-------
TOT.AMT:
*-------
*S-PACS00023989
    R.TRANSACTION = ''; TRANS.ERR = '' ; TT.TR.AML.CHECK = ''
    CALL F.READ(FN.TRANSACTION,STMT.TXN.CODE,R.TRANSACTION,F.TRANSACTION,TRANS.ERR)
    TT.TR.AML.CHECK=R.TRANSACTION<AC.TRA.LOCAL.REF><1,POS.L.TR.AML.CHECK>
    IF TT.TR.AML.CHECK EQ 'Y' THEN
        IF STMT.VAL.DATE EQ TODAY THEN
            CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
            CURR.VAL = R.ACCOUNT<AC.CURRENCY>
            IF CURR.VAL EQ LCCY THEN
                STMT.TXN.AMT=R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
                TOT.TODAY.TXN.AMT+=STMT.TXN.AMT
            END ELSE
                STMT.TXN.AMT=R.STMT.ENTRY<AC.STE.AMOUNT.FCY>
                FT.TXN.CCY = CURR.VAL
                TOT.TODAY.TXN.AMT+=CUR.AMLBUY.RATE*STMT.TXN.AMT
            END
        END
    END ELSE
        GET.TFS.ID = R.STMT.ENTRY<AC.STE.THEIR.REFERENCE>
        GOSUB GET.TFS.TOTAL
    END

*E-PACS00023989
RETURN


*-----------------------------------------------------------------------------------------------------------------------
GET.TFS.TOTAL:
*-----------------------------------------------------------------------------------------------------------------------

    IF GET.TFS.ID[1,5] EQ 'T24FS' THEN
        CALL F.READ(FN.T24.FUND.SERVICES,GET.TFS.ID,R.T24.FUND.SERVICES,F.T24.FUND.SERVICES,TFS.ERR)

        LOCATE GET.TFS.ID IN Y.TFS.LIST SETTING POS THEN
            RETURN
        END
        Y.TFS.LIST <-1> = GET.TFS.ID
*        Y.TFS.TXN.CODES = R.T24.FUND.SERVICES<TFS.TRANSACTION> ;* Manual R22 conversion - insert file commented
        Y.TFS.TXN.COUNT = DCOUNT(Y.TFS.TXN.CODES,@VM)
        Y.TFS.COUNT = 1

        LOOP
        WHILE Y.TFS.COUNT LE Y.TFS.TXN.COUNT
            TFS.TRANSACTION.ID = Y.TFS.TXN.CODES<1,Y.TFS.COUNT>

            IF TFS.TRANSACTION.ID EQ 'CASHDEPD' THEN

*                TOT.TODAY.TXN.AMT += R.T24.FUND.SERVICES<TFS.AMOUNT,Y.TFS.COUNT> ;* Manual R22 conversion - insert file commented

            END
            Y.TFS.COUNT++
        REPEAT
    END
RETURN

*
* ==========
GET.HOLD.ID:
* ==========
    Y.HID = C$LAST.HOLD.ID
*
RETURN
*---------------------------------------------------------------------
