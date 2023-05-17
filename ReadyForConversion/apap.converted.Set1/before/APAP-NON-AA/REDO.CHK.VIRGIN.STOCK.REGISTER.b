*--------------------------------------------------------------------------------------------------------
* <Rating>-10</Rating>
*--------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.CHK.VIRGIN.STOCK.REGISTER
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CHK.VIRGIN.STOCK.REGISTER
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to Automatically populate ID
*Linked With  : STOCK.ENTRY,REDO.VIRGIN
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 16 MAR 2011    SWAMINATHAN       ODR-2010-03-0400        Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.COMPANY
$INSERT I_F.USER
$INSERT I_F.REDO.STOCK.ENTRY
$INSERT I_F.REDO.CARD.SERIES.PARAM

  FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
  F.REDO.CARD.SERIES.PARAM = ''
  CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)
  R.REDO.CARD.SERIES.PARAM = ''

  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------------------------------------
********
PROCESS:
*********
  FINAL.COMP = R.COMPANY(EB.COM.FINANCIAL.COM)
  CALL CACHE.READ('F.REDO.CARD.SERIES.PARAM','SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR)
  VIRGIN.DEPT.CODE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.VIRGIN.DEPT.CODE>
  R.NEW(STK.TO.REGISTER) = 'CARD.':FINAL.COMP:'-':VIRGIN.DEPT.CODE
  R.NEW(STK.IN.OUT.DATE) = TODAY
  RETURN
*-----------------------------------------------------------------------------------------------------------
END
