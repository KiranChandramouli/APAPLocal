* @ValidationCode : Mjo3OTc4MDkyODk6Q3AxMjUyOjE2ODM4OTI2MjcwMjg6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:07
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.PAY.MON(Y.MONTH)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.GET.PAY.MON
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is a deal slip routine for FT and TT payment
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 3-JUN-2010        Prabhu.N       ODR-2010-01-0081    Initial Creation
** 10-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 10-04-2023 Skanda R22 Manual Conversion - line no 57
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.ACCOUNT

    FN.AA.BILL.DETAILS='F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS=''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

    FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS=''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    LREF.FIELD='L.NO.OF.INSTAL'
    LREF.APP  =APPLICATION
    LREF.POS=''

    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        VAR.AC.ID=R.NEW(FT.CREDIT.ACCT.NO)
        VAR.NO.OF.INSTALMENT=R.NEW(FT.LOCAL.REF)<1,LREF.POS>
    END
    IF APPLICATION EQ 'TELLER' THEN
        VAR.AC.ID=R.NEW(TT.TE.ACCOUNT.2)
        VAR.NO.OF.INSTALMENT=R.NEW(TT.TE.LOCAL.REF)<1,LREF.POS>
    END
    CALL F.READ(FN.ACCOUNT,VAR.AC.ID,R.ACCOUNT,F.ACCOUNT,ERR)
    VAR.AA.ID=R.ACCOUNT<AC.ARRANGEMENT.ID>
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,VAR.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ERR)
    VAR.BILL.LIST=R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    VAR.DATE.LIST=R.AA.ACCOUNT.DETAILS<AA.AD.BILL.DATE>
    VAR.SET.STATUS.LIST=R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
    CHANGE @VM TO @FM IN VAR.BILL.LIST
    CHANGE @SM TO @FM IN VAR.BILL.LIST
    CHANGE @VM TO @FM IN VAR.DATE.LIST
    CHANGE @SM TO @FM IN VAR.DATE.LIST
    CHANGE @VM TO @FM IN VAR.SET.STATUS.LIST
    CHANGE @SM TO @FM IN VAR.SET.STATUS.LIST
    VAR.BILL.SIZE=DCOUNT(VAR.BILL.LIST,@FM)
    FOR CNT=1 TO VAR.BILL.SIZE
        IF VAR.SET.STATUS.LIST<CNT> EQ 'REPAID' THEN
            VAR.MONTH.LIST<-1>=VAR.DATE.LIST<CNT>
        END
    NEXT CNT
    VAR.MONTH.SIZE=DCOUNT(VAR.MONTH.LIST,@FM)
    VAR.MONTH.LIST=SORT(VAR.MONTH.LIST)
    VAR.END.MONTH=VAR.MONTH.LIST<VAR.MONTH.SIZE>
    IF VAR.NO.OF.INSTALMENT GT 1 THEN
        VAR.START.MONTH=VAR.MONTH.LIST<VAR.MONTH.SIZE+1-VAR.NO.OF.INSTALMENT>
    END
    VAR.START.MONTH=OCONV(VAR.START.MONTH,'DI')
    VAR.END.MONTH  =OCONV(VAR.END.MONTH,'DI')
    VAR.START.MONTH=OCONV(VAR.START.MONTH,'DMA')
    VAR.END.MONTH  =OCONV(VAR.END.MONTH,'DMA')
    IF VAR.END.MONTH EQ VAR.START.MONTH THEN
        VAR.START.MONTH=''
    END
    IF  VAR.START.MONTH NE '' THEN
        VAR.START.MONTH=VAR.START.MONTH:'-'
    END
    Y.MONTH=VAR.START.MONTH:VAR.END.MONTH
RETURN
END
