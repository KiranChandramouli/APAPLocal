*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.UPD.LATAM.CARD.SERIES
*-----------------------------------------------------------------------------
* DESCRIPTION
*-----------
* This is a routine will be called by CARD.ISSUE,SBP during authorization
*
*-------------------------------------------------------------------------------------
* This subroutine caters the following task :-
* This routine will update the LATAM.CARD.ORDER application when a changes made is CARD.ISSUE start no
* table through OFS
*-----------------------------------------------------------------------------------------
* Input / Output
* --------------
* IN     : -na-
* OUT    : -na-
* Dependencies
* ------------
*
*-------------------------------------------------------------------------------------------
* Revision History
*-------------------------
*    Date             Who               Reference       Description
*  20-Apr-2011   Balagurunathan           TDN4            Initial Draft
*___________________________________________________________________________________________

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CARD.ISSUE
$INSERT I_F.LATAM.CARD.ORDER

  FN.LATAM.CARD.ORDER='F.LATAM.CARD.ORDER'
  F.LATAM.CARD.ORDER=''
  CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)

  CALL F.READU(FN.LATAM.CARD.ORDER,ID.NEW,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,ERR,'P')

  R.LATAM.CARD.ORDER<CARD.IS.CARD.START.NO>=R.NEW(CARD.IS.CARD.START.NO)

  CALL F.WRITE(FN.LATAM.CARD.ORDER,ID.NEW,R.LATAM.CARD.ORDER)

  RETURN

END
