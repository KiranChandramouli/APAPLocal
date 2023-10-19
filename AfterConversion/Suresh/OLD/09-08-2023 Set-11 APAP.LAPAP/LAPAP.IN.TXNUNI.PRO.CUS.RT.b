$PACKAGE APAP.LAPAP
* @ValidationCode : MjotMjA0NjA0NzE1NTpDcDEyNTI6MTY5MTU2NDU0MTE5MTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Aug 2023 12:32:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

SUBROUTINE LAPAP.IN.TXNUNI.PRO.CUS.RT
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*09/08/2023      Suresh                     R22 Manual Conversion          T24.BP is removed
*----------------------------------------------------------------------------------------
    $INSERT  I_COMMON ;*R22 Manual Conversion - Start
    $INSERT  I_EQUATE
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.FUNDS.TRANSFER ;*R22 Manual Conversion - End

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

