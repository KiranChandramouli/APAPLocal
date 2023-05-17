* Version 2 02/06/00  GLOBUS Release No. G11.0.00 29/06/00
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.CCRG.BALANCE.TYPE.PARAM.VALIDATE
*-----------------------------------------------------------------------------
** Template FOR validation routines : Application REDO.CCRG.BALANCE.TYPE.PARAM
* @author hpasquel@temenos.com
* @stereotype validator
* @package redo.ccrg
*!
*-----------------------------------------------------------------------------
*** <region name= Modification History>
*-----------------------------------------------------------------------------
* 23/03/2011 - APAP : B5 - ODR-2011-03-0154
*              First Version
*-----------------------------------------------------------------------------
*** </region>
*** <region name= Main section>
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.REDO.CCRG.BALANCE.TYPE.PARAM
    $INSERT I_REDO.CCRG.CONSTANT.COMMON
*
    GOSUB INITIALISE
    GOSUB PROCESS.MESSAGE
RETURN
*** </region>
*-----------------------------------------------------------------------------
VALIDATE:
* TODO - Add the validation code here.
* Set AF, AV and AS to the field, multi value and sub value and invoke STORE.END.ERROR
* Set ETEXT to point to the EB.ERROR.TABLE

    E = ''
    ETEXT = ''
    END.ERROR = ''

*      No dups on BALANCE.TYPE
    AF = REDO.CCRG.BTP.BALANCE.TYPE
    CALL DUP
    IF END.ERROR THEN
        RETURN
    END

* First Balance.Type must not be null
    IF S.REDO.CHECK.EMPTY.FIELD(REDO.CCRG.BTP.BALANCE.TYPE,1,1, @TRUE) THEN
        RETURN
    END

* Check Definition for each Balance.Type
    Y.TOT.BTS = DCOUNT(R.NEW(REDO.CCRG.BTP.BALANCE.TYPE), @VM)
    FOR Y.I = 1 TO Y.TOT.BTS
        IF S.REDO.CHECK.EMPTY.FIELD(REDO.CCRG.BTP.FIELD.NO, Y.I, 1, @TRUE) THEN
            RETURN
        END
        AV = Y.I
        GOSUB VAL.BALANCE.TYPE
        IF END.ERROR THEN
            BREAK
        END
    NEXT Y.I

RETURN
*-----------------------------------------------------------------------------
*** <region name= Initialise>
INITIALISE:
***

    Y.RETRY = @TRUE
*
RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= Process Message>
PROCESS.MESSAGE:
    BEGIN CASE
        CASE MESSAGE EQ ''          ;* Only during commit...
            BEGIN CASE
                CASE V$FUNCTION EQ 'D'
                    GOSUB VALIDATE.DELETE
                CASE V$FUNCTION EQ 'R'
                    GOSUB VALIDATE.REVERSE
                CASE OTHERWISE  ;* The real VALIDATE...
                    GOSUB VALIDATE
            END CASE
        CASE MESSAGE EQ 'AUT' OR MESSAGE EQ 'VER'       ;* During authorisation and verification...
            GOSUB VALIDATE.AUTHORISATION
    END CASE
*
RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.DELETE>
VALIDATE.DELETE:
* Any special checks for deletion

RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.REVERSE>
VALIDATE.REVERSE:
* Any special checks for reversal

RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.AUTHORISATION>
VALIDATE.AUTHORISATION:
* Any special checks for authorisation

RETURN
*** </region>
*-----------------------------------------------------------------------------
VAL.BALANCE.TYPE:
*-----------------------------------------------------------------------------
* Check Blank Fields

    Y.TOT.FIELDS = COUNT(R.NEW(REDO.CCRG.BTP.FIELD.NO)<1,AV>,@SM) + 1
    Y.TF = 1
    LOOP
    WHILE Y.TF LE Y.TOT.FIELDS
        IF R.NEW(REDO.CCRG.BTP.FIELD.NO)<1,AV,Y.TF> EQ '' THEN
            GOSUB CHECK.FIELD.NO
            IF END.ERROR THEN
                RETURN
            END
        END

        IF Y.RETRY THEN
            Y.TF = 1
            Y.TOT.FIELDS = COUNT(R.NEW(REDO.CCRG.BTP.FIELD.NO)<1,AV>,@SM) + 1
            Y.RETRY = @FALSE
        END ELSE
            Y.TF += 1
        END
    REPEAT

* Check subvalues definition
    Y.TOT.FIELDS = COUNT(R.NEW(REDO.CCRG.BTP.FIELD.NO)<1,AV>,@SM) + 1
    FOR Y.TF = 1 TO Y.TOT.FIELDS
        IF R.NEW(REDO.CCRG.BTP.FIELD.NO)<1,AV,Y.TF> NE '' THEN
            GOSUB CHECK.FIELD.DEF
        END
        IF END.ERROR THEN
            RETURN
        END
* BOOL.OPER is mandatory when there are more than 1 field.no
        IF Y.TF GT 1 AND S.REDO.CHECK.EMPTY.FIELD(REDO.CCRG.BTP.BOOL.OPER,AV,Y.TF-1, @TRUE) THEN
            RETURN
        END
        IF Y.TF EQ Y.TOT.FIELDS THEN
            R.NEW(REDO.CCRG.BTP.BOOL.OPER)<1, AV, Y.TF> = ''
        END
    NEXT Y.TF

RETURN
*-----------------------------------------------------------------------------
CHECK.FIELD.DEF:
* Check related sub.values to FIELD.NO field
*-----------------------------------------------------------------------------
* Operator
    IF S.REDO.CHECK.EMPTY.FIELD(REDO.CCRG.BTP.OPERATOR,AV,Y.TF, @TRUE) THEN
        RETURN
    END
* Min value is always required
    IF S.REDO.CHECK.EMPTY.FIELD(REDO.CCRG.BTP.MIN.VALUE,AV,Y.TF, @TRUE) THEN
        RETURN
    END
* According the operator check, MaxValue
    BEGIN CASE
        CASE R.NEW(REDO.CCRG.BTP.OPERATOR)<1,AV,Y.TF> MATCHES 'RG' : @VM : 'NR'
            IF S.REDO.CHECK.EMPTY.FIELD(REDO.CCRG.BTP.MAX.VALUE,AV,Y.TF, @TRUE) THEN
                RETURN
            END
        CASE R.NEW(REDO.CCRG.BTP.OPERATOR)<1,AV,Y.TF> MATCHES 'EQ' : @VM : 'NE'
* Clear Max.value in case of NE or EQ operator
            R.NEW(REDO.CCRG.BTP.MAX.VALUE)<1,AV,Y.TF> = ''
    END CASE
RETURN
*-----------------------------------------------------------------------------
CHECK.FIELD.NO:
* Check if the related sub-values are blank
*-----------------------------------------------------------------------------

    Y.CHECK = R.NEW(REDO.CCRG.BTP.OPERATOR)<1,AV,Y.TF>
    Y.CHECK := R.NEW(REDO.CCRG.BTP.MIN.VALUE)<1,AV,Y.TF>
    Y.CHECK := R.NEW(REDO.CCRG.BTP.MAX.VALUE)<1,AV,Y.TF>
    Y.CHECK := R.NEW(REDO.CCRG.BTP.BOOL.OPER)<1,AV,Y.TF>

* All related sub-values are blanks too, then removed it
    IF Y.CHECK EQ '' THEN
        IF Y.TOT.FIELDS GT 1 THEN
            GOSUB DELETE.FIELD.DEF
        END
        RETURN
    END

* No, then ask to the user
    TEXT = 'FIELD.NO MISSING, RELATED VALUES WILL BE BLANKED'
    CALL OVE
    AF = REDO.CCRG.BTP.FIELD.NO
    AS = Y.TF
    IF TEXT EQ "NO" THEN
        Y.DUMMY = S.REDO.CHECK.EMPTY.FIELD(REDO.CCRG.BTP.FIELD.NO, AV, Y.TF, @TRUE)
        RETURN
    END
*
    R.NEW(REDO.CCRG.BTP.OPERATOR)<1,AV, Y.TF>  = ''
    R.NEW(REDO.CCRG.BTP.MIN.VALUE)<1,AV, Y.TF> = ''
    R.NEW(REDO.CCRG.BTP.MAX.VALUE)<1,AV, Y.TF> = ''
    R.NEW(REDO.CCRG.BTP.BOOL.OPER)<1,AV, Y.TF> = ''
* If this is not the first position, then remove it. First position can not be removed
    GOSUB DELETE.FIELD.DEF
*
RETURN
*-----------------------------------------------------------------------------
DELETE.FIELD.DEF:
* Remove the subvalue
*-----------------------------------------------------------------------------

    DEL R.NEW(REDO.CCRG.BTP.FIELD.NO)<1,AV, Y.TF>
    DEL R.NEW(REDO.CCRG.BTP.OPERATOR)<1,AV, Y.TF>
    DEL R.NEW(REDO.CCRG.BTP.MIN.VALUE)<1,AV, Y.TF>
    DEL R.NEW(REDO.CCRG.BTP.MAX.VALUE)<1,AV, Y.TF>
    DEL R.NEW(REDO.CCRG.BTP.BOOL.OPER)<1,AV, Y.TF>
    Y.RETRY = @TRUE   ;* One field was removed, then the process must be re-executed

RETURN
*-----------------------------------------------------------------------------
END
