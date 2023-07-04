* @ValidationCode : MjotMTQ2MTYyMzI5MDpDcDEyNTI6MTY4NDgzNjAzNDA4NzpJVFNTOi0xOi0xOjE4NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 186
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.B.UPD.OUTS.PRINC.LOAD
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.APAP.B.UPD.OUTS.PRINC.LOAD

*--------------------------------------------------------

*DESCRIBTION: REDO.APAP.B.UPD.OUTS.PRINC.LOAD is the load
* routine to load all the variables required for the process

*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.APAP.B.UPD.OUTS.PRINC

* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*06.08.2010 H GANESH ODR-2009-10-0346 INITIAL CREATION
* Date                  who                   Reference              
* 04-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 04-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES

*--------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.APAP.B.UPD.OUTS.PRINC.COMMON



    GOSUB PROCESS
    GOSUB MULTI.GET.REF
RETURN

*-----------------------------------------------------------
PROCESS:
*-----------------------------------------------------------
    FN.REDO.APAP.MORTGAGES.DETAIL='F.REDO.APAP.MORTGAGES.DETAIL'
    F.REDO.APAP.MORTGAGES.DETAIL=''
    CALL OPF(FN.REDO.APAP.MORTGAGES.DETAIL,F.REDO.APAP.MORTGAGES.DETAIL)

    FN.REDO.APAP.CPH.DETAIL='F.REDO.APAP.CPH.DETAIL'
    F.REDO.APAP.CPH.DETAIL=''
    CALL OPF(FN.REDO.APAP.CPH.DETAIL,F.REDO.APAP.CPH.DETAIL)


RETURN
*-----------------------------------------------------------
MULTI.GET.REF:
*-----------------------------------------------------------
    LOC.REF.APPLICATION="AA.PRD.DES.OVERDUE"
    LOC.REF.FIELDS='L.LOAN.STATUS.1'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.L.LOAN.STATUS.1=LOC.REF.POS<1,1>


RETURN

END
