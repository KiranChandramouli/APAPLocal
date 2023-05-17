*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.REINV.MATURITY.ACI.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.REINV.MATURITY.ACI.SELECT
*--------------------------------------------------------------------------------
* Description: This Batch routine is to create a ACI for interest Liq account
* for the deposit with zero rate.
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO           REFERENCE          DESCRIPTION
* 18-Jul-2011    H GANESH      PACS00072695_N.11  INITIAL CREATION
*
*----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.DATES
$INSERT I_REDO.REINV.MATURITY.ACI.COMMON


  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

  LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)

  SEL.CMD = 'SELECT ':FN.AZ.ACCOUNT
  SEL.CMD := ' WITH ((MATURITY.DATE LE ':TODAY:')'
  SEL.CMD := ' OR (MIN.MAT.DATE AND MIN.MAT.DATE GE ':LAST.WORK.DAY:
  SEL.CMD := ' AND MIN.MAT.DATE LT ':TODAY: ')) AND L.TYPE.INT.PAY EQ Reinvested'

  LIST.PARAMETER = ''
  LIST.PARAMETER<3> = SEL.CMD
  CALL BATCH.BUILD.LIST(LIST.PARAMETER,'')

  RETURN
END
