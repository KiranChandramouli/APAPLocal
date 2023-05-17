*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.VP.INIT.PROCESS.DATE
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 04.27.2013
* Description  : Init process date for empty record
* Type         : Record Routine
* Attached to  : Version > REDO.VISION.PLUS.PARAM,INPUT
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.27.2013     lpazmino       -                 Initial Version
*-----------------------------------------------------------------------------
* Input/Output: NA
* Dependencies: NA
*-----------------------------------------------------------------------------

* <region name="INCLUDES">

$INSERT I_COMMON
$INSERT I_EQUATE

$INSERT I_F.REDO.VISION.PLUS.PARAM

* </region>

  GOSUB PROCESS
  RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Main Process
PROCESS:
***********************

  IF NOT(R.NEW(VP.PARAM.PROCESS.DATE)) THEN
    R.NEW(VP.PARAM.PROCESS.DATE) = TODAY
  END

  RETURN

* </region>

END
