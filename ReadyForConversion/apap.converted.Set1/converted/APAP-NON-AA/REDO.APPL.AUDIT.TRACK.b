SUBROUTINE REDO.APPL.AUDIT.TRACK(Y.HOST.NAME,Y.IP.ADDRESS,R.STANDARD.SELECTION)
*------------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Shankar Raju
*Program Name      : REDO.APPL.AUDIT.TRACK
*Date              : 09/01/2011
*---------------------------------------------------------------------------------------------
*Description       : This is a T24 routine which captures the modified information to the table
*                    REDO.AUDIT.TRAIL.LOG
*Linked With       : SYSTEM record of the VERSION.CONTROL - CALL routine from TAM.UPDATE.HOST.DETAILS
*Linked File       : Routine - TAM.UPDATE.HOST.DETAILS
*---------------------------------------------------------------------------------------------*
*Modification History:
*
*    DATE               ODR REFERENCE                 WHO              DESCRIPTION
* 09.01.2011         SegN4 - ODR-2010-03-0116     Shankar Raju       System Audit Trail - Initial Draft
* 10.01.2011             TUT1276148               Shankar Raju         Description Added
* 13.03.2012             PACS00186448             Pradeep S            Variable initialised
* 21.03.2012             PACS00185462             Sudharsanan S        Fetching local field name from LT table
*---------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : N/A
* Out : N/A
*---------------------------------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : N/A
* Called By : N/A
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.LOCAL.TABLE
    $INSERT I_F.LOCAL.REF.TABLE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.AUDIT.TRAIL.LOG

RETURN
GOSUB INIT
GOSUB CHECK.EXCLUSION
IF R.REDO.EX.AUDIT.TRAIL.LOG ELSE
    GOSUB PROCESS
END

RETURN
*--------------------------------------------------------------------------------------------
INIT:
*----
    FN.REDO.AUDIT.TRAIL.LOG = 'F.REDO.AUDIT.TRAIL.LOG'
    F.REDO.AUDIT.TRAIL.LOG  = ''
    CALL OPF(FN.REDO.AUDIT.TRAIL.LOG,F.REDO.AUDIT.TRAIL.LOG)

    FN.REDO.STR.AAA.PRS = 'F.REDO.STR.AAA.PRS'
    F.REDO.STR.AAA.PRS = ''
    CALL OPF(FN.REDO.STR.AAA.PRS,F.REDO.STR.AAA.PRS)

    R.REDO.AUDIT.TRAIL.LOG = ''

    FN.REDO.EX.AUDIT.TRAIL.LOG = 'F.REDO.EX.AUDIT.TRAIL.LOG'
    F.REDO.EX.AUDIT.TRAIL.LOG  = ''
    R.REDO.EX.AUDIT.TRAIL.LOG  = ''
    CALL OPF(FN.REDO.EX.AUDIT.TRAIL.LOG,F.REDO.EX.AUDIT.TRAIL.LOG)

    FN.LOCAL.TABLE = 'F.LOCAL.TABLE'
    F.LOCAL.TABLE = ''
    CALL OPF(FN.LOCAL.TABLE,F.LOCAL.TABLE)

    FN.LOCAL.REF.TABLE = 'F.LOCAL.REF.TABLE'
    F.LOCAL.REF.TABLE = ''
    CALL OPF(FN.LOCAL.REF.TABLE,F.LOCAL.REF.TABLE)

    R.LT = '' ; R.LRT = ''
    Y.DATE.TIME = '' ; Y.INPUTTER = ''    ;*PACS00186448 - S/E

RETURN
*--------------------------------------------------------------------------------------------
CHECK.EXCLUSION:
*---------------

    CALL F.READ(FN.REDO.EX.AUDIT.TRAIL.LOG,APPLICATION,R.REDO.EX.AUDIT.TRAIL.LOG,F.REDO.EX.AUDIT.TRAIL.LOG,ERR.AUDIT.LOG)

RETURN
*--------------------------------------------------------------------------------------------
PROCESS:
*-------
* Store a Dimensioned array[R.NEW/R.OLD] to a Dynamic Array[Variable]
    MATBUILD Y.R.OLD FROM R.OLD
    MATBUILD Y.R.NEW FROM R.NEW

* To compare the arrays
    Y.CHANGE = EQS(Y.R.OLD,Y.R.NEW)

* 0[Zero will be returned for value changed]
    Y.ZERO = 0

    Y.CNT = 1

    LOOP
    WHILE Y.CNT
        FINDSTR Y.ZERO IN Y.CHANGE,Y.CNT SETTING FM.POS,VM.POS,SM.POS THEN
            IF Y.CNT EQ 1 THEN
                GOSUB UPDATE.ONE.TIME.INFO
            END
* Record status is not captured
            IF FM.POS EQ (V-8) ELSE
                GOSUB NUMBER.TO.NAMES
                GOSUB TRACE.VALUE
            END
            Y.CNT += 1
        END ELSE
            Y.CNT = 0
        END
    REPEAT



    IF (R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.APPLICATION> NE '') AND (R.REDO.AUDIT.TRAIL.LOG NE '') THEN
        GOSUB WRITE.VAL.TRACK
    END

RETURN
*--------------------------------------------------------------------------------------------
NUMBER.TO.NAMES:
*---------------

    CALL FIELD.NUMBERS.TO.NAMES(FM.POS,R.STANDARD.SELECTION,FLD.NAME,DATA.TYPE,ERR.MSG)

    IF FLD.NAME THEN
        Y.FLD.NM = FLD.NAME
    END ELSE
        IF ERR.MSG THEN
            LOCATE FM.POS IN R.STANDARD.SELECTION<SSL.SYS.FIELD.NO,1> SETTING POS THEN
                Y.FLD.NM = R.STANDARD.SELECTION<SSL.SYS.FIELD.NAME,POS>       ;* Convert to field name
            END
        END
    END

RETURN
*--------------------------------------------------------------------------------------------
TRACE.VALUE:
*-----------

    Y.OLD.VAL           = Y.R.OLD<FM.POS,VM.POS,SM.POS>
    Y.NEW.VAL           = Y.R.NEW<FM.POS,VM.POS,SM.POS>
    IF FM.POS EQ (V-4) THEN
        Y.NEW.VAL = C$T24.SESSION.NO:"_":OPERATOR:"_":"OFS":"_":OFS$SOURCE.ID
    END

    Y.AUDIT.DATE.TIME   = Y.R.NEW<V>
    Y.AUDITOR.CODE      = Y.R.NEW<V-1>
    Y.DEPT.CODE         = Y.R.NEW<V-2>
    Y.CO.CODE           = Y.R.NEW<V-3>
    Y.AUTHORISER        = Y.R.NEW<V-4>
    Y.DATE.TIME         = Y.R.NEW<V-5>
    Y.INPUTTER          = Y.R.NEW<V-6>
    Y.CURR.NO           = Y.R.NEW<V-7>
    Y.RECORD.STATUS     = Y.R.NEW<V-8>
    Y.OVERRIDE          = Y.R.NEW<V-9>

* For Normal Authorisation
    IF (V$FUNCTION EQ "I" AND Y.RECORD.STATUS[1,2] EQ 'IN') OR (V$FUNCTION EQ "A" AND Y.RECORD.STATUS[1,2] EQ "IN") THEN
        GOSUB UPDATE.NRML.AUTH.VALUES
        R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.FUNCTION>    = 'A'
    END

* For REVERSE Authorisation
    IF (V$FUNCTION EQ "R" AND Y.RECORD.STATUS[1,2] EQ 'RN') OR (V$FUNCTION EQ "A" AND Y.RECORD.STATUS[1,2] EQ "RN") THEN
        GOSUB UPDATE.REV.AUTH.VALUES
        R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.FUNCTION>    = 'R'
    END

*For Deletion
    IF V$FUNCTION EQ 'D' THEN
        GOSUB UPDATE.DEL.INP.VALUES
        R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.FUNCTION>    = 'D'
    END

RETURN
*--------------------------------------------------------------------------------------------
UPDATE.ONE.TIME.INFO:
*--------------------

    R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.APPLICATION> = APPLICATION
    R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.RECORD.ID>   = ID.NEW
    Y.DATE.TIME         = Y.R.NEW<V-5>
    IF Y.DATE.TIME NE '' THEN
        Y.DATE.TIME.1 = 20:Y.DATE.TIME[1,6]
    END ELSE
        Y.DATE.TIME.1 = TODAY
        X.VAR = TIMEDATE()
        Y.DATE.TIME = TODAY[3,6]:X.VAR[1,2]:X.VAR[4,2]
    END

    TEMP.COMI = COMI ; TEMP.N1=N1 ; TEMP.T1 = T1
    COMI= Y.DATE.TIME.1 ; N1=8 ; T1=".D"
    CALL IN2D(N1,T1)
    Y.DATE.TIME.1 = V$DISPLAY
    COMI = TEMP.COMI ; N1 = TEMP.N1 ; T1 = TEMP.T1

    Y.DATE.TIME = Y.DATE.TIME.1:" ":Y.DATE.TIME[7,2]:":":Y.DATE.TIME[9,2]

    R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.DATE.TIME>   = Y.DATE.TIME

    Y.USER                                             = FIELD(Y.INPUTTER,'_',2,1)
    R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.USER>        = Y.USER

    IF Y.USER EQ '' THEN
        R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.USER>    = OPERATOR
    END

    R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.HOST.NAME>   = Y.HOST.NAME
    R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.IP.ADDRESS>  = Y.IP.ADDRESS

RETURN
*--------------------------------------------------------------------------------------------
UPDATE.NRML.AUTH.VALUES:
*-----------------------
    IF Y.FLD.NM EQ 'LOCAL.REF' THEN
        GOSUB CHK.LOCAL.REF.NAME
        R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.FIELD.NO,Y.CNT> = VAR.LRF.NAME:'.':SM.POS
    END ELSE
        R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.FIELD.NO,Y.CNT> = Y.FLD.NM:'.':VM.POS:'.':SM.POS
    END
    R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.OLD.VALUE,Y.CNT>   = Y.OLD.VAL
    R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.NEW.VALUE,Y.CNT>   = Y.NEW.VAL

RETURN
*--------------------------------------------------------------------------------------------
UPDATE.REV.AUTH.VALUES:
*----------------------

    IF Y.FLD.NM EQ 'LOCAL.REF' THEN
        GOSUB CHK.LOCAL.REF.NAME
        R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.FIELD.NO,Y.CNT>    = VAR.LRF.NAME:'.':SM.POS
    END ELSE
        R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.FIELD.NO,Y.CNT>    = Y.FLD.NM:'.':VM.POS:'.':SM.POS
    END
    R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.OLD.VALUE,Y.CNT>   = Y.OLD.VAL
    R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.NEW.VALUE,Y.CNT>   = Y.NEW.VAL

RETURN
*--------------------------------------------------------------------------------------------
UPDATE.DEL.INP.VALUES:
*---------------------
    IF Y.FLD.NM EQ 'LOCAL.REF' THEN
        GOSUB CHK.LOCAL.REF.NAME
        R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.FIELD.NO,Y.CNT>    = VAR.LRF.NAME:'.':SM.POS
    END ELSE
        R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.FIELD.NO,Y.CNT>    = Y.FLD.NM:'.':VM.POS:'.':SM.POS
    END
    R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.OLD.VALUE,Y.CNT>   = Y.OLD.VAL
    R.REDO.AUDIT.TRAIL.LOG<REDO.AUDIT.LOG.NEW.VALUE,Y.CNT>   = Y.NEW.VAL

RETURN
*--------------------------------------------------------------------------------------------
WRITE.VAL.TRACK:
*---------------

    CALL ALLOCATE.UNIQUE.TIME(Y.CURRTIME)
    Y.REDO.AUDIT.TRAIL.LOG.ID = TODAY:'.':Y.CURRTIME
    CALL F.WRITE(FN.REDO.AUDIT.TRAIL.LOG,Y.REDO.AUDIT.TRAIL.LOG.ID,R.REDO.AUDIT.TRAIL.LOG)

    IF APPLICATION[1,7] EQ 'AA.ARR.' AND OFS$SOURCE.ID EQ 'BROWSERTC' THEN
        CALL F.WRITE(FN.REDO.STR.AAA.PRS,Y.REDO.AUDIT.TRAIL.LOG.ID,R.REDO.AUDIT.TRAIL.LOG)
    END

RETURN
*--------------------------------------------------------------------------------------------
CHK.LOCAL.REF.NAME:
*--------------------------------------------------------------------------------------------

    CALL CACHE.READ(FN.LOCAL.REF.TABLE, APPLICATION, R.LRT, LRT.ERR)
    LRF.FLD.ID = R.LRT<EB.LRT.LOCAL.TABLE.NO,VM.POS>
    CALL CACHE.READ(FN.LOCAL.TABLE, LRF.FLD.ID, R.LT, LT.ERR)
    VAR.LRF.NAME = R.LT<EB.LTA.SHORT.NAME,1>
RETURN
*---------------------------------------------------------------------------------------------
END
