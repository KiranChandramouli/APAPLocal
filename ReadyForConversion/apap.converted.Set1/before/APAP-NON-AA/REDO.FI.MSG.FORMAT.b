*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FI.MSG.FORMAT(INTERFACE.ID,DATO.IN,DATO.OUT)
******************************************************************************
*
* Subroutine Type : Formatting Routine
* Attached to     : Programs for Flat Interface Funcionality
* Attached as     : Subroutine
* Primary Purpose : To return formatted data to the calling Program
*
* Incoming:
* ---------
*
* INTERFACE.ID  -  ID of RAD.CONDUIT.LINEAR record to be used for formatting
* DATO.IN       -  Input Message to be formatted
*
* Outgoing:
* ---------
* DATO.OUT      - fORMATTED RECORD TO BE RETURNED TO THE CALLING PROGRAM
*
* Error Variables:
* ----------------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : JOAQUIN cOSTA - TAM Latin America
* Date            : Oct 26, 2010
*
*-----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
*
*************************************************************************
*


  MAP.FMT  = "MAP"
  ID.RCL   = INTERFACE.ID
  APP      = ""
  ID.APP   = ""
  R.INPUT  = DATO.IN
  R.OUTPUT = ""
  WERR.MSG = ""
  DATO.OUT = ""



  CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT, ID.RCL, APP, ID.APP, R.INPUT, R.OUTPUT, WERR.MSG)

  DATO.OUT = R.OUTPUT

  RETURN
*
