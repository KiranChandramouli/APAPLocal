*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.NF.NOMINA.EXT(R.DATA)
**
* Subroutine Type : ENQUIRY
* Attached to     : REDO
* Attached as     : NOFILE.ROUTINE
* Primary Purpose : Show all External Payroll configured
* Developer    : jvalarezoulloa@temenos.com
* Date         : 2012-04-17
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
*
*------------------------------------------------------------------------------------------------------------------*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_ENQUIRY.COMMON

$INSERT I_F.REDO.INTERFACE.PARAM


  GOSUB INITIALISE
  GOSUB OPEN.FILE
  GOSUB PROCESS

  RETURN
*---------------------------------------------------------------------------------------------------------
INITIALISE:

  FN.REDO.INTERFACE.PARAM = 'F.REDO.INTERFACE.PARAM'
  F.REDO.INTERFACE.PARAM = ''
  REDO.INTERFACE.PARAM.ID = 'PLANILLA'
  PLANILLA.ID             = ''
  R.PLANILLA              = ''
  YERR                    = ''
  Y.COUNT.PARAM           = 0
  Y.I                     = 0
  Y.POS                   = 0
  R.DATA                  = ''
  RETURN

*---------------------------------------------------------------------------------------------------------
OPEN.FILE:
  CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)


  RETURN
*---------------------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------------------
PROCESS:

  CALL CACHE.READ(FN.REDO.INTERFACE.PARAM,REDO.INTERFACE.PARAM.ID,R.REDO.INTERFACE.PARAM,YERR)
  IF NOT (R.REDO.INTERFACE.PARAM) THEN
    RETURN
  END
  Y.COUNT.PARAM = DCOUNT (R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>,VM)

  FOR Y.I = 1 TO Y.COUNT.PARAM

    IF R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE,Y.I> EQ 'PLANILLA.ID' THEN
      PLANILLA.ID = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE,Y.I>
      GOSUB READ.RECORD.PLANILLA
    END


  NEXT Y.I


  RETURN
*---------------------------------------------------------------------------------------------------------

READ.RECORD.PLANILLA:
  CALL CACHE.READ(FN.REDO.INTERFACE.PARAM,PLANILLA.ID,R.PLANILLA,YERR)
  IF NOT(R.PLANILLA) THEN
    RETURN
  END

  LOCATE 'METODO.PAGO' IN R.PLANILLA<REDO.INT.PARAM.PARAM.TYPE,1> SETTING Y.POS THEN
    IF R.PLANILLA<REDO.INT.PARAM.PARAM.VALUE,Y.POS> EQ 'External Payroll' THEN
      R.DATA<-1> = PLANILLA.ID:'*':R.PLANILLA<REDO.INT.PARAM.NAME>
    END
  END
  RETURN
*---------------------------------------------------------------------------------------------------------
END
