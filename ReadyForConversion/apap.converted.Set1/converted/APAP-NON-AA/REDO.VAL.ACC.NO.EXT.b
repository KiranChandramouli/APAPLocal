SUBROUTINE REDO.VAL.ACC.NO.EXT
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.VAL.ACC.NO.EXT
* ODR NO      : ODR-2010-08-0469
*----------------------------------------------------------------------
*DESCRIPTION: This routine is an internal call routine called by the Batch routine REDO.VISA.GEN.ACQ.REC
*IN PARAMETER : N/A
*OUT PARAMETER: N/A
*CALLED BY : REDO.VISA.GEN.ACQ.REC
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*15.09.2010  S SUDHARSANAN    ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.VISA.GEN.ACQ.REC.COMMON
    $INSERT I_F.ATM.REVERSAL
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
    Y.ATM.ID = FIELD(ATM.ID,'.',1)
    LEN.ATM.ID = LEN(Y.ATM.ID)
    IF LEN.ATM.ID GT 16 THEN
        FIELD.VALUE = Y.ATM.ID[17,3]
    END ELSE
        FIELD.VALUE = 0
    END
RETURN
*-------------------------------------------------------------------------------
END
