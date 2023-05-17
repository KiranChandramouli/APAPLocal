*-----------------------------------------------------------------------------
* <Rating>1408</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.SDB.TYPE

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.MB.SDB.TYPE
    $INSERT I_F.MB.SDB.PARAM
    $INSERT I_F.MB.SDB.STATUS
*************************************************************************

    GOSUB DEFINE.PARAMETERS

    IF LEN(V$FUNCTION) GT 1 THEN
        GOTO V$EXIT
    END

    CALL MATRIX.UPDATE

    GOSUB INITIALISE          ;* Special Initialising

*************************************************************************
* Main Program Loop

    LOOP

        CALL RECORDID.INPUT

    UNTIL (MESSAGE EQ 'RET')

        V$ERROR = ''

        IF MESSAGE EQ 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION        ;* Special Editing of Function

            IF V$FUNCTION EQ 'E' OR V$FUNCTION EQ 'L' THEN
                CALL FUNCTION.DISPLAY
                V$FUNCTION = ''
            END

        END ELSE

            GOSUB CHECK.ID    ;* Special Editing of ID
            IF V$ERROR THEN GOTO MAIN.REPEAT

            CALL RECORD.READ

            IF MESSAGE EQ 'REPEAT' THEN
                GOTO MAIN.REPEAT
            END

            GOSUB CHECK.RECORD          ;* Special Editing of Record

            CALL MATRIX.ALTER

            IF V$ERROR THEN GOTO MAIN.REPEAT

            LOOP
                GOSUB PROCESS.FIELDS    ;* ) For Input
                GOSUB PROCESS.MESSAGE   ;* ) Applications
            WHILE (MESSAGE EQ 'ERROR') REPEAT

        END

MAIN.REPEAT:
    REPEAT

    V$EXIT:
    RETURN          ;* From main program

*************************************************************************
*                      S u b r o u t i n e s                            *
*************************************************************************
PROCESS.FIELDS:
* Input or display the record fields.

    LOOP
        IF SCREEN.MODE EQ 'MULTI' THEN
            IF FILE.TYPE EQ 'I' THEN
                CALL FIELD.MULTI.INPUT
            END ELSE
                CALL FIELD.MULTI.DISPLAY
            END
        END ELSE
            IF FILE.TYPE EQ 'I' THEN
                CALL FIELD.INPUT
            END ELSE
                CALL FIELD.DISPLAY
            END
        END

    WHILE NOT(MESSAGE)

        GOSUB CHECK.FIELDS    ;* Special Field Editing

        IF T.SEQU NE '' THEN T.SEQU<-1> = A + 1

    REPEAT

    RETURN

*************************************************************************
PROCESS.MESSAGE:
* Processing after exiting from field input (PF5)

    IF MESSAGE = 'DEFAULT' THEN
        MESSAGE = 'ERROR'     ;* Force the processing back
        IF V$FUNCTION <> 'D' AND V$FUNCTION <> 'R' THEN
            GOSUB CROSS.VALIDATION
        END
    END

    IF MESSAGE = 'PREVIEW' THEN
        MESSAGE = 'ERROR'     ;* Force the processing back
        IF V$FUNCTION <> 'D' AND V$FUNCTION <> 'R' THEN
            GOSUB CROSS.VALIDATION
            IF NOT(V$ERROR) THEN
REM >               GOSUB DELIVERY.PREVIEW   ; * Activate print preview
            END
        END
    END

    IF MESSAGE EQ 'VAL' THEN
        MESSAGE = ''
        BEGIN CASE
        CASE V$FUNCTION EQ 'D'
            GOSUB CHECK.DELETE          ;* Special Deletion checks
        CASE V$FUNCTION EQ 'R'
            GOSUB CHECK.REVERSAL        ;* Special Reversal checks
        CASE OTHERWISE
            GOSUB CROSS.VALIDATION      ;* Special Cross Validation
            IF NOT(V$ERROR) THEN
                GOSUB OVERRIDES
            END
        END CASE
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.UNAU.WRITE     ;* Special Processing before write
        END
        IF NOT(V$ERROR) THEN
            CALL UNAUTH.RECORD.WRITE
            IF MESSAGE NE "ERROR" THEN
                GOSUB AFTER.UNAU.WRITE  ;* Special Processing after write
            END
        END

    END

    IF MESSAGE EQ 'AUT' THEN
        GOSUB AUTH.CROSS.VALIDATION     ;* Special Cross Validation
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.AUTH.WRITE     ;* Special Processing before write
        END

        IF NOT(V$ERROR) THEN

            CALL AUTH.RECORD.WRITE

            IF MESSAGE NE "ERROR" THEN
                GOSUB AFTER.AUTH.WRITE  ;* Special Processing after write
            END
        END

    END

    RETURN

*************************************************************************
*                      Special Tailored Subroutines                     *
*************************************************************************
CHECK.ID:

* Validation and changes of the ID entered.  Set ERROR to 1 if in error.
    V$ERROR = 0
    E = ''
*    IF ID.NEW[1,4] EQ 'BOX.' THEN
*        IF SEQX(ID.NEW[5,1]) LT 65 OR SEQX(ID.NEW[5,1]) GT 91 THEN    ;* check if the ID is between A - Z (upper case)
*            E = 'Invalid ID. Should use BOX.A, BOX.B, etc..'
*        END
*    END ELSE
*        E = 'Invalid ID. Should use BOX.A, BOX.B, etc..'
*    END

    IF INDEX(COMI, '.', 1) THEN
        E = 'Invalid Id. No dot allowed in Id'
    END

    IF E THEN
        V$ERROR = 1
        CALL ERR
    END

    RETURN

*************************************************************************
CHECK.RECORD:

* Validation and changes of the Record.  Set ERROR to 1 if in error.


    RETURN

*************************************************************************
CHECK.FIELDS:

    CALL MB.SDB.TYPE.CHECK.FIELDS

    IF E THEN
        T.SEQU = "IFLD"
        CALL ERR
    END

    RETURN
*************************************************************************
CROSS.VALIDATION:
*
    V$ERROR = ''
    ETEXT = ''
    TEXT = ''
*
REM > CALL MB.SDB.TYPE.CROSSVAL
*
* If END.ERROR has been set then a cross validation error has occurred
*
    IF END.ERROR THEN
        A = 1
        LOOP UNTIL T.ETEXT<A> <> "" DO A = A+1 ; REPEAT
        T.SEQU = "D"
        T.SEQU<-1> = A
        V$ERROR = 1
        MESSAGE = 'ERROR'
    END

    RETURN          ;* Back to field input via UNAUTH.RECORD.WRITE

*************************************************************************
OVERRIDES:
*
*  Overrides should reside here.
*
    V$ERROR = ''
    ETEXT = ''
    TEXT = ''

    IF TEXT = "NO" THEN
        V$ERROR = 1
        MESSAGE = "ERROR"

    END

    RETURN

*************************************************************************
AUTH.CROSS.VALIDATION:


    RETURN

*************************************************************************
CHECK.DELETE:


    RETURN

*************************************************************************
CHECK.REVERSAL:


    RETURN

*************************************************************************
DELIVERY.PREVIEW:

    RETURN

*************************************************************************
BEFORE.UNAU.WRITE:

    IF TEXT = "NO" THEN
        CALL TRANSACTION.ABORT
        V$ERROR = 1
        MESSAGE = "ERROR"
        RETURN
    END

    IF V$FUNCTION = 'I' OR V$FUNCTION = 'C' THEN
        TOT.SDB.NO = 0
        FOR IJ = 1 TO DCOUNT(R.NEW(SDB.TYP.BRANCH.CODE),VM)
            START.NO = 0
            END.NO = 0
            BRANCH.SDB.TOT = 0
            COMPANY.CODE = R.NEW(SDB.TYP.BRANCH.CODE)<1,IJ>
            GOSUB READ.MB.SDB.PARAM

            VAT.AMOUNT = R.NEW(SDB.TYP.PERIODIC.RENT)<1,IJ> * (VAT.PERCENT/100)
            CALL EB.ROUND.AMOUNT(LCCY, VAT.AMOUNT, '2', '')
            R.NEW(SDB.TYP.VAT.ON.RENT)<1,IJ> = VAT.AMOUNT

            FOR IJK = 1 TO DCOUNT(R.NEW(SDB.TYP.NO.OF.SDB.BR)<1,IJ>, SM)
                START.NO = TRIM(FIELD(R.NEW(SDB.TYP.NO.OF.SDB.BR)<1,IJ,IJK>,'-',1))
                END.NO = TRIM(FIELD(R.NEW(SDB.TYP.NO.OF.SDB.BR)<1,IJ,IJK>,'-',2))
                BRANCH.SDB.TOT = END.NO - START.NO + 1
                TOT.SDB.NO += BRANCH.SDB.TOT
            NEXT IJK
        NEXT IJ
        R.NEW(SDB.TYP.TOT.NO.SDB) = TOT.SDB.NO
    END

    RETURN

*************************************************************************
AFTER.UNAU.WRITE:


    RETURN

*************************************************************************
AFTER.AUTH.WRITE:


    RETURN

*************************************************************************


BEFORE.AUTH.WRITE:

    //    START.NO = FIELD(R.NEW(SDB.TYP.NO.OF.SDB.BR),'-',1)
    //    END.NO = FIELD(R.NEW(SDB.TYP.NO.OF.SDB.BR),'-',2)

    //    OLD.START.NO = FIELD(R.OLD(SDB.TYP.NO.OF.SDB.BR),'-',1)
    //    OLD.END.NO = FIELD(R.OLD(SDB.TYP.NO.OF.SDB.BR),'-',2)

    BEGIN CASE
    CASE R.NEW(V-8)[1,3] = "INA" OR R.NEW(V-8)[1,3] = "CNA"

        BR.CODE.ARR=R.NEW(SDB.TYP.BRANCH.CODE)<1>
        NO.NEW.BR = DCOUNT(BR.CODE.ARR, VM)

        IF R.OLD(SDB.TYP.NO.OF.SDB.BR) EQ '' THEN
            FOR NO.BR = 1 TO NO.NEW.BR

                SDB.NEW.BOX.ARR = R.NEW(SDB.TYP.NO.OF.SDB.BR)<1,NO.BR>
                NO.NEW.SUB.VAL = DCOUNT(SDB.NEW.BOX.ARR,SM)
                COMPANY.CODE = R.NEW(SDB.TYP.BRANCH.CODE)<1,NO.BR>

                FOR TEMP.VAR = 1 TO NO.NEW.SUB.VAL
                    SUB.NEW.VAL = SDB.NEW.BOX.ARR<1,1,TEMP.VAR>
                    SUB.NEW.ST.NO = TRIM(FIELD(SUB.NEW.VAL,'-',1))
                    SUB.NEW.ED.NO = TRIM(FIELD(SUB.NEW.VAL,'-',2))

                    R.MB.SDB.STATUS<SDB.STA.STATUS> = 'AVAILABLE'

                    IF NOT(R.MB.SDB.STATUS<SDB.STA.CURR.NO>) THEN
                        R.MB.SDB.STATUS<SDB.STA.CURR.NO> = 1
                    END

                    XX = ''; XX = OCONV(DATE(),"D-"); XX.TIME = TIMEDATE()
                    XX = XX[9,2]:XX[1,2]:XX[4,2]:XX.TIME[1,2]:XX.TIME[4,2]
                    R.MB.SDB.STATUS<SDB.STA.DATE.TIME> = XX
                    R.MB.SDB.STATUS<SDB.STA.INPUTTER,1> = TNO:'_':OPERATOR
                    R.MB.SDB.STATUS<SDB.STA.AUTHORISER> = TNO:'_':OPERATOR

                    FOR SDB.CNT = SUB.NEW.ST.NO TO SUB.NEW.ED.NO
                        WRITE.ID = COMPANY.CODE:'.':ID.NEW:'.':SDB.CNT
                        CALL F.WRITE(FN.MB.SDB.STATUS,WRITE.ID,R.MB.SDB.STATUS)
                    NEXT SDB.CNT

                NEXT TEMP.VAR
            NEXT NO.BR
        END ELSE
            IF R.OLD(SDB.TYP.NO.OF.SDB.BR) NE R.NEW(SDB.TYP.NO.OF.SDB.BR) THEN
                GOSUB CHECK.BRANCH.LIST
            END
        END

    CASE R.NEW(V-8)[1,3] = "RNA"
        BR.CODE.ARR=R.NEW(SDB.TYP.BRANCH.CODE)<1>
        NO.NEW.BR = DCOUNT(BR.CODE.ARR, VM)

        FOR NO.BR = 1 TO NO.NEW.BR

            SDB.NEW.BOX.ARR = R.NEW(SDB.TYP.NO.OF.SDB.BR)<1,NO.BR>
            NO.NEW.SUB.VAL = DCOUNT(SDB.NEW.BOX.ARR,SM)
            COMPANY.CODE = R.NEW(SDB.TYP.BRANCH.CODE)<1,NO.BR>

            FOR TEMP.VAR = 1 TO NO.NEW.SUB.VAL
                SUB.NEW.VAL = SDB.NEW.BOX.ARR<1,1,TEMP.VAR>
                SUB.NEW.ST.NO = TRIM(FIELD(SUB.NEW.VAL,'-',1))
                SUB.NEW.ED.NO = TRIM(FIELD(SUB.NEW.VAL,'-',2))

                FOR SDB.CNT = SUB.NEW.ST.NO TO SUB.NEW.ED.NO
                    DELETE.ID = COMPANY.CODE:'.':ID.NEW:'.':SDB.CNT
                    CALL F.DELETE(FN.MB.SDB.STATUS, DELETE.ID)
                NEXT SDB.CNT
            NEXT TEMP.VAR
        NEXT NO.BR

    END CASE

    RETURN
************************************************************************
CHECK.BRANCH.LIST:

    SDB.BRANCH.ARR = R.NEW(SDB.TYP.BRANCH.CODE)
    NO.BRANCH = DCOUNT(SDB.BRANCH.ARR,VM)

    AV.SAVE = AV
    FOR AV = 1 TO NO.BRANCH
        GOSUB CHECK.SDB.LIST
    NEXT AV

    AV = AV.SAVE

    RETURN
*************************************************************************
CHECK.SDB.LIST:

    SDB.NEW.BOX.ARR = R.NEW(SDB.TYP.NO.OF.SDB.BR)<1,AV>
    SDB.OLD.BOX.ARR = R.OLD(SDB.TYP.NO.OF.SDB.BR)<1,AV>

    IF SDB.OLD.BOX.ARR EQ '' THEN

        NO.NEW.SUB.VAL = DCOUNT(SDB.NEW.BOX.ARR,SM)
        COMPANY.CODE = R.NEW(SDB.TYP.BRANCH.CODE)<1,AV>

        FOR NEW.VAR = 1 TO NO.NEW.SUB.VAL
            SUB.NEW.VAL = SDB.NEW.BOX.ARR<1,1,NEW.VAR>
            SUB.NEW.ST.NO = TRIM(FIELD(SUB.NEW.VAL,'-',1))
            SUB.NEW.ED.NO = TRIM(FIELD(SUB.NEW.VAL,'-',2))

            R.MB.SDB.STATUS<SDB.STA.STATUS> = 'AVAILABLE'

            IF NOT(R.MB.SDB.STATUS<SDB.STA.CURR.NO>) THEN
                R.MB.SDB.STATUS<SDB.STA.CURR.NO> = 1
            END

            XX = ''; XX = OCONV(DATE(),"D-"); XX.TIME = TIMEDATE()
            XX = XX[9,2]:XX[1,2]:XX[4,2]:XX.TIME[1,2]:XX.TIME[4,2]
            R.MB.SDB.STATUS<SDB.STA.DATE.TIME> = XX
            R.MB.SDB.STATUS<SDB.STA.INPUTTER,1> = TNO:'_':OPERATOR
            R.MB.SDB.STATUS<SDB.STA.AUTHORISER> = TNO:'_':OPERATOR


            FOR SDB.CNT = SUB.NEW.ST.NO TO SUB.NEW.ED.NO
                WRITE.ID = COMPANY.CODE:'.':ID.NEW:'.':SDB.CNT
                CALL F.WRITE(FN.MB.SDB.STATUS,WRITE.ID,R.MB.SDB.STATUS)
            NEXT SDB.CNT

        NEXT NEW.VAR

    END ELSE
        COMPANY.CODE = R.NEW(SDB.TYP.BRANCH.CODE)<1,AV>
        NO.OLD.SUB.VAL = DCOUNT(SDB.OLD.BOX.ARR,SM)
        NO.NEW.SUB.VAL = DCOUNT(SDB.NEW.BOX.ARR,SM)
        IF NO.OLD.SUB.VAL EQ NO.NEW.SUB.VAL THEN
            GOSUB CHANGE.SDB
        END ELSE
            GOSUB CHANGE.SDB
            NO.OLD.SUB.VAL = NO.OLD.SUB.VAL + 1

            FOR NEW.VAR = NO.OLD.SUB.VAL TO NO.NEW.SUB.VAL
                SUB.NEW.VAL = SDB.NEW.BOX.ARR<1,1,NEW.VAR>
                SUB.NEW.ST.NO = TRIM(FIELD(SUB.NEW.VAL,'-',1))
                SUB.NEW.ED.NO = TRIM(FIELD(SUB.NEW.VAL,'-',2))

                R.MB.SDB.STATUS<SDB.STA.STATUS> = 'AVAILABLE'

                IF NOT(R.MB.SDB.STATUS<SDB.STA.CURR.NO>) THEN
                    R.MB.SDB.STATUS<SDB.STA.CURR.NO> = 1
                END

                XX = ''; XX = OCONV(DATE(),"D-"); XX.TIME = TIMEDATE()
                XX = XX[9,2]:XX[1,2]:XX[4,2]:XX.TIME[1,2]:XX.TIME[4,2]
                R.MB.SDB.STATUS<SDB.STA.DATE.TIME> = XX
                R.MB.SDB.STATUS<SDB.STA.INPUTTER,1> = TNO:'_':OPERATOR
                R.MB.SDB.STATUS<SDB.STA.AUTHORISER> = TNO:'_':OPERATOR

                FOR SDB.CNT = SUB.NEW.ST.NO TO SUB.NEW.ED.NO
                    WRITE.ID = COMPANY.CODE:'.':ID.NEW:'.':SDB.CNT
                    CALL F.WRITE(FN.MB.SDB.STATUS,WRITE.ID,R.MB.SDB.STATUS)
                NEXT SDB.CNT

            NEXT NEW.VAR
        END
    END

    RETURN
**************************************************************************
CHANGE.SDB:

    FOR OLD.VAR = 1 TO NO.OLD.SUB.VAL
        SUB.NEW.VAL = SDB.NEW.BOX.ARR<1,1,OLD.VAR>
        SUB.OLD.VAL = SDB.OLD.BOX.ARR<1,1,OLD.VAR>
        IF SUB.OLD.VAL NE '' AND SUB.NEW.VAL NE '' THEN

            SUB.NEW.ST.NO = TRIM(FIELD(SUB.NEW.VAL,'-',1))
            SUB.NEW.ED.NO = TRIM(FIELD(SUB.NEW.VAL,'-',2))
            SUB.OLD.ST.NO = TRIM(FIELD(SUB.OLD.VAL,'-',1))
            SUB.OLD.ED.NO = TRIM(FIELD(SUB.OLD.VAL,'-',2))

            IF SUB.NEW.ST.NO < SUB.OLD.ST.NO THEN
                SUB.OLD.ST.NO = SUB.OLD.ST.NO - 1
                FOR SDB.CNT = SUB.NEW.ST.NO TO SUB.OLD.ST.NO
                    R.MB.SDB.STATUS<SDB.STA.STATUS> = 'AVAILABLE'

                    IF NOT(R.MB.SDB.STATUS<SDB.STA.CURR.NO>) THEN
                        R.MB.SDB.STATUS<SDB.STA.CURR.NO> = 1
                    END

                    XX = ''; XX = OCONV(DATE(),"D-"); XX.TIME = TIMEDATE()
                    XX = XX[9,2]:XX[1,2]:XX[4,2]:XX.TIME[1,2]:XX.TIME[4,2]
                    R.MB.SDB.STATUS<SDB.STA.DATE.TIME> = XX
                    R.MB.SDB.STATUS<SDB.STA.INPUTTER,1> = TNO:'_':OPERATOR
                    R.MB.SDB.STATUS<SDB.STA.AUTHORISER> = TNO:'_':OPERATOR

                    WRITE.ID = COMPANY.CODE:'.':ID.NEW:'.':SDB.CNT
                    CALL F.WRITE(FN.MB.SDB.STATUS,WRITE.ID,R.MB.SDB.STATUS)
                NEXT SDB.CNT
            END

            IF SUB.NEW.ED.NO > SUB.OLD.ED.NO THEN
                SUB.OLD.ED.NO = SUB.OLD.ED.NO + 1
                FOR SDB.CNT = SUB.OLD.ED.NO TO SUB.NEW.ED.NO
                    R.MB.SDB.STATUS<SDB.STA.STATUS> = 'AVAILABLE'

                    IF NOT(R.MB.SDB.STATUS<SDB.STA.CURR.NO>) THEN
                        R.MB.SDB.STATUS<SDB.STA.CURR.NO> = 1
                    END

                    XX = ''; XX = OCONV(DATE(),"D-"); XX.TIME = TIMEDATE()
                    XX = XX[9,2]:XX[1,2]:XX[4,2]:XX.TIME[1,2]:XX.TIME[4,2]
                    R.MB.SDB.STATUS<SDB.STA.DATE.TIME> = XX
                    R.MB.SDB.STATUS<SDB.STA.INPUTTER,1> = TNO:'_':OPERATOR
                    R.MB.SDB.STATUS<SDB.STA.AUTHORISER> = TNO:'_':OPERATOR

                    WRITE.ID = COMPANY.CODE:'.':ID.NEW:'.':SDB.CNT
                    CALL F.WRITE(FN.MB.SDB.STATUS,WRITE.ID,R.MB.SDB.STATUS)
                NEXT SDB.CNT

            END
        END

    NEXT OLD.VAR

    RETURN
**************************************************************************
CHECK.FUNCTION:

    IF INDEX('V',V$FUNCTION,1) THEN
        E = 'EB.RTN.FUNT.NOT.ALLOWED.APP'
        CALL ERR
        V$FUNCTION = ''
    END

    RETURN

*************************************************************************
INITIALISE:

    FN.MB.SDB.PARAM = 'F.MB.SDB.PARAM'
    F.MB.SDB.PARAM = ''
    CALL OPF(FN.MB.SDB.PARAM,F.MB.SDB.PARAM)

    FN.MB.SDB.STATUS = 'F.MB.SDB.STATUS'
    F.MB.SDB.STATUS = ''
    CALL OPF(FN.MB.SDB.STATUS,F.MB.SDB.STATUS)

    MB.SDB.PARAM.ID = ID.COMPANY
    R.MB.SDB.PARAM = ''; YERR = ''
    CALL F.READ(FN.MB.SDB.PARAM,MB.SDB.PARAM.ID,R.MB.SDB.PARAM,F.MB.SDB.PARAM,YERR)

    VAT.PERCENT = R.MB.SDB.PARAM<SDB.PAR.VAT.PERCENT>
    R.MB.SDB.STATUS = ''

    RETURN

*************************************************************************
READ.MB.SDB.PARAM:

    MB.SDB.PARAM.ID = COMPANY.CODE
    R.MB.SDB.PARAM = ''; YERR = ''
    CALL F.READ(FN.MB.SDB.PARAM,MB.SDB.PARAM.ID,R.MB.SDB.PARAM,F.MB.SDB.PARAM,YERR)
    VAT.PERCENT = R.MB.SDB.PARAM<SDB.PAR.VAT.PERCENT>

    RETURN

*************************************************************************
DEFINE.PARAMETERS:

    CALL MB.SDB.TYPE.FIELD.DEFINITIONS

    RETURN

*************************************************************************

END



