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
