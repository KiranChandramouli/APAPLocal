*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BLD.TELLER.SEL(ENQ.DATA)
*----------------------------------------------------------------------------
* Description:
***************
*
* This build routine should be attached to the ENQUIRY REDO.BAT.CHQ.TODAY to
* list all entries posted during the day by the present logged in TELLER
*
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NATCHIMUTHU.P
* PROGRAM NAME : REDO.E.BLD.TELLER.SEL
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 15.07.2010      NATCHIMUTHU.P  ODR-2010-02-0001    INITIAL CREATION
* -----------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_TT.COMMON
$INSERT I_F.REDO.H.BAT.CHQ.DETAILS
$INSERT I_F.TELLER

  GOSUB INIT
  GOSUB PROCESS
  RETURN
******
INIT:
******
  FN.TELLER.USER = 'F.TELLER.USER'
  F.TELLER.USER  = ''
  CALL OPF(FN.TELLER.USER, F.TELLER.USER)
  RETURN
***********
PROCESS:
**********
  Y.USER.NAME=OPERATOR
  CALL F.READ(FN.TELLER.USER,Y.USER.NAME,R.REC,F.TELLER.USER,Y.ERR)
  P.TELLER.ID=R.REC

  LOCATE "TELLER.ID" IN ENQ.DATA<2,1> SETTING TELLER.ID.POS ELSE
    NULL
  END
  Y.TELLER.ID = ENQ.DATA<4,TELLER.ID.POS>

  ENQ.DATA<2,1>='TELLER.ID'
  ENQ.DATA<3,TELLER.ID.POS>='EQ'
  ENQ.DATA<4,TELLER.ID.POS>=P.TELLER.ID
  RETURN
END
*---------------------------------------------------------------------------------------------------
* END
*------------------------------------------------------------------------ ---------------------------
