* @ValidationCode : MjoyODk2MTE1NDU6Q3AxMjUyOjE2ODEyMTUyMDY1NDc6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 17:43:26
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
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.FR.COMP.CHARGE
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This Input routine is used to validate if the charge acquired
* from the account holds sufficient balance
*
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RENUGADEVI B
* PROGRAM NAME : REDO.V.INP.CLAIM.CHARGE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 25-AUG-2010       RENUGADEVI B       ODR-2009-12-0283  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*11-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM, F.READ TO CACHE.READ, ++ TO +=1
*11-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*---------------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.REDO.FRONT.COMPLAINTS
    $INSERT I_F.EB.CONTRACT.BALANCES                ;*TUS S/E

    GOSUB INIT
    GOSUB PROCESS
RETURN

*****
INIT:
*****

*
    FN.ACCOUNT              = 'F.ACCOUNT'
    F.ACCOUNT               = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.FT.COMMISSION.TYPE   = 'F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE    = ''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

RETURN

********
PROCESS:
********
    Y.ACCT.ID         = R.NEW(FR.CM.ACCOUNT.ID)
    Y.OPEN.CHANNEL    = R.NEW(FR.CM.OPENING.CHANNEL)
    Y.CHARGE          = R.NEW(FR.CM.CHARGE.KEY)

    CALL F.READ(FN.ACCOUNT, Y.ACCT.ID, R.ACCOUNT, F.ACCOUNT, ACC.ERR)
    CALL EB.READ.HVT ('EB.CONTRACT.BALANCES',Y.ACCT.ID, R.ECB, ECB.ERR)        ;*TUS START
    IF Y.ACCT.ID THEN
        Y.CURR        = R.ACCOUNT<AC.CURRENCY>
*Y.AMOUNT      = R.ACCOUNT<AC.WORKING.BALANCE>
        Y.AMOUNT      = R.ECB<ECB.WORKING.BALANCE>                ;*TUS END
    END

    CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.CHARGE, R.FT.COMMISSION.TYPE, CHAR.ERR)    ;*R22 AUTO CODE CONVERSION
    GOSUB CHARGE.CALCULATE

    IF Y.AMOUNT LT Y.FLAT.AMOUNT AND R.NEW(FR.CM.PRODUCT.TYPE) NE 'OTROS' THEN
        AF    = FR.CM.ACCOUNT.ID
        ETEXT = 'EB-INSUFFICIENT.FUNDS'
        CALL STORE.END.ERROR
    END
RETURN

*****************
CHARGE.CALCULATE:
*****************

    IF R.FT.COMMISSION.TYPE THEN
        Y.COM.CURR    = R.FT.COMMISSION.TYPE<FT4.CURRENCY>
        CHANGE @VM TO @FM IN Y.COM.CURR
        Y.COUNT   = DCOUNT(Y.COM.CURR,@FM)
        CNT           = 1

        LOOP
        WHILE CNT LE Y.COUNT
            Y.FLAT.AMOUNT = R.FT.COMMISSION.TYPE<FT4.FLAT.AMT, CNT>
            CNT += 1
        REPEAT
    END
RETURN
END
