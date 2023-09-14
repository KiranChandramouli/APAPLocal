* @ValidationCode : MjotMTQ0NjY5MTQ4OkNwMTI1MjoxNjgyMzE2MTAzNzkxOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 11:31:43
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
