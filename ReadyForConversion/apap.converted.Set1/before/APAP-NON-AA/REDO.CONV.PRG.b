*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.PRG
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: NATCHIMUTHU.P
* PROGRAM NAME: REDO.CONV.PRG
* ODR NO      : ODR-2010-02-001
*----------------------------------------------------------------------
*DESCRIPTION: Conversion routine for the Enquiry REDO.H.CHK.BAT.BY.TELLER
*
*IN PARAMETER:NONE
*OUT PARAMETER:NONE
*
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE              WHO                      REFERENCE         DESCRIPTION
*19.02.2010       NATCHIMUTHU.P            ODR-2010-02-0001  INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_TEST.COMMON
*-----------------------------------------------------------------------
  O.DATA = DUMMY(3)
  IF FLAG=0 THEN
    CALL JOURNAL.UPDATE('')
  END ELSE
    FLAG=1
  END
  RETURN
END
