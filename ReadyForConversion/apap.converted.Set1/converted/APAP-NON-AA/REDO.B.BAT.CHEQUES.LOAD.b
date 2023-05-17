SUBROUTINE REDO.B.BAT.CHEQUES.LOAD
*------------------------------------------------------------------------------
*DESCRIPTION: This is load routine for the BATCH routine REDO.B.BAT.CHEQUES
*-------------------------------------------------------------------------------
* Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.B.BAT.CHEQUES.LOAD
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO              REFERENCE         DESCRIPTION
*19.05.2010       NATCHIMUTHU.P    ODR-2010-02-0001  INITIAL CREATION
*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.CLEARING.OUTWARD
    $INSERT I_F.TELLER
    $INSERT I_REDO.B.BAT.CHEQUES.COMMON
    $INSERT I_F.REDO.H.BAT.CHQ.DETAILS
*
    FN.LOCKING = 'F.LOCKING'
    FV.LOCKING  = ''
    CALL OPF(FN.LOCKING, FV.LOCKING)

    FN.REDO.H.CLEARING.OUTWARD='F.REDO.H.CLEARING.OUTWARD'
    F.REDO.H.CLEARING.OUTWARD=''
    CALL OPF(FN.REDO.H.CLEARING.OUTWARD,F.REDO.H.CLEARING.OUTWARD)

    FN.REDO.H.CLEARING.OUTWARD$HIS='F.REDO.H.CLEARING.OUTWARD$HIS'
    F.REDO.H.CLEARING.OUTWARD$HIS =''
    CALL OPF(FN.REDO.H.CLEARING.OUTWARD$HIS,F.REDO.H.CLEARING.OUTWARD$HIS)

    FN.REDO.H.BAT.CHQ.DETAILS = 'F.REDO.H.BAT.CHQ.DETAILS'
    F.REDO.H.BAT.CHQ.DETAILS  = ''
    CALL OPF(FN.REDO.H.BAT.CHQ.DETAILS, F.REDO.H.BAT.CHQ.DETAILS)

    FN.TELLER='F.TELLER'
    F.TELLER=''
    CALL OPF(FN.TELLER,F.TELLER)

RETURN
END
