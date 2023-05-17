SUBROUTINE REDO.B.POLICY.AUTO.CANCEL.LOAD
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : HARISH Y
* Program Name  : REDO.B.POLICY.AUTO.CANCEL
*-------------------------------------------------------------------------

* Description :This routine will open all the files required
*              by the routine REDO.B.POLICY.AUTO.CANCEL

* In parameter : None
* out parameter : None

*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_REDO.B.POLICY.AUTO.CANCEL.COMMON

    GOSUB INIT
    GOSUB PROCESS

RETURN

***********
INIT:
***********

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.APAP.H.INSURANCE.DETAILS = 'F.APAP.H.INSURANCE.DETAILS'
    F.APAP.H.INSURANCE.DETAILS = ''
    CALL OPF(FN.APAP.H.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS)

    R.INS.DET = ''
RETURN
***********
PROCESS:
***********
RETURN
END
