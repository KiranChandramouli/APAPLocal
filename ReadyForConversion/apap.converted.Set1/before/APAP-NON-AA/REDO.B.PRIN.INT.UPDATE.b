*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.PRIN.INT.UPDATE(MSG.ID)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.OFS.SOURCE
    $INSERT I_GTS.COMMON
    $INSERT I_F.TSA.SERVICE
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_REDO.B.PRIN.INT.UPDATE.COMMON

    GOSUB INIT
    GOSUB PROCESS

    RETURN

INIT:
*****

    R.OFS.CHANGE.RATE.QUEUE = '' ; QUEUE.ERR = ''
    CALL F.READ(FN.OFS.CHANGE.RATE.QUEUE,MSG.ID,R.OFS.CHANGE.RATE.QUEUE,F.OFS.CHANGE.RATE.QUEUE,QUEUE.ERR)

    OFS$SOURCE.ID     = FIELD(MSG.ID, '-', 2)
    OFS.MSG.ID        = FIELD(MSG.ID, '-', 1)
    ERR               = ''
    Y.CHECK.DATE      = TODAY
    Y.SCHEDULE.MESSAGE = '' ; Y.PRIN.INT.MESSAGE = ''
    Y.SCHEDULE.MESSAGE = FIELD(R.OFS.CHANGE.RATE.QUEUE, "*", 1)
    Y.PRIN.INT.MESSAGE = FIELD(R.OFS.CHANGE.RATE.QUEUE, "*", 2)

    RETURN

PROCESS:
*------
    OFS.SRC = 'AA.INT.UPDATE'
    OPTIONS = '' ; OFS.MSG.ID = ''
    CALL OFS.CALL.BULK.MANAGER(OFS.SRC,Y.SCHEDULE.MESSAGE,RESP,COMM)
    CALL JOURNAL.UPDATE('')
    Y.RESP.ARRAY1 = '' ; Y.OUT.MSG = '' ; Y.RESP.ARRANGEMENT = '' ; Y.AA.ARRANGEMENT = ''
    Y.RESP.ARRANGEMENT = FIELD(R.OFS.CHANGE.RATE.QUEUE,'ARRANGEMENT:1:1=',2)
    Y.AA.ARRANGEMENT = FIELD(Y.RESP.ARRANGEMENT,",ACTIVITY:1:1=",1)
* MG ISSUE PACS00713462
    Y.RESP.ACTIVITY = FIELD(R.OFS.CHANGE.RATE.QUEUE,',ACTIVITY:1:1=',3)
* MG ISSUE PACS00713462
    Y.PRINC.ACTIVITY = FIELD(Y.RESP.ACTIVITY,",PROPERTY:1:1=",1)
    IF INDEX(RESP,'//-1/',1) THEN
        Y.RESP.ARRAY1 = FIELD(RESP,'//-1/',2)
        Y.OUT.MSG = FIELD(Y.RESP.ARRAY1,'</request><request>',1)
        CALL OCOMO("Change schedule failed - ":Y.AA.ARRANGEMENT:":":Y.OUT.MSG:" - START")
    END ELSE
        CALL OCOMO("Change schedule procssed for via POST - ":ARR.ID:" - START")
        IF Y.PRIN.INT.MESSAGE THEN
            Y.SCHED.PROPERTY = ''
            CALL REDO.GET.PROPERTY.NAME(Y.AA.ARRANGEMENT,'PAYMENT.SCHEDULE',"",Y.SCHED.PROPERTY,SCHED.ERR)
            Y.SCHED.PROP=''
            Y.SCHED.PROP<1> = Y.SCHED.PROPERTY
            Y.SCHED.PROP<2> = "LENDING-CHANGE-":Y.SCHED.PROPERTY
            R.SCHED.ARR.COND.OFS = ''
            OFS.STRING.SCHED = ''
            RET.ERR = '' ; returnID = ''; returnConditions  = '' ; PROP.CLASS =''
            CALL REDO.AA.BUILD.OFS(Y.AA.ARRANGEMENT,R.SCHED.ARR.COND.OFS,Y.SCHED.PROP,OFS.STRING.SCHED)
            OFS.STRING.SCHED:="EFFECTIVE.DATE:1:1=":Y.CHECK.DATE
            CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.AA.ARRANGEMENT,'PAYMENT.SCHEDULE',Y.SCHED.PROPERTY, '',returnID,returnConditions,RET.ERR)
            R.AA.ARR.SCHEDULE = RAISE(returnConditions)
            Y.ON.ACT.LIST = R.AA.ARR.SCHEDULE<AA.PS.ON.ACTIVITY>
            LOCATE Y.PRINC.ACTIVITY IN R.AA.ARR.SCHEDULE<AA.PS.ON.ACTIVITY,1> SETTING ACT.POS THEN
                OFS.STRING.SCHED:=',PROPERTY:1:1=':Y.SCHED.PROPERTY:',FIELD.NAME:1:1=RECALCULATE:':ACT.POS:':1,FIELD.VALUE:1:1=PAYMENT'
            END
            OFS.SRC = 'AA.INT.UPDATE'
            CALL OCOMO("Change principalint procssed for via POST - ":ARR.ID:" - START")
            CALL OFS.POST.MESSAGE(Y.PRIN.INT.MESSAGE,OFS.MSG.ID,OFS.SRC,OPTIONS)
            OFS.MSG.ID = '' ; Y.OFS.ID   = ''
            CALL ALLOCATE.UNIQUE.TIME(OFS.MSG.ID)
            OFS.MSG.ID = DATE():OFS.MSG.ID
            Y.MSG.ID = OFS.MSG.ID:'-':OFS.SRC
            WRITE OFS.STRING.SCHED TO F.OFS.CHANGE.RATE.QUEUE,Y.MSG.ID
        END
        CALL F.DELETE(FN.OFS.CHANGE.RATE.QUEUE,MSG.ID)
    END

    RETURN
END
