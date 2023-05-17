*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.UPD.LT.USER.LIMITS.SELECT
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.B.UPD.LT.USER.LIMITS.SELECT
*--------------------------------------------------------------------------------------------------------
*Description       : The routine is the .SELECT routine for the multi threade cob routine
*                    REDO.B.UPD.LT.USER.LIMITS. The routine selects alll the records of
*                    REDO.APAP.USER.LIMITS application in this section
*In Parameter      : NA
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                            Reference                      Description
*   ------         ------                         -------------                    -------------
*  08/11/2010   Jeyachandran S                     ODR-2010-07-0075                Initial Creation
*
*********************************************************************************************************

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.DATES
$INSERT I_REDO.B.UPD.LT.USER.LIMITS.COMMON
$INSERT I_F.REDO.APAP.USER.LIMITS

  GOSUB SELECT.STMT
  RETURN

*--------------------------------------------------------------------------------------------------------
SELECT.STMT:
*-------------
* The section calls the routine EB.READLIST  using the select command making select over
* REDO.APAP.USER.LIMITS

  SEL.CMD = "SELECT ":FN.REDO.APAP.USER.LIMITS
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)
  CALL BATCH.BUILD.LIST('',SEL.LIST)
  RETURN

*--------------------------------------------------------------------------------------------------------
END
