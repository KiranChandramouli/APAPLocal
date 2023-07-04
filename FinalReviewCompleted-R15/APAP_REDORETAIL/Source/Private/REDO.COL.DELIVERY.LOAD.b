* @ValidationCode : Mjo4NDczMDc1MDk6Q3AxMjUyOjE2ODU5NTExMTk4NDA6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jun 2023 13:15:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Version 1 13/04/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*12-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*12-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
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
*CALL  REDO.COL.R.DEL.UPD.LOCKING("CREATE", Y.REPONSE)
   
    CALL APAP.REDORETAIL.redoColRDelUpdLoking("CREATE", Y.REPONSE) ;* R22 Manual Conversion
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
*APAP.REDORETAIL.REDO.COL.R.GET.CONNECTION(REDO.INTERFACE.PARAM.ID, R.REDO.INTERFACE.PARAM, Y.CONNECTION)
    APAP.REDORETAIL.redoColRGetConnection(REDO.INTERFACE.PARAM.ID, R.REDO.INTERFACE.PARAM, Y.CONNECTION);* MANUAL R22 CODE CONVERSION
    IF E NE '' THEN
        TEXT = E
        CALL FATAL.ERROR("REDO.COL.DELIVERY.LOAD")
        RETURN
    END
    Y.CONNECTION = CHANGE(Y.CONNECTION, @FM, "@fm")
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
