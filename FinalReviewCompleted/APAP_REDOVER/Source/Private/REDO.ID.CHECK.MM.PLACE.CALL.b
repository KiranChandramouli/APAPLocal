* @ValidationCode : MjotMTY3OTYxMjMxOTpDcDEyNTI6MTY4MjQxMjMyOTM5NTpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:29
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
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*05-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*05-04-2023         Samaran T           Manual R22 Code Conversion         No Changes
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.ID.CHECK.MM.PLACE.CALL

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MM.MONEY.MARKET



    Y.CATEG = R.NEW(MM.CATEGORY)

    Y.MM.VALUE = 21076

    Y.RECORD.STATUS  = R.NEW(MM.RECORD.STATUS)
    IF Y.RECORD.STATUS NE '' THEN
        IF  Y.CATEG NE Y.MM.VALUE THEN
            E = 'EB-VERSION.DIFFERS'
            CALL STORE.END.ERROR
        END
    END


RETURN

END
