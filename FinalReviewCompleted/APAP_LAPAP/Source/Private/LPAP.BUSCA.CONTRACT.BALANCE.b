* @ValidationCode : MjotMTQ0NjY5MTQ4OkNwMTI1MjoxNjg0MjIyODE5NzUzOklUU1M6LTE6LTE6MTk4OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 198
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LPAP.BUSCA.CONTRACT.BALANCE
*--------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED,I TO T.VAR
*24-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*---------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON    ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_ENQUIRY.COMMON    ;*R22 AUTO CODE CONVERSION.END

    Y.CB.ID = O.DATA

    FN.CB = "F.EB.CONTRACT.BALANCES"
    FV.CB = ""

    CALL OPF (FN.CB, FV.CB)
    Y.CB.ID = O.DATA
*Y.CB.ID = 1012313204
    R.CB = ""; CB.ERROR = ""
*variable para retornal el balance pendiete
    Y.TOTAL.AMT = 0
    Y.TO.OPEN = 0
    Y.CREDIT.AMT = 0
    Y.DEBIT.AMT = 0
    Y.SUMA.AMT = 0
    CALL F.READ(FN.CB, Y.CB.ID, R.CB, FV.CB, CB.ERROR)

    Y.TYPE.CB =  R.CB<ECB.TYPE.SYSDATE>

    Y.CNT = DCOUNT(Y.TYPE.CB,@VM)
    Y.CB.ACCOUN.TYPE = ""
    FOR I.VAR = 1 TO Y.CNT
        Y.CB.ACCOUN.TYPE = R.CB<ECB.TYPE.SYSDATE,I.VAR>

        FINDSTR "ACCOUNT" IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN

            Y.TO.OPEN = R.CB<ECB.OPEN.BALANCE,I.VAR,1>
            Y.CREDIT.AMT = R.CB<ECB.CREDIT.MVMT,I.VAR,1>
            Y.DEBIT.AMT = R.CB<ECB.DEBIT.MVMT,I.VAR,1>
            Y.SUMA.AMT = Y.TO.OPEN + Y.CREDIT.AMT + Y.DEBIT.AMT
            Y.TOTAL.AMT += Y.SUMA.AMT

        END

    NEXT I.VAR
    O.DATA =  ABS(Y.TOTAL.AMT)

RETURN

END
