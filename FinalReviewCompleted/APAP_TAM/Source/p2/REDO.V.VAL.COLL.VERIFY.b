* @ValidationCode : MjotMTA3MTYxMzQyMjpDcDEyNTI6MTY4NDQ5MTA0NTcxNTpJVFNTOi0xOi0xOi0yODoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -28
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.V.VAL.COLL.VERIFY

*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.COLL.VERIFY
* Attached as     : ROUTINE
* Primary Purpose : CHANGE STATE COLLATERAL TO CANCELLED
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            :
**DATE           WHO                 REFERENCE               DESCRIPTION
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM, FM TO @FM
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL


    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
*Get the values for the local fields (Granting Date)
    Y.ESTADO = R.NEW(COLL.LOCAL.REF)<1,WPOESTA>

    R.NEW(COLL.LOCAL.REF)<1,WPOESTA> = 'CANCELLED'

RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
    Y.ESTADO = ''
    PROCESS.GOAHEAD = 1

*Set the local fild for read
    WCAMPO     = "L.COL.SEC.STA"

    WCAMPO = CHANGE(WCAMPO,@FM,@VM) ;*R22 AUTO CONVERSION
    YPOS=0

*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)

    WPOESTA  = YPOS<1,1>

*Get the values for the local fields (Granting Date)
    Y.ESTADO = R.NEW(COLL.LOCAL.REF)<1,WPOESTA>

RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------

END
