*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-33</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.AUTOMATIC.ORDER.LOAD
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
* 29-JULY-2010     S.R.SWAMINATHAN   ODR-2010-03-0400      Initial Creation
* 20 MAY 2011      S.KAVITHA         PACS00024249          PACS00024249 BUG FIX
*---------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.AUTOMATIC.ORDER.COMMON
$INSERT I_F.REDO.CARD.REQUEST
$INSERT I_F.REDO.CARD.REORDER.DEST
$INSERT I_BATCH.FILES
$INSERT I_F.DATES
$INSERT I_GTS.COMMON
$INSERT I_F.CARD.TYPE
$INSERT I_F.STOCK.REGISTER
$INSERT I_F.REDO.CARD.SERIES.PARAM

  GOSUB INIT
  GOSUB GET.LR.FLD.POS
  GOSUB OPEN.FILE

  RETURN

*----
INIT:
*----
*-------------------------------------------------
* This section initialises the necessary variables
*-------------------------------------------------


  FN.REDO.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
  F.REDO.CARD.REQUEST = ''

  FN.REDO.CARD.REORDER.DEST = 'F.REDO.CARD.REORDER.DEST'
  F.REDO.CARD.REORDER.DEST = ''

*PACS00024249 -S

  FN.STOCK.REGISTER = 'F.REDO.STOCK.REGISTER'
  F.STOCK.REGISTER = ''
*PACS00024249 -E

  FN.CARD.TYPE = 'F.CARD.TYPE'
  F.CARD.TYPE = ''

  FN.DATES = 'F.DATES'
  F.DATES = ''

*PACS00082440-S
  FN.REDO.PREEMBOSS.STOCK = 'F.REDO.PREEMBOSS.STOCK'
  F.REDO.PREEMBOSS.STOCK = ''
  CALL OPF(FN.REDO.PREEMBOSS.STOCK,F.REDO.PREEMBOSS.STOCK)
*PACS00082440-E

  FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
  F.REDO.CARD.SERIES.PARAM  = ''
  RETURN

*--------------
GET.LR.FLD.POS:
*--------------
*-------------------------------------------------------------
* This section gets the position of the local reference fields
*-------------------------------------------------------------

  Y.LRF.APPL = "CARD.TYPE"
  Y.LRF.FIELDS = 'L.CT.BIN'
  FIELD.POS = ''
  CALL MULTI.GET.LOC.REF(Y.LRF.APPL,Y.LRF.FIELDS,FIELD.POS)
  Y.CT.BIN.POS = FIELD.POS<1,1>

  RETURN

*---------
OPEN.FILE:
*---------
*---------------------------------------
* This section opens the necessary files
*---------------------------------------

  CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)
  CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)
  CALL OPF(FN.REDO.CARD.REORDER.DEST,F.REDO.CARD.REORDER.DEST)
  CALL OPF(FN.STOCK.REGISTER,F.STOCK.REGISTER)
  CALL OPF(FN.DATES,F.DATES)
  CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)

  CALL CACHE.READ(FN.REDO.CARD.SERIES.PARAM,'SYSTEM',R.REDO.CARD.SERIES.PARAM,Y.ERR1)
  Y.RECEIVED.BRANCH =  R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.RECEIVE.DEPT.CODE>
  RETURN

END
