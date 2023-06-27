* @ValidationCode : Mjo3MzIxNDY0MjE6Q3AxMjUyOjE2ODI0MTIzNjI2MTM6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:02
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
SUBROUTINE REDO.V.VAL.MAXVAL
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.MAXVAL
* Attached as     : ROUTINE
* Primary Purpose :
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
*------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            :
*
*------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*17-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN

*-----------------------------------------------------------------------------
PROCESS:
*======
*
*
    IF Y.COL.EXE.VAL GT Y.COL.LN.MXVA THEN
        R.NEW(COLL.MAXIMUM.VALUE) = Y.COL.EXE.VAL
    END
*
RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
*
*Valor Maximo a Prestar
    WCAMPO     = "L.COL.LN.MX.VAL"
    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    YPOS=0
*
*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)
*
    WPOSEXED  = YPOS<1,1>

    Y.COL.EXE.VAL = ''
    Y.COL.EXE.VAL = COMI
    Y.COL.LN.MXVA = R.NEW(COLL.LOCAL.REF)<1,WPOSEXED>
*
RETURN

*---------------------------------------------------------------------------
OPEN.FILES:
*=========

RETURN
*---------------------------------------------------------------------------
END
