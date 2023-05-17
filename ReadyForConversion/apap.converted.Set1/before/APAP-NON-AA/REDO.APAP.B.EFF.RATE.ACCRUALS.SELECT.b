*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.B.EFF.RATE.ACCRUALS.SELECT
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.B.EFF.RATE.ACCRUALS.SELECT
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.APAP.B.EFF.RATE.ACCRUALS.SELECT is the select routine to make a select on the
*               MM.MONEY.MARKET file with local reference field L.MM.ACCRUE.MET equal to .EFFECTIVE RATE
*Linked With  : REDO.APAP.B.EFF.RATE.ACCRUALS
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 30 SEP 2010    Mohammed Anies K      ODR-2010-07-0077        Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.DATES
$INSERT I_REDO.APAP.B.EFF.RATE.ACCRUALS.COMMON
$INSERT I_F.MM.MONEY.MARKET
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

  SEL.CMD = "SELECT ":FN.MM.MONEY.MARKET:" WITH L.MM.ACCRUE.MET EQ 'EFFECTIVE RATE' AND WITH INT.PERIOD.END GE ":TODAY
  CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.REC,SEL.ERR)

  CALL BATCH.BUILD.LIST("",SEL.LIST)

  RETURN
*--------------------------------------------------------------------------------------------------------
END
