SUBROUTINE REDO.B.BAT.CHEQUES.SELECT
*------------------------------------------------------------------------------
*DESCRIPTION: This is SELECT routine for the BATCH routine REDO.B.BAT.CHEQUES
*-------------------------------------------------------------------------------
* Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.B.BAT.CHEQUES.SELECT
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE            WHO               REFERENCE         DESCRIPTION
*19.05.2010      NATCHIMUTHU.P    ODR-2010-02-0001   INITIAL CREATION
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.CLEARING.OUTWARD
    $INSERT I_F.TELLER
    $INSERT I_F.LOCKING
    $INSERT I_REDO.B.BAT.CHEQUES.COMMON

    SEL.CMD="SELECT ":FN.REDO.H.CLEARING.OUTWARD:" WITH TRANSFER EQ READY"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
