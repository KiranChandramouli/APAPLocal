SUBROUTINE REDO.MANUAL.RATE.CHANGE
*-----------------------------------------------------------------------------
*DESCRIPTIONS:
*-------------
* This is the COB routine for B16 development
* The enquiry output is downloaded in csv format with name "enquiry.csv"
* The file is ftp into the environment
* The flat file is read using this routine and using the OFS post messages
* It is being updated
*
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who             Reference            Description
* 05-AUG-10    Kishore.SP      ODR-2009-10-0325      Initial Creation
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.REDO.SUCESS.RATE.CHANGE
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB OPEN.CSV.FILE
    GOSUB READ.CSV.FILE
    GOSUB FORM.OFS
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*----------
* Open the necessary files
* Intialise Necessary variable
*
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
*
    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)
*
    FN.REDO.SUCESS.RATE.CHANGE = 'F.REDO.SUCESS.RATE.CHANGE'
    F.REDO.SUCESS.RATE.CHANGE = ''
    CALL OPF(FN.REDO.SUCESS.RATE.CHANGE,F.REDO.SUCESS.RATE.CHANGE)
    Y.FST.FLAG = ''
*
    FN.AA.ARR.INTEREST = 'F.AA.ARR.INTEREST'
    F.AA.ARR.INTEREST = ''
    CALL OPF(FN.AA.ARR.INTEREST,F.AA.ARR.INTEREST)
*
RETURN
*-----------------------------------------------------------------------------
OPEN.CSV.FILE:
*-------------
* Open the flat file
* Enquiry output is the flat file
* Y.FILE = location where the enquiry csv file is placed
* Y.RECORD = Name of the Enquiry output file which is CSV format
*
    Y.FILE  = 'bnk.run'
    Y.RECORD = 'enquiry.csv'
*
    OPEN Y.FILE TO F.FILE.PATH ELSE
        CRT 'CANNOT OPEN  FILE'
    END
RETURN
*-----------------------------------------------------------------------------
READ.CSV.FILE:
*--------------
* Read the Flat file
* changing " to null in the record and trim the record
*
    READ  Y.REC.ARRAY FROM F.FILE.PATH,Y.RECORD ELSE
        CRT 'CANNOT READ  FILE'
    END
*
    CHANGE '"' TO " " IN Y.REC.ARRAY
    Y.REC.ARR = TRIM(Y.REC.ARRAY,"","A")
*
    LOOP
        REMOVE Y.REC FROM Y.REC.ARR SETTING Y.POS
    WHILE Y.REC:Y.POS
        GOSUB GET.CHECK.ARRG
    REPEAT
RETURN
*-----------------------------------------------------------------------------
GET.CHECK.ARRG:
*-------------
* Get the Arrangement ID from the first delimiter
*
    Y.ARG.ID  = FIELD(Y.REC,',',1)
    Y.ARR.STR = Y.ARG.ID[1,2]
*
    IF Y.ARG.ID EQ "ARR.ID" THEN
        RETURN
    END
*
    Y.ARRANGEMENT.ID = Y.ARG.ID
* CRT Y.ARG.ID
*
    IF Y.ARR.STR EQ "AA" AND Y.FST.FLAG NE '' THEN
        GOSUB FORM.OFS
        Y.FST.FLAG = ''
        Y.ARRNG.NEW.ID = ''
    END
*
    R.AA.ARRANGEMENT = ''
    CALL F.READ(FN.AA.ARRANGEMENT,Y.ARRANGEMENT.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,Y.ARR.ERR)
    IF R.AA.ARRANGEMENT NE  '' THEN
        Y.FST.FLAG = '1'
        Y.MARGIN.TYPE.FLD       = FIELD(Y.REC,',',12)
        Y.MARGIN.TYPE           = FIELD(Y.REC,',',13)
        Y.MARGIN.OPER.FLD       = FIELD(Y.REC,',',14)
        Y.MARGIN.OPER           = FIELD(Y.REC,',',15)
        Y.MARGIN.RATE.FLD       = FIELD(Y.REC,',',16)
        Y.MARGIN.RATE           = FIELD(Y.REC,',',17)
        Y.FIXED.RATE.FLD        = FIELD(Y.REC,',',18)
        Y.FIXED.RATE            = FIELD(Y.REC,',',19)
        Y.FLOAT.IND.FLD         = FIELD(Y.REC,',',20)
        Y.FLOAT.INDEX           = FIELD(Y.REC,',',21)
        Y.PERIOD.IND.FLD        = FIELD(Y.REC,',',22)
        Y.PERIOD.INDEX          = FIELD(Y.REC,',',23)
        Y.DAY.BASIS.FLD         = FIELD(Y.REC,',',24)
        Y.DAY.BASIS             = FIELD(Y.REC,',',25)
        Y.ACCRUAL.RULE.FLD      = FIELD(Y.REC,',',26)
        Y.ACCRUAL.RULE          = FIELD(Y.REC,',',27)
        Y.BALANCE.CALC.TYPE.FLD = FIELD(Y.REC,',',28)
        Y.BALANCE.CALC.TYPE     = FIELD(Y.REC,',',29)
        Y.RATE.TIER.TYPE.FLD    = FIELD(Y.REC,',',30)
        Y.RATE.TIER.TYPE        = FIELD(Y.REC,',',31)
        Y.L.AA.REV.RT.TY.FLD    = FIELD(Y.REC,',',32)
        Y.L.AA.REV.RT.TY        = FIELD(Y.REC,',',33)
        Y.L.AA.RT.RV.FREQ.FLD   = FIELD(Y.REC,',',34)
        Y.L.AA.RT.RV.FREQ       = FIELD(Y.REC,',',35)
        Y.POOL.RATE.FLD.NAME    = "L.AA.POOL.RATE:1:1"
        Y.POOL.RATE.VAL         = FIELD(Y.REC,',',10)

        Y.ARRNG.NEW.ID          = Y.ARRANGEMENT.ID
    END ELSE
        GOSUB GET.VALUES
    END
RETURN
*-----------------------------------------------------------------------------
GET.VALUES:
*----------
* Get the values and concat using SM
*
    Y.MARGIN.TYPE.FLD      :=@SM:  FIELD(Y.REC,',',12)
    Y.MARGIN.TYPE          :=@SM:  FIELD(Y.REC,',',13)
    Y.MARGIN.OPER.FLD      :=@SM:  FIELD(Y.REC,',',14)
    Y.MARGIN.OPER          :=@SM:  FIELD(Y.REC,',',15)
    Y.MARGIN.RATE.FLD      :=@SM:  FIELD(Y.REC,',',16)
    Y.MARGIN.RATE          :=@SM:  FIELD(Y.REC,',',17)
    Y.FIXED.RATE.FLD       :=@SM:  FIELD(Y.REC,',',18)
    Y.FIXED.RATE           :=@SM:  FIELD(Y.REC,',',19)
    Y.FLOAT.IND.FLD        :=@SM:  FIELD(Y.REC,',',20)
    Y.FLOAT.INDEX          :=@SM:  FIELD(Y.REC,',',21)
    Y.PERIOD.IND.FLD       :=@SM:  FIELD(Y.REC,',',22)
    Y.PERIOD.INDEX         :=@SM:  FIELD(Y.REC,',',23)
    Y.DAY.BASIS.FLD        :=@SM:  FIELD(Y.REC,',',24)
    Y.DAY.BASIS            :=@SM:  FIELD(Y.REC,',',25)
    Y.ACCRUAL.RULE.FLD     :=@SM:  FIELD(Y.REC,',',26)
    Y.ACCRUAL.RULE         :=@SM:  FIELD(Y.REC,',',27)
    Y.BALANCE.CALC.TYPE.FLD:=@SM:  FIELD(Y.REC,',',28)
    Y.BALANCE.CALC.TYPE    :=@SM:  FIELD(Y.REC,',',29)
    Y.RATE.TIER.TYPE.FLD   :=@SM:  FIELD(Y.REC,',',30)
    Y.RATE.TIER.TYPE       :=@SM:  FIELD(Y.REC,',',31)
    Y.L.AA.REV.RT.TY.FLD   :=@SM:  FIELD(Y.REC,',',32)
    Y.L.AA.REV.RT.TY       :=@SM:  FIELD(Y.REC,',',33)
    Y.L.AA.RT.RV.FREQ.FLD  :=@SM:  FIELD(Y.REC,',',34)
    Y.L.AA.RT.RV.FREQ      :=@SM:  FIELD(Y.REC,',',35)
    Y.POOL.RATE.FLD.NAME   :=@SM: "L.AA.POOL.RATE:1:1"
    Y.POOL.RATE.VAL        :=@SM:  FIELD(Y.REC,',',10)
*
RETURN
*-----------------------------------------------------------------------------
FORM.OFS:
*---------
* once the values are formed using SM separator
* use OFS Build record to get the OFS String
* Then call the POST Message
*
    R.APP.RECORD = ''
    CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.ARRNG.NEW.ID,R.APP.RECORD,F.AA.ARRANGEMENT.ACTIVITY,Y.ERR.APP)
*
    Y.ARR.ID = Y.ARRNG.NEW.ID
    APP.NAME = 'AA.ARRANGEMENT.ACTIVITY'
    OFS.FUNCTION = 'I'
    OFSVERSION='AA.ARRANGEMENT.ACTIVITY,REDO.MAN'
    PROCESS = 'PROCESS'
    GTS.MODE=''
    NO.OF.AUTH=''
    TRANSACTION.ID= ''
    R.APP.RECORD=''
    OFS.STRING=''
*

    PROP.NAME='PRINCIPAL'       ;* Interest Property to obtain
    CALL REDO.GET.INTEREST.PROPERTY(Y.ARR.ID,PROP.NAME,OUT.PROP,ERR)
    Y.PRIN.PROP=OUT.PROP        ;* This variable hold the value of principal interest property


    R.APP.RECORD<AA.ARR.ACT.ARRANGEMENT> = Y.ARR.ID
    R.APP.RECORD<AA.ARR.ACT.ACTIVITY> = 'LENDING-CHANGE-':Y.PRIN.PROP
    R.APP.RECORD<AA.ARR.ACT.EFFECTIVE.DATE> = TODAY
    R.APP.RECORD<AA.ARR.ACT.PROPERTY>     = Y.PRIN.PROP
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,-1>   = Y.MARGIN.TYPE.FLD
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,-1>  = Y.MARGIN.TYPE
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,-1>   = Y.MARGIN.OPER.FLD
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,-1>  = Y.MARGIN.OPER
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,-1>   = Y.MARGIN.RATE.FLD
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,-1>  = Y.MARGIN.RATE
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,-1>   = Y.FIXED.RATE.FLD
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,-1>  = Y.FIXED.RATE
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,-1>   = Y.FLOAT.IND.FLD
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,-1>  = Y.FLOAT.INDEX
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,-1>   = Y.PERIOD.IND.FLD
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,-1>  = Y.PERIOD.INDEX
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,-1>   = Y.DAY.BASIS.FLD
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,-1>  = Y.DAY.BASIS
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,-1>   = Y.ACCRUAL.RULE.FLD
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,-1>  = Y.ACCRUAL.RULE
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,-1>   = Y.BALANCE.CALC.TYPE.FLD
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,-1>  = Y.BALANCE.CALC.TYPE
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,-1>   = Y.RATE.TIER.TYPE.FLD
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,-1>  = Y.RATE.TIER.TYPE
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,-1>   = Y.L.AA.REV.RT.TY.FLD
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,-1>  = Y.L.AA.REV.RT.TY
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,-1>   = Y.L.AA.RT.RV.FREQ.FLD
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,-1>  = Y.L.AA.RT.RV.FREQ
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,-1>   = Y.POOL.RATE.FLD.NAME
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,-1>  = Y.POOL.RATE.VAL
*
    CALL OFS.BUILD.RECORD(APP.NAME,OFS.FUNCTION,PROCESS,OFSVERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.APP.RECORD,Y.OFS.MESSAGE)
*
    Y.MSG = Y.OFS.MESSAGE
    Y.MSG.KEY = ""
    Y.OFS.SOURCE.ID = "REDO.RATE.MANUAL"
    Y.ERROR = ""
    CALL OFS.POST.MESSAGE(Y.MSG,Y.MSG.KEY,Y.OFS.SOURCE.ID,Y.ERROR)
    GOSUB UPDATE.SUCESS
RETURN
*--------------------------------------------------------------------------------------------------------------
UPDATE.SUCESS:
*-------------
* Before doing a new activity get the current margin rate
* After doing new activity get the new margin rate
* The details is been updated in a local template
*
    ARR.ID=Y.ARR.ID
    EFF.DATE=TODAY
    PROP.CLASS='INTEREST'
    PROPERTY=Y.PRIN.PROP
    R.Condition=''
    ERR.MSG=''
    R.SUCESS.CHANGE = ''
    CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
    Y.OLD.EFF.RATE = R.Condition<AA.INT.EFFECTIVE.RATE>
    R.SUCESS.CHANGE<REDO.SUC.DATE>              = TODAY
    R.SUCESS.CHANGE<REDO.SUC.OLD.INTEREST.RATE> = Y.OLD.EFF.RATE
*
    CALL F.WRITE(FN.REDO.SUCESS.RATE.CHANGE,Y.ARR.ID,R.SUCESS.CHANGE)
*
RETURN
*-------------------------------
END
