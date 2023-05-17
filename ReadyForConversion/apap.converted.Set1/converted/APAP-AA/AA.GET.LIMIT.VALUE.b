SUBROUTINE AA.GET.LIMIT.VALUE

***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: AA.GET.LIMIT.VALUE
*----------------------------------------------------------------------

* DESCRIPTION: This routine is an ACTIVITY API Pre routine which will be executed
* when putting arrangements for AA Loan Contracts. This Routine is used to get the
* value from the Property Class LIMIT for the Field Limit Reference
* This Routine should have a Valid Entry in PGM.FILE and EB.API

*
* IN PARAMETER: NONE
* OUT PARAMETER: NONE
* LINKED WITH: ACTIVITY.API
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.LIMIT


    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------
    Y.LIMIT.REF = ''
RETURN

*---------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------

    Y.LIMIT.REF=R.NEW(AA.LIM.LIMIT.REFERENCE)
    C$SPARE(500)=Y.LIMIT.REF
RETURN
END
