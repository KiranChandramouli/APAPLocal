* @ValidationCode : Mjo3Mjg2NDUyMjA6Q3AxMjUyOjE2ODI0MTIzNDkyMDg6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.CHECK.TXN.PAY
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Sakthi Sellappillai
*Program   Name    :REDO.V.INP.CHECK.TXN.PAY
*Developed for     :ODR-2010-08-0031
*---------------------------------------------------------------------------------

*DESCRIPTION       : This routine is for Raising Override Message if overpayment is breached
*
*LINKED WITH       :  FUNDS.TRANSFER,AA.AC.PRIN.REPAY
*----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date            who                       Reference                      Description
*=========          ==========                ==============                ============
* 11-10-2010      Sakthi Sellappillai       ODR-2010-08-0031               Initial Creation
*11-04-2023       Conversion Tool           R22 Auto Code conversion          VM TO @VM
*11-04-2023       Samaran T                  R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.OVERRIDE
*Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*Tus End



    GOSUB INITIALISE
    GOSUB OPENFILE
    GOSUB PROCESS
    GOSUB GOEND
RETURN
*-----------------------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------------------
    LOC.APPLICATION='FUNDS.TRANSFER'
    LOC.FIELDS='L.FT.MAX.AMOUNT':@VM:'L.FT.MIN.AMOUNT':@VM:'L.FT.MAX.TIME':@VM:'L.FT.MIN.TIME':@VM:'L.FT.OVRDUE.AMT'
    LOC.POS=''

RETURN
*-----------------------------------------------------------------------------------------
OPENFILE:
*-----------------------------------------------------------------------------------------
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

RETURN
*-----------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------
*Getting the Local fields position

    CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS)

    L.FT.MAX.AMOUNT.POS=LOC.POS<1,1>
    L.FT.MIN.AMOUNT.POS=LOC.POS<1,2>
    L.FT.MAX.TIME.POS=LOC.POS<1,3>
    L.FT.MIN.TIME.POS=LOC.POS<1,4>
    L.FT.OVRDUE.AMT.POS=LOC.POS<1,5>

*Checking for Application

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB PROCESSFT
    END
RETURN
*-----------------------------------------------------------------------------------------
PROCESSFT:
*-----------------------------------------------------------------------------------------
* process for FUNDS.TRANSFER

    DEBIT.ACCT.NO=R.NEW(FT.DEBIT.ACCT.NO)
    CREDIT.AMOUNT=R.NEW(FT.CREDIT.AMOUNT)
    CHARGE.AMT=R.NEW(FT.CHARGE.AMT)
    COMMISSION.AMT=R.NEW(FT.COMMISSION.AMT)
    TAX.AMT=R.NEW(FT.TAX.AMT)

    CALL F.READ(FN.ACCOUNT,DEBIT.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    R.ECB= '' ; ECB.ERR= '' ;*Tus Start
    CALL EB.READ.HVT("EB.CONTRACT.BALANCES",DEBIT.ACCT.NO,R.ECB,ECB.ERR)
* ONLINE.ACTUAL.BALANCE=R.ACCOUNT<AC.ONLINE.ACTUAL.BAL>
    ONLINE.ACTUAL.BALANCE=R.ECB<ECB.ONLINE.ACTUAL.BAL>;*Tus End

    TOTAL.AMOUNT=ONLINE.ACTUAL.BALANCE+COMMISSION.AMT+TAX.AMT+CHARGE.AMT
    IF TOTAL.AMOUNT LT CREDIT.AMOUNT THEN
        ETEXT='FT-INSUFFICIENT.BAL'
        AF=FT.CREDIT.AMOUNT
        CALL STORE.END.ERROR
    END

    L.FT.MAX.AMOUNT.VAL=R.NEW(FT.LOCAL.REF)<1,L.FT.MAX.AMOUNT.POS>
    IF CREDIT.AMOUNT GT L.FT.MAX.AMOUNT.VAL THEN
        ETEXT='FT-VERIFY.AMOUNT'
        AF=FT.CREDIT.AMOUNT
        CALL STORE.END.ERROR
    END

    L.FT.MIN.AMOUNT.VAL=R.NEW(FT.LOCAL.REF)<1,L.FT.MIN.AMOUNT.POS>
    IF CREDIT.AMOUNT LT L.FT.MIN.AMOUNT.VAL THEN
        ETEXT='FT-VERIFY.AMOUNT'
        AF=FT.CREDIT.AMOUNT
        CALL STORE.END.ERROR
    END

    CREDIT.ACCOUNT=R.NEW(FT.CREDIT.ACCT.NO)
    SEL.CMD="SELECT ":FN.AA.ARRANGEMENT :" WITH LINKED.APPL.ID EQ ": CREDIT.ACCOUNT
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,DATA.ERR)
    AA.ARRANGEMENT.ID=SEL.LIST
    CALL F.READ(FN.AA.ARRANGEMENT,AA.ARRANGEMENT.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    AA.ARRANGEMENT.START.DATE=R.AA.ARRANGEMENT<AA.ARR.START.DATE>
    CREDIT.VALUE.DATE=R.NEW(FT.CREDIT.VALUE.DATE)

    Y.NO.OF.DAYS = 'C'
    IF AA.ARRANGEMENT.START.DATE AND CREDIT.VALUE.DATE THEN
        CALL CDD('', AA.ARRANGEMENT.START.DATE, CREDIT.VALUE.DATE, DIF.CREDIT.VALUE.DATE)
    END ELSE
        Y.NO.OF.DAYS = 0
    END


    L.FT.MAX.TIME.VAL=R.NEW(FT.LOCAL.REF)<1,L.FT.MAX.TIME.POS>
    L.FT.MIN.TIME.VAL=R.NEW(FT.LOCAL.REF)<1,L.FT.MIN.TIME.POS>

    IF DIF.CREDIT.VALUE.DATE GT L.FT.MAX.TIME.VAL  THEN
        ETEXT='FT-VERIFY.DATE'
        AF=FT.CREDIT.VALUE.DATE
        CALL STORE.END.ERROR
    END
    IF DIF.CREDIT.VALUE.DATE LT L.FT.MIN.TIME.VAL  THEN
        ETEXT='FT-VERIFY.DATE'
        AF=FT.CREDIT.VALUE.DATE
        CALL STORE.END.ERROR
    END
RETURN
*-----------------------------------------------------------------------------------------
GOEND:
*-----------------------------------------------------------------------------------------
END
*------------------------------------*END OF SUBROUTINE*----------------------------------
