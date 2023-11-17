$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.TASAS.ACTIVAS.CONCAT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.TASAS.ACTIVAS.CONCAT
* Date           : 27-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the Active rates
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*  ======        ========            ==========================
* 09-Oct-2014  Ashokkumar.V.P      PACS00305233:- Changed the parameter values
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INCLUDE LAPAP.BP TO $INSERT
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.TASAS.ACTIVAS.CONCAT.COMMON


    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
    CALL EB.CLEAR.FILE(FN.DR.REG.ACTIVAS.GROUP, F.DR.REG.ACTIVAS.GROUP)
    LIST.PARAMETER = ""
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
    LIST.PARAMETER<3> = "ARR.STATUS EQ 'CURRENT' AND START.DATE EQ ":LAST.WORK.DAY
    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
RETURN

END
