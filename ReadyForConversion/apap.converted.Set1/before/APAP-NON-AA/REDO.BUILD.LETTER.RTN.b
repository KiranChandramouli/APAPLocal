*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.BUILD.LETTER.RTN(ENQ.DATA)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.BUILD.LETTER.RTN
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is a Build Routine for a NOFILE Enquiry REDO.NOFILE.AUDIT.ENQ



*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*18.03.2010  H GANESH     ODR-2009-10-0838   INITIAL CREATION
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ENQUIRY
$INSERT I_F.REDO.LETTER.ISSUE


  GOSUB INIT
  RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

  POS1= DCOUNT(ENQ.DATA<2,1>,VM)

  Y.LETTER.TYPE=R.NEW(REDO.LET.ISS.TYPE.OF.LETTER)

  Y.CUSTOMER.ID = R.NEW(REDO.LET.ISS.CUSTOMER.ID)

  IF NOT(POS1) THEN
    POS1 = 1
  END

  ENQ.DATA<2,POS1>='CUSTOMER'
  ENQ.DATA<3,POS1>='EQ'
  ENQ.DATA<4,POS1>= Y.CUSTOMER.ID

  ENQ.DATA<2,POS1+1>='LETTER.TYPE'
  ENQ.DATA<3,POS1+1>='EQ'
  ENQ.DATA<4,POS1+1>= Y.LETTER.TYPE

  RETURN

END
