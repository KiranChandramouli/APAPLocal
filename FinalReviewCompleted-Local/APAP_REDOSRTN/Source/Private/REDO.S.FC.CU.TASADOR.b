* @ValidationCode : MjotMTU2MDYwMTA3NjpDcDEyNTI6MTY4MjQxNTE0MTIyNDpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 15:02:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.FC.CU.TASADOR(CU.ID, CU.ARR)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value SI/NO It despends if the client exist or not in REDO.VALUATOR.NAME app
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* CU.ARR - data returned to the routine
*
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            :
*Modification history
*Date                Who               Reference                  Description
*06-04-2023      conversion tool     R22 Auto code conversion     No changes
*06-04-2023      Mohanraj R          R22 Manual code conversion   No changes

*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
    LOC.REF.APPL="CUSTOMER"
    LOC.REF.FIELDS="L.CU.CIDENT"
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    Y.POS = LOC.REF.POS<1,1>
    Y.L.CU.CIDENT  = CU.ARR<EB.CUS.LOCAL.REF,Y.POS>

    CALL F.READ(FN.REDO.VALUATOR.NAME,Y.L.CU.CIDENT,R.REDO.VALUATOR.NAME,F.REDO.VALUATOR.NAME,"")

    IF R.REDO.VALUATOR.NAME THEN
        CU.ARR = 'SI'
    END ELSE
        CU.ARR = 'NO'
    END
RETURN
*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    FN.REDO.VALUATOR.NAME = 'F.REDO.VALUATOR.NAME'
    F.REDO.VALUATOR.NAME  = ''
    R.REDO.VALUATOR.NAME  = ''

RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.REDO.VALUATOR.NAME,F.REDO.VALUATOR.NAME)

RETURN
*------------
END
