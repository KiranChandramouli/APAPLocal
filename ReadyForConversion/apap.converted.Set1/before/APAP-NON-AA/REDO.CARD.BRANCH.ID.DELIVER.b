*--------------------------------------------------------------------------------------------------------
* <Rating>0</Rating>
*--------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.CARD.BRANCH.ID.DELIVER
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.BRANCH.ID.DELIVER
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to avoid "delivered to branch" status if the cards have not been generated yet
*Linked With  : REDO.CARD.REQUEST
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 1 DEC 2010    SWAMINATHAN       ODR-2010-03-0400        Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.REDO.CARD.GENERATION

  FN.REDO.CARD.GENERATION = 'F.REDO.CARD.GENERATION'
  F.REDO.CARD.GENERATION = ''
  CALL OPF(FN.REDO.CARD.GENERATION,F.REDO.CARD.GENERATION)
  R.REDO.CARD.GENERATION = ''
  Y.CARD.REQ.ID = ID.NEW
  CALL F.READ(FN.REDO.CARD.GENERATION,Y.CARD.REQ.ID,R.REDO.CARD.GENERATION,F.REDO.CARD.GENERATION,Y.ERR.GEN)
  IF R.REDO.CARD.GENERATION EQ '' THEN
    E='EB-CARD.DELI.TO.BRANCH'
  END
  RETURN
END
