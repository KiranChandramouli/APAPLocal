*--------------------------------------------------------------------------------------------------------
* <Rating>0</Rating>
*--------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.BRANCH.CARD.RETURN.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.DAMAGE.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Description  :*this is the authorisation routine to move the value of card numbers entered to old numbers so
*when user enters next time same user wll get a fresh screen
*Linked With  : Application REDO.BRANCH.CARD.RETURN.AUTHORISE
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 17 Apr 2011    Balagurunathan      ODR-2010-03-0400         Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.BRANCH.CARD.RETURN

***********************************************************************************************
  R.NEW(REDO.BRA.RTN.CARD.NUMBER.OLD)<1,-1> = R.NEW(REDO.BRA.RTN.CARD.NUMBER)
  R.NEW(REDO.BRA.RTN.DESCRIPTION.OLD)<1,-1> = R.NEW(REDO.BRA.RTN.DESCRIPTION)
  R.NEW(REDO.BRA.RTN.CARD.NUMBER)=''
  R.NEW(REDO.BRA.RTN.DESCRIPTION)=''
************************************************************************************************
  RETURN
END
