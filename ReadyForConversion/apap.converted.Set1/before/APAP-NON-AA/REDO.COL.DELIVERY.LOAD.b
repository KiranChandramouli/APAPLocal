* Version 1 13/04/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
* <Rating>-17</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.COL.DELIVERY.LOAD
*-----------------------------------------------------------------------------
* Load routine to setup the common area for the multi-threaded Service
* REDO COLLECTOR INTERFACE
* 1. Try to create the tracer record
* 2. or wait for the creation of tracer record
* 3. Don't continue if the extract process was not finished yet
*-----------------------------------------------------------------------------
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_F.REDO.INTERFACE.PARAM
  $INSERT I_REDO.COL.DELIVERY.COMMON
*-----------------------------------------------------------------------------
* Open files to be used in the XX.EOD routine as well as standard variables

*
  IF NOT(F.LOCKING) THEN
    FN.LOCKING = "F.LOCKING"
    CALL OPF(FN.LOCKING,F.LOCKING)
  END
*
  E = ''
  CALL  REDO.COL.R.DEL.UPD.LOCKING("CREATE", Y.REPONSE)
  IF E NE '' THEN
    CALL OCOMO(E)
  END

  FN.REDO.COL.QUEUE = 'F.REDO.COL.QUEUE'
  F.REDO.COL.QUEUE = ''
  CALL OPF(FN.REDO.COL.QUEUE,F.REDO.COL.QUEUE)

  FN.REDO.COL.QUEUE.ERROR = 'F.REDO.COL.QUEUE.ERROR'
  F.REDO.COL.QUEUE.ERROR = ''
  CALL OPF(FN.REDO.COL.QUEUE.ERROR,F.REDO.COL.QUEUE.ERROR)

  FN.REDO.INTERFACE.PARAM = 'F.REDO.INTERFACE.PARAM'
  F.REDO.INTERFACE.PARAM = ''
  CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)

  REDO.INTERFACE.PARAM.ID = "COL001"    ;* Just for this interface !! Warning, if we created COL002 ?
  CALL CACHE.READ('F.REDO.INTERFACE.PARAM',REDO.INTERFACE.PARAM.ID,R.REDO.INTERFACE.PARAM,YERR)
* Load String connection on Common Variable
  Y.CONNECTION = ''
  E = ''
  CALL REDO.COL.R.GET.CONNECTION(REDO.INTERFACE.PARAM.ID, R.REDO.INTERFACE.PARAM, Y.CONNECTION)
  IF E NE '' THEN
    TEXT = E
    CALL FATAL.ERROR("REDO.COL.DELIVERY.LOAD")
    RETURN
  END
  Y.CONNECTION = CHANGE(Y.CONNECTION, FM, "@fm")
  DB.COL.CONNECTION = Y.CONNECTION

* getting the size for each batch to pass Java Application
  fieldParamType = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
  fieldParamValue = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>
  paramType = 'DB.BATCH.SIZE'
  GOSUB GET.PARAM.TYPE.VALUE
  DB.BATCH.SIZE = paramValue
  IF DB.BATCH.SIZE EQ '' THEN
    CALL OCOMO("Parameter DB.BATCH.SIZE was not def... using 20 as default")
    DB.BATCH.SIZE = 20
  END


  RETURN

*** <region name= getParamTypeValue>
*** paramType  (in)  to search
*** paramValue (out) value found
*** valueNo    (out) position of the value
*-----------------------------------------------------------------------------
GET.PARAM.TYPE.VALUE:
*-----------------------------------------------------------------------------

  valueNo = 0
  paramValue = ""
  LOCATE paramType IN fieldParamType<1,1> SETTING valueNo THEN
    paramValue = fieldParamValue<1, valueNo>
  END ELSE
    valueNo = 0
  END
  RETURN

END
