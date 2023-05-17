*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.REPORTE.ACTIVIDAD.SELECT
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      :
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description: This is a .SELECT Subroutine
*
*-------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*-----------------------------------------------------------------------------------------------------------------
* PACS00363969           Ashokkumar.V.P                 27/11/2014            Changed to show the AA loan with START.DATE less than today.
* PACS00466618           Ashokkumar.V.P                 26/06/2015            Fixed the NAB account created on same date for old NAB loans.
*-----------------------------------------------------------------------------------------------------------------
	
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_REDO.B.REPORTE.ACTIVIDAD.COMMON

  GOSUB PROCESS.PARA
  RETURN
*-------------------------------------------------------------------------------
PROCESS.PARA:
*------------
*
  LIST.PARAMETER = ''
  LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
*    LIST.PARAMETER<3> = "START.DATE LE ":Y.LAST.DAY
  LIST.PARAMETER<3> := "PRODUCT.LINE EQ ":"LENDING"
*    LIST.PARAMETER<3> := " AND ((ARR.STATUS EQ ":Y.SEL.VAL.1:") OR (ARR.STATUS EQ ":Y.SEL.VAL.2:"))"
  CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
  RETURN
END
