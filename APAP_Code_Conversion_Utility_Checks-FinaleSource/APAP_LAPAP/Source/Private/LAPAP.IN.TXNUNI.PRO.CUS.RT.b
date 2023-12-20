* @ValidationCode : MjotMTE3MzIzMTExNTpDcDEyNTI6MTY5MTY2NjI1NDcxMzpJVFNTOi0xOi0xOjE5MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Aug 2023 16:47:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 190
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.IN.TXNUNI.PRO.CUS.RT
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*09/08/2023      Suresh                     R22 Manual Conversion          T24.BP is removed
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Manual Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER ;*R22 Manual Conversion - End

    GOSUB DO.LOAD.VARS
    GOSUB DO.READ.ACC

RETURN

DO.LOAD.VARS:
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    Y.ACC.ID = R.NEW(FT.DEBIT.ACCT.NO)
RETURN

DO.READ.ACC:

    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACC,F.ACCOUNT,ACC.ERR)

    IF (R.ACC) THEN
        Y.CUST.ID = R.ACC<AC.CUSTOMER>
        R.NEW(FT.PROFIT.CENTRE.CUST) = Y.CUST.ID
    END

RETURN

END

