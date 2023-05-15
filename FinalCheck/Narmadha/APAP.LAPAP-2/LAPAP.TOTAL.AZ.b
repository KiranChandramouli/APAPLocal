* @ValidationCode : MjotMTk5NzEzMjI4OkNwMTI1MjoxNjgyMDcwMTMzMjE3OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 15:12:13
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
