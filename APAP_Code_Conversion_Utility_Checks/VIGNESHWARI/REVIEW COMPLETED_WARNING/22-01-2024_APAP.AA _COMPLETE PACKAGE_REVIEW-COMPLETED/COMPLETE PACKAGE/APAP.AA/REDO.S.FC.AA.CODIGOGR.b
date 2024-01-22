* @ValidationCode : MjoxODExNTk2MDkyOkNwMTI1MjoxNzA0NDM4ODkwNTE0OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 12:44:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.AA
SUBROUTINE REDO.S.FC.AA.CODIGOGR(AA.ID, AA.ARR)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.FC.ENQPARMS
* Attached as     : ROUTINE
* Primary Purpose : Get the Id of the REDO.RISK.GROUP
*
* Incoming:
* ---------
*

*
* Outgoing:
* ---------
* AA.ARR - data returned to the routine
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres- TAM Latin America
* Date            : 9/26/2001
*
*
* Date             Who                   Reference      Description
* 30.03.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM
* 30.03.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*05-01-2024     VIGNESHWARI             Manual R22 Code Conversion -  OPF IS CALL
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
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


    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,Y.ERR.CUSTOMER)
    IF Y.ERR.CUSTOMER THEN
        AA.ARR = Y.ERR.CUSTOMER
        RETURN
    END ELSE
        AA.ARR = R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSUGRPRISK>
    END


RETURN
*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1

    FN.CUSTOMER="F.CUSTOMER"
    F.CUSTOMER=""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER) ;*Manual R22 Code Conversion -  OPF IS CALL
    Y.CUS.ID = AA.ID
    WCAMPOU = "L.CU.GRP.RIESGO"
    WCAMPOU = CHANGE(WCAMPOU,@FM,@VM)
    YPOSU=''
    CALL MULTI.GET.LOC.REF("CUSTOMER",WCAMPOU,YPOSU)
    WPOSUGRPRISK  = YPOSU<1,1>

RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
