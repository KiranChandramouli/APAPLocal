* Version 1 13/04/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.COL.EXTRACT.PRE.LOAD
*-----------------------------------------------------------------------------
* REDO COLLECTOR EXTRACT PRE-Process Load routine
* Service : REDO.COL.EXTRACT.PRE
*-----------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 14/09/2011 - PACS00110378         Dejar de leer el  Registro del Locking REDO.COL.EXTRACT.ERROR.":TODAY
*         leer el registro de la Cola REDO.MSG.COL.QUEUE
*                                   Y.MSG.QUEUE.ID = "TABLES.":TODAY:".":ID.COMPANY
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.COL.EXTRACT.PRE.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
*-----------------------------------------------------------------------------
    C.ALREADY.PROCESSED = 0

    IF NOT(F.LOCKING) THEN
        FN.LOCKING = "F.LOCKING"
        CALL OPF(FN.LOCKING, F.LOCKING)
    END

    FN.REDO.COL.QUEUE = 'F.REDO.COL.QUEUE'
    F.REDO.COL.QUEUE = ''
    CALL OPF(FN.REDO.COL.QUEUE, F.REDO.COL.QUEUE)

    FN.REDO.COL.QUEUE.ERROR = "F.REDO.COL.QUEUE.ERROR"
    F.REDO.COL.QUEUE.ERROR  = ''
    CALL OPF(FN.REDO.COL.QUEUE.ERROR, F.REDO.COL.QUEUE.ERROR)

    FN.REDO.COL.EXTRACT.CONTROL = 'F.REDO.COL.EXTRACT.CONTROL'
    F.REDO.COL.EXTRACT.CONTROL = ''
    CALL OPF(FN.REDO.COL.EXTRACT.CONTROL, F.REDO.COL.EXTRACT.CONTROL)

    R.REDO.COL.MSG.QUEUE=""
    FN.REDO.COL.MSG.QUEUE='F.REDO.MSG.COL.QUEUE'
    F.REDO.COL.MSG.QUEUE = ''
    Y.MSG.QUEUE.ID = "TABLES.":TODAY:".":ID.COMPANY
    CALL OPF(FN.REDO.COL.MSG.QUEUE,F.REDO.COL.MSG.QUEUE)


    FN.REDO.COL.TRACE = 'F.REDO.COL.TRACE'
    F.REDO.COL.TRACE = ''
    CALL OPF(FN.REDO.COL.TRACE,F.REDO.COL.TRACE)

    FN.REDO.COL.TRACE.SUM = 'F.REDO.COL.TRACE.SUM'
    F.REDO.COL.TRACE.SUM = ''
    CALL OPF(FN.REDO.COL.TRACE.SUM,F.REDO.COL.TRACE.SUM)

    Y.RID.ID = "COL001"
    R.REDO.INTERFACE.PARAM = ''
    CALL CACHE.READ('F.REDO.INTERFACE.PARAM', Y.RID.ID, R.REDO.INTERFACE.PARAM, Y.ERR)
    IF Y.ERR THEN
        TEXT = "ERROR READING REDO.INTERFACE.PARAM - " : Y.ERR
        CALL FATAL.ERROR("REDO.COL.EXTRACT.PRE.LOAD")
    END

    GOSUB GET.AA.CRITERIA


    NO.REC.CLI=0
    NO.REC.PHON=0
    NO.REC.DIR=0
    NO.REC.MOV=0
    NO.REC.CRE=0
    VM.POS=1
    Y.TABLE=""
    C.TABLES=""
    C.TABLES<-1>='TMPCLIENTES'
    C.TABLES<-1>='TMPTELEFONOSCLIENTE'
    C.TABLES<-1>='TMPDIRECCIONESCLIENTE'
    C.TABLES<-1>='TMPMOVIMIENTOS'
    C.TABLES<-1>='TMPCREDITO'

    LOOP
        REMOVE Y.TABLE FROM C.TABLES SETTING Y.POS
    WHILE Y.TABLE
        GOSUB CHECK.PROCESS.CONTINUE
        IF NO.REC.SEL GT 0 THEN
            C.ALREADY.PROCESSED = 1
            C.TABLE.PROCESS<1,-1>=Y.TABLE

        END
    REPEAT



* Check if The process was already done
    R.LOCKING = ''
    Y.LOCKING.ID = C.RED.LOKING.ID : "." : TODAY
    CALL F.READ(FN.LOCKING,Y.LOCKING.ID,R.LOCKING,F.LOCKING,YERR)
    IF R.LOCKING NE "" THEN
* This entry must exist only if previouly the process was already done successfully
*    READ R.LOCKING FROM F.LOCKING, Y.LOCKING.ID THEN
        C.ALREADY.PROCESSED = 1
    END

*      RELEASE F.LOCKING, Y.LOCKING.ID

    IF C.ALREADY.PROCESSED THEN
        CALL OCOMO("THE LIST WAS ALREADY EXECUTED, RE-PROCESSING")
        RETURN
    END


RETURN
*-----------------------------------------------------------------------------
GET.AA.CRITERIA:
*-----------------------------------------------------------------------------
* Criteria Selection
    fieldParamType = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    fieldParamValue = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>

    paramType = 'AA.PRD.SELECTION'
    GOSUB GET.PARAM.TYPE.VALUE
    C.AA.PRODUCT.GROUP = paramValue
    IF C.AA.PRODUCT.GROUP EQ '' THEN
        CALL OCOMO("Parameter AA.PRD.SELECTION was not def... using default")
        C.AA.PRODUCT.GROUP = "COMERCIAL,HIPOTECARIO,CONSUMO"
    END
    paramType = 'AA.STA.SELECTION'
    GOSUB GET.PARAM.TYPE.VALUE
    C.AA.STATUS = paramValue
    IF C.AA.STATUS EQ '' THEN
        CALL OCOMO("Parameter AA.STA.SELECTION was not def... using default")
        C.AA.STATUS = "CURRENT,AUTH,EXPIRED"
    END

    C.AA.PRODUCT.GROUP = CHANGE(C.AA.PRODUCT.GROUP,",", @VM)
    C.AA.STATUS = CHANGE(C.AA.STATUS,",", @VM)
*
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
*======================
CHECK.PROCESS.CONTINUE:
*======================

    Y.SELECT.TABLES=""
    Y.SELECT.TABLES := 'SELECT ':FN.REDO.COL.MSG.QUEUE
    Y.SELECT.TABLES := ' WITH @ID LIKE ':Y.TABLE:'.':TODAY:'.':ID.COMPANY:"..."
    Y.ERR=''
    Y.F.REDO.MSG.QUEUE=''
    Y.LIST.MSG=''

    CALL EB.READLIST(Y.SELECT.TABLES,Y.F.REDO.MSG.QUEUE,Y.LIST.MSG,NO.REC.SEL,Y.ERR)


RETURN
*-----------------------------------------------------------------------------
END
