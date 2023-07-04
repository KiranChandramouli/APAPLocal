* @ValidationCode : MjotMTAzMjE2ODE2ODpDcDEyNTI6MTY4MjQxMjM1ODk5NTpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.DATE.DE.INST
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.DATE.DE
* Attached as     : ROUTINE
* Primary Purpose : VALIDATE DATES FOR EXTERNAL DEPOSITS
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
* Development by  : Jorge Valarezo - TAM Latin America
* Date            :
*Modification history
*Date                Who               Reference                  Description
*19-04-2023      conversion tool     R22 Auto code conversion     VM TO @VM
*19-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS


RETURN  ;* Program RETURN
*------------------------------------------------------------------------------

PROCESS:
*======

    Y.FECHA.CREACION = R.NEW(COLL.VALUE.DATE)
    Y.INS.DATE = R.NEW(COLL.LOCAL.REF)<1,Y.POS.INST.DATE>

* CHECK THE DATE THAT NOT LOWER THAN THE ACTUAL DATE
    IF Y.FECHA.CREACION GT Y.INS.DATE THEN
        TEXT = 'EB.COL.INS.DATE'
        M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
        CALL STORE.OVERRIDE(M.CONT)
    END


RETURN
*------------------------------------------------------------------------

INITIALISE:
*=========


*Set the local fild for read

    WCAMPO     = "L.COL.INVST.DT"
    YPOS = 0

*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)
*Instrument Maturity Date.   - Fecha Vencimiento del Instrumento
    Y.POS.INST.DATE  = YPOS<1,1>

RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
