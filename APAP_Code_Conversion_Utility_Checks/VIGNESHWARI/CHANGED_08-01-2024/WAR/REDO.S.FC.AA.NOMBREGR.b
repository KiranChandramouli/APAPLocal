* @ValidationCode : MjoxMzQ3NDA4NzAyOkNwMTI1MjoxNzA0NDM5OTkxMDg0OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 13:03:11
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

SUBROUTINE  REDO.S.FC.AA.NOMBREGR(AA.ID, AA.ARR)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.FC.ENQPARMS
* Attached as     : ROUTINE
* Primary Purpose : Get the value of RISK.GRP.DESC
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
* Date             Who                   Reference      Description
* 30.03.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, FM TO @FM
* 30.03.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*05-01-2024         VIGNESHWARI          R22            MANUAL CODE CONVERSION OPF IS CALL
*-----------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.RISK.GROUP




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
        Y.RISK = R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSUGRPRISK>
    END

    CALL F.READ(FN.REDO.RISK.GROUP,Y.RISK,R.REDO.RISK.GROUP,F.REDO.RISK.GROUP,Y.ERR.RISK.GROUP)

    IF Y.ERR.RISK.GROUP THEN
        AA.ARR = Y.ERR.RISK.GROUP
        RETURN
    END ELSE
        AA.ARR = R.REDO.RISK.GROUP<RG.RISK.GRP.DESC>
    END



RETURN
*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1

    FN.CUSTOMER="F.CUSTOMER"
    F.CUSTOMER=""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER) ;*R22 MANUAL CODE CONVERSION-OPF IS CALL
    Y.CUS.ID = AA.ID
    WCAMPOU = "L.CU.GRP.RIESGO"
    WCAMPOU = CHANGE(WCAMPOU,@FM,@VM)      ;** R22 Auto conversion - FM TO @FM, VM TO @VM
    YPOSU=''
    CALL MULTI.GET.LOC.REF("CUSTOMER",WCAMPOU,YPOSU)
    WPOSUGRPRISK  = YPOSU<1,1>

    FN.REDO.RISK.GROUP="F.REDO.RISK.GROUP"
    F.REDO.RISK.GROUP=""
    CALL OPF(FN.REDO.RISK.GROUP,F.REDO.RISK.GROUP) ;*R22 MANUAL CODE CONVERSION-OPF IS CALL

RETURN
*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
