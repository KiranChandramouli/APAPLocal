*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.MM.EFF.RATE.ACCR.SELECT
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.MM.EFF.RATE.ACCR.SELECT
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.B.MM.EFF.RATE.ACCR.SELECT is the select routine to make a select on the
*               MM.MONEY.MARKET file with local reference field L.MM.ACCRUE.MET equal to .EFFECTIVE RATE
*Linked With  : REDO.B.MM.EFF.RATE.ACCR
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date           Who                  Reference           Description
* ------         ------               -------------       -------------
* 12 FEB 2013    Balagurunathan B     RTC-553577          Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.DATES
$INSERT I_F.MM.MONEY.MARKET
$INSERT I_REDO.B.MM.EFF.RATE.ACCR.COMMON

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
