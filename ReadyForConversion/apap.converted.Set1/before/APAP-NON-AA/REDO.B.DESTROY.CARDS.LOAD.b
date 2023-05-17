*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.DESTROY.CARDS.LOAD
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This load routine initialises and opens necessary files
*  and gets the position of the local reference fields
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who             Reference            Description
* 02-AUG-2010     S.R.SWAMINATHAN   ODR-2010-03-0400      Initial Creation
*---------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.DESTROY.CARDS.COMMON
$INSERT I_GTS.COMMON
$INSERT I_F.REDO.CARD.DES.HIS
$INSERT I_F.REDO.CARD.GENERATION
$INSERT I_F.REDO.CARD.NUMBERS
$INSERT I_BATCH.FILES
$INSERT I_F.DATES
$INSERT I_F.REDO.CARD.NO.LOCK

  GOSUB INIT
  GOSUB OPEN.FILE

  RETURN

*----
INIT:
*----
*-------------------------------------------------
* This section initialises the necessary variables
*-------------------------------------------------
  FN.REDO.CARD.DES.HIS = 'F.REDO.CARD.DES.HIS'
  F.REDO.CARD.DES.HIS = ''

  FN.REDO.CARD.HIS = 'F.REDO.CARD.DES.HIS'
  F.REDO.CARD.HIS = ''

  FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
  F.REDO.CARD.NUMBERS = ''

  FN.REDO.CARD.GENERATION = 'F.REDO.CARD.GENERATION'
  F.REDO.CARD.GENERATION = ''

  FN.REDO.CARD.NO.LOCK = 'F.REDO.CARD.NO.LOCK'
  F.REDO.CARD.NO.LOCK = ''

  FN.REDO.STOCK.QTY.COUNT='F.REDO.STOCK.QTY.COUNT'
  F.REDO.STOCK.QTY.COUNT =''
  CALL OPF(FN.REDO.STOCK.QTY.COUNT,F.REDO.STOCK.QTY.COUNT)

  FN.REDO.PREEMBOSS.STOCK='F.REDO.PREEMBOSS.STOCK'
  F.REDO.PREEMBOSS.STOCK=''
  CALL OPF(FN.REDO.PREEMBOSS.STOCK,F.REDO.PREEMBOSS.STOCK)

  FN.LCO='F.LATAM.CARD.ORDER'
  F.LCO =''
  CALL OPF(FN.LCO,F.LCO)

  FN.STOCK.REGISTER='F.REDO.STOCK.REGISTER'
  F.STOCK.REGISTER =''
  CALL OPF(FN.STOCK.REGISTER,F.STOCK.REGISTER)

  Y.COMPANY = ID.COMPANY
  Y.LAST.WORKING.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY) + 1

  FN.REDO.SERIES.PARAM='F.REDO.CARD.SERIES.PARAM'

  CALL CACHE.READ(FN.REDO.SERIES.PARAM,'SYSTEM',R.REDO.SERIES.PARAM,ERR)

  RETURN

*---------
OPEN.FILE:
*---------
*---------------------------------------
* This section opens the necessary files
*---------------------------------------

  CALL OPF(FN.REDO.CARD.DES.HIS,F.REDO.CARD.DES.HIS)
  CALL OPF(FN.REDO.CARD.HIS,F.REDO.CARD.HIS)
  CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)
  CALL OPF(FN.REDO.CARD.GENERATION,F.REDO.CARD.GENERATION)
  CALL OPF(FN.REDO.CARD.NO.LOCK,F.REDO.CARD.NO.LOCK)

  RETURN

END
