* @ValidationCode : MjotMTk5NzEzMjI4OkNwMTI1MjoxNjg0MjIyODE2MDY4OklUU1M6LTE6LTE6MjAwOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.TOTAL.AZ
*--------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*21-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON   ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.ENQUIRY
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AZ.ACCOUNT      ;*R22 AUTO CODE CONVERSION.END

    FN.AZ.ACCOUNT = "F.AZ.ACCOUNT"
    F.AZ.ACCOUNT = ""
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    Y.CUSTOMER = O.DATA

    SELECT.STATEMENT = "SELECT " :FN.AZ.ACCOUNT : " WITH CUSTOMER EQ " :Y.CUSTOMER

    Y.REDO.CERTI.LIST = ''
    LIST.ACCOUNT = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''

    CALL EB.READLIST(SELECT.STATEMENT,Y.REDO.CERTI.LIST,LIST.ACCOUNT,SELECTED,SYSTEM.RETURN.CODE)

    LOOP
        REMOVE Y.ID FROM Y.REDO.CERTI.LIST SETTING POS
    WHILE Y.ID:POS

        CALL F.READ(FN.AZ.ACCOUNT, Y.ID, R.REDO.CERTI.LIST,F.AZ.ACCOUNT, Y.ERR)
        Y.MONTO = R.REDO.CERTI.LIST<AZ.PRINCIPAL>
        Y.MONTO.TOTAL += Y.MONTO
    REPEAT

    O.DATA = Y.MONTO.TOTAL
RETURN

END
