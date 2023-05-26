* @ValidationCode : Mjo5MTI1NDAxNzc6Q3AxMjUyOjE2ODQ4NDIxNTQyOTY6SVRTUzotMTotMTotMjU6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -25
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE S.REDO.CCRG.GET.CUS.FIELD.VAL(R.CUSTOMER, P.FIELD.NAME, P.FIELD.VALUE, P.ERR.MSG)
*-----------------------------------------------------------------------------
* Get Customer, Field Value
* Description:
*            Allows to get "dinamically" the value of the field from CUSTOMER record
*            In case of Local Field, or MultiValue field, P.FIELD.VALUE will return
*            all the "values" into the field
*-----------------------------------------------------------------------------
* PARAMETERS:
*               R.CUSTOMER          (in)        Customer Record
*               P.FIELD.NAME        (in)        Field Name
*               P.FIELD.VALUE       (out)       Field value
*-----------------------------------------------------------------------------
* Modification History:
*                      2011-10-07 : hpasquel@temenos.com
*                                   First version
*REM Just for compile
*-----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*19-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*19-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.CUSTOMER
*----------------------------------------------------------------------------------

    COM /REDO.CCRG.GET.CUS.GET.VAL/REDO.SS.C$.CUSTOMER        ;* Standard Selection Record


    E = ''
    GOSUB INITIALISE
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
* it is a Core Field ?
    Y.FIELD.POS = 0
    ERR.MSG = ''
    YAF = ''
    YAV = ''
    YAS = ''
    DATA.TYPE = ''
    CALL FIELD.NAMES.TO.NUMBERS(P.FIELD.NAME, REDO.SS.C$.CUSTOMER, Y.FIELD.POS, YAF, YAV, YAS, DATA.TYPE, ERR.MSG)

    IF NOT(ERR.MSG) THEN
        P.FIELD.VALUE = R.CUSTOMER<Y.FIELD.POS>
        RETURN
    END

* try to find in Local Field
    GOSUB IS.LOCAL.FIELD
    IF Y.LOCAL.FIELD.POS THEN
        P.FIELD.VALUE = R.CUSTOMER<EB.CUS.LOCAL.REF, Y.LOCAL.FIELD.POS>
    END ELSE
        P.ERR.MSG = ERR.MSG
    END

RETURN


RETURN

*-----------------------------------------------------------------------------
IS.LOCAL.FIELD:
*-----------------------------------------------------------------------------

    Y.LOCAL.FIELD.POS = 0
    LOCATE P.FIELD.NAME IN REDO.SS.C$.CUSTOMER<SSL.SYS.FIELD.NAME,1> SETTING CPOS THEN
        USR.FIELD.VALUE   = REDO.SS.C$.CUSTOMER<SSL.SYS.FIELD.NO,CPOS,1>
        Y.ID.LOCREF.POSN  = FIELD(USR.FIELD.VALUE, ",", 2)
        Y.ID.LOCREF.POSN  = TRIM(FIELD(Y.ID.LOCREF.POSN, '>', 1))
        Y.LOCAL.FIELD.POS = Y.ID.LOCREF.POSN
    END


RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    IF NOT(REDO.SS.C$.CUSTOMER) THEN
        CALL GET.STANDARD.SELECTION.DETS('CUSTOMER', R.SS)
        REDO.SS.C$.CUSTOMER = R.SS
    END

RETURN
*-----------------------------------------------------------------------------
END
