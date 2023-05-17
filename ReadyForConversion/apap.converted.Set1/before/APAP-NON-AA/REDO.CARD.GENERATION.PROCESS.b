*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CARD.GENERATION.PROCESS


*DESCRIPTIONS:
*-------------
* This is  input routine of REDO.CARD.GENERATION to update the REDO.CARD.REQUEST with CARD GENERATION REQUEST RAISED
* It contains the table definitions
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*

* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who                    Reference             Description
*  21 Apr 2011   Balagurunathan            PACS00052986          TO update REDO.CARD.REQUEST with value Yes in SENT.CRD.GEN.REQ
*-----------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CARD.REQUEST

  FN.REDO.CARD.REQUEST='F.REDO.CARD.REQUEST'
  F.REDO.CARD.REQUEST=''
  CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

  CALL F.READ(FN.REDO.CARD.REQUEST,ID.NEW,R.REDO.CARD.REQUEST,FN.REDO.CARD.REQUEST,ERR)

  R.REDO.CARD.REQUEST<REDO.CARD.REQ.SENT.CRD.GEN.REQ>='YES'

  CALL F.WRITE(FN.REDO.CARD.REQUEST,ID.NEW,R.REDO.CARD.REQUEST)

  RETURN

END
