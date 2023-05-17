* Version 3 21/07/00  GLOBUS Release No. G11.0.01 27/07/00
*-----------------------------------------------------------------------------
* <Rating>191</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.SDB.TYPE.CHECK.FIELDS
************************************************************************
* Check fields processsing for MB.SDB.TYPE
************************************************************************
* Modification History:
*
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MB.SDB.TYPE
*
    GOSUB INITIALISE
*
************************************************************************
* Default the current field if input is null and the field is null.
*
    BEGIN CASE
    CASE AS
        INTO.FIELD = R.NEW(AF)<1,AV,AS>
    CASE AV
        INTO.FIELD = R.NEW(AF)<1,AV>
    CASE OTHERWISE
        INTO.FIELD = R.NEW(AF)
    END CASE
*
    IF COMI = '' AND INTO.FIELD = '' THEN
        GOSUB DEFAULT.FIELDS
    END
*
* Real validation here.....
*
    GOSUB CHECK.FIELDS
*
* Now default other fields from this one if there is a value....
*
    IF COMI AND E = '' THEN
        COMI.ENRI.SAVE = COMI.ENRI
        COMI.ENRI = ''
        GOSUB DEFAULT.OTHER.FIELDS
        COMI.ENRI = COMI.ENRI.SAVE
    END

************************************************************************
*
* All done here.
*
    RETURN
*
************************************************************************
* Local subroutines....
************************************************************************
INITIALISE:
    E = ''
    ETEXT = ''
*
* Open files....
*
    RETURN
*
************************************************************************
DEFAULT.FIELDS:
*
    BEGIN CASE
*         CASE AF = MB.SDB.TYPE.FIELD.NUMBER
*            COMI = TODAY

    END CASE
* GB0001758
    CALL REFRESH.FIELD(AF,"")

    RETURN

************************************************************************
DEFAULT.OTHER.FIELDS:

    DEFAULTED.FIELD = ''
    DEFAULTED.ENRI = ''
    BEGIN CASE
*         CASE AF = MB.SDB.TYPE.FIELD.NUMBER
*              DEFAULTED.FIELD = MB.SDB.TYPE.FIELD.NUMBER
*              DEFAULTED.ENRI = ENRI

    END CASE

    CALL REFRESH.FIELD(DEFAULTED.FIELD, DEFAULTED.ENRI)

    RETURN
*
************************************************************************
CHECK.FIELDS:


* Where an error occurs, set E, E must be a key to EB.ERROR
*
    BEGIN CASE
* GB0001758

REM >         CASE AF = NAME.OF.THE.REQUIRED.FIELD
    CASE AF = SDB.TYP.NO.OF.SDB.BR


*   SDB.SUBVAL.ARR.MUL = R.NEW(6)<1,AV>
        AUTH.OLD.ARR = R.OLD(6)<1,AV>

        OLD.NEXT.CHECK.DATA=AUTH.OLD.ARR<1,1,AS>

*    IF OLD.NEXT.CHECK.DATA NE '' THEN
*    E = "Can't Insert Subvalues. Add to the last"
*    RETURN
*    END



* check if a range is specified as 1-200 to indicate the locker nos are from 1 to 200.

        SDB.SUBVAL.ARR = R.NEW(6)<1,AV>
        CNT = DCOUNT(SDB.SUBVAL.ARR,SM)

        OLD.START.NO = FIELD(R.OLD(SDB.TYP.NO.OF.SDB.BR),'-',1)
        IF INDEX(COMI,'-',1) THEN       ;* Check for - other was range.
            START.NO = TRIM(FIELD(COMI,'-',1))
            END.NO = TRIM(FIELD(COMI,'-',2))
* Check if the data input is sensible data. Only numeric allowed
            IF NUM(START.NO) AND NUM(END.NO) THEN
                IF START.NO GT END.NO THEN
                    E = 'Range starting number should be less than ending number'
                    RETURN
                END
*
                IF START.NO EQ '0' OR END.NO EQ '0' THEN
                    E = 'Zero not allowed. Starting no should be 1'
                    RETURN
                END

                FOR I = 1 TO CNT

                    DB.NO.RANGE = SDB.SUBVAL.ARR<1,1,I>
                    SUB.START.NO = TRIM(FIELD(DB.NO.RANGE,'-',1))
                    SUB.END.NO = TRIM(FIELD(DB.NO.RANGE,'-',2))


                    IF SUB.START.NO NE '' AND SUB.END.NO NE '' AND I NE AS THEN
                        IF SUB.START.NO LE END.NO AND SUB.END.NO GE START.NO THEN
                            E = 'Check the Range Starting and Ending number'
                            RETURN
                        END
                    END
                NEXT I

            END ELSE
                E = 'Enter numeric value for safe box nos.'
                RETURN
            END

        END ELSE
            E = '"-" missing. Invalid range. Use NNN-MMM'
            RETURN
        END
    END CASE
*

    RETURN
*
************************************************************************
*
END

