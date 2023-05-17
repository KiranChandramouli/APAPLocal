*
*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.213IF01.MONTHLY.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.213IF01.MONTHLY.EXTRACT
* Date           : 2-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the transactions over 10000 USD made by individual customer
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
*-----------------------------------------------------------------------------

  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_BATCH.FILES

$INSERT I_DR.REG.213IF01.MONTHLY.EXTRACT.COMMON
$INSERT I_F.DR.REG.213IF01.PARAM

  GOSUB INIT.PARA
  IF NOT(CONTROL.LIST) THEN
    GOSUB BUILD.CONTROL.LIST
  END

  GOSUB SEL.PROCESS

  RETURN

*-----------------------------------------------------------------------------
INIT.PARA:
**********
  RETURN
*-----------------------------------------------------------------------------
BUILD.CONTROL.LIST:
*******************

  CALL EB.CLEAR.FILE(FN.DR.REG.213IF01.WORKFILE, F.DR.REG.213IF01.WORKFILE)     ;* Clear the WORK file before building for Today

  CONTROL.LIST<-1> = "TRANSACTION.DETAIL"

  RETURN
*-----------------------------------------------------------------------------
SEL.PROCESS:
************

  LIST.PARAMETER = ""

  BEGIN CASE

  CASE CONTROL.LIST<1,1> EQ "TRANSACTION.DETAIL"
    LAST.WRK.DATE.MMYY = LAST.WRK.DATE[1,6]
    LIST.PARAMETER<2> = "F.DR.REG.213IF01.CONCAT"
    LIST.PARAMETER<3> = "@ID LIKE ...":LAST.WRK.DATE.MMYY:"... AND WITH RTE.FLAG EQ 'YES'"
    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

  CASE 1
    DUMMY.LIST = ""
    CALL BATCH.BUILD.LIST("",DUMM.LIST)
  END CASE


  RETURN

*-----------------------------------------------------------------------------
END
