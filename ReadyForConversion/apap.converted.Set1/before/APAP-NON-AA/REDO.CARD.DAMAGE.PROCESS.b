*--------------------------------------------------------------------------------------------------------
* <Rating>-32</Rating>
*--------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.CARD.DAMAGE.PROCESS
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.DAMAGE.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a validation routine
*Linked With  : Application REDO.CARD.DAMAGE
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 29 Jul  2010    Mohammed Anies K      ODR-2010-03-0400         Initial Creation
* 6 Apr 2011      Kavitha               PACS00052984             Logic changed for multiple damage entry
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CARD.DAMAGE
$INSERT I_F.REDO.CARD.REQUEST
$INSERT I_F.REDO.CARD.NUMBERS
$INSERT I_F.REDO.STOCK.ENTRY
$INSERT I_F.REDO.STOCK.REGISTER

*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********


  GOSUB OPEN.PARA
  GOSUB PROCESS.PARA
  RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened


  FN.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
  F.CARD.REQUEST = ''
  CALL OPF(FN.CARD.REQUEST,F.CARD.REQUEST)

  FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
  F.REDO.CARD.NUMBERS = ''
  CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section



  CARD.SERIES = R.NEW(REDO.CARD.DAM.CARD.SERIES)

  CHANGE VM TO FM IN CARD.SERIES

  CARD.SERIES.CNT = DCOUNT(CARD.SERIES,FM)

  Y.INIT.SS.ID = 1
  LOOP
  WHILE Y.INIT.SS.ID LE CARD.SERIES.CNT

    EXISTING.CARD = ''
    DAM.CARD.NUMBER = ''

    DAM.CARD.NUMBER = R.NEW(REDO.CARD.DAM.CARD.NUMBER)<1,Y.INIT.SS.ID>
    TOT.DAM.LOS = DCOUNT(DAM.CARD.NUMBER,SM)
    EXISTING.CARD = R.NEW(REDO.CARD.DAM.TOT.LOST.DAMAGE)<1,Y.INIT.SS.ID>
    R.NEW(REDO.CARD.DAM.TOT.LOST.DAMAGE)<1,Y.INIT.SS.ID> =  TOT.DAM.LOS


    Y.INIT.SS.ID +=1
  REPEAT

  RETURN
*--------------------------------------------------------------------------------------------------------
END
