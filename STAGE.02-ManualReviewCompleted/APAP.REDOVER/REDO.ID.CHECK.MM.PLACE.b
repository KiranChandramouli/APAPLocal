* @ValidationCode : MjoxNTk4OTkzODU2OkNwMTI1MjoxNjgwNjkwMTE1MDAzOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:51:55
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
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*05-04-2023       Conversion Tool        R22 Auto Code conversion          VM TO @VM
*05-04-2023         Samaran T           Manual R22 Code Conversion         No Changes
*----------------------------------------------------------------------------------------------
SUBROUTINE REDO.ID.CHECK.MM.PLACE

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MM.MONEY.MARKET



    Y.CATEG = R.NEW(MM.CATEGORY)

    Y.MM.VALUE = 21077:@VM:21078:@VM:21079:@VM:21080

    Y.RECORD.STATUS  = R.NEW(MM.RECORD.STATUS)
    IF Y.RECORD.STATUS NE '' THEN
        IF Y.CATEG MATCHES Y.MM.VALUE THEN
        END ELSE
            E = 'EB-VERSION.DIFFERS'
            CALL STORE.END.ERROR
        END
    END



RETURN

END
