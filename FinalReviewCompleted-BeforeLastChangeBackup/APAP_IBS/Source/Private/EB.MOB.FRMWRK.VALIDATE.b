$PACKAGE APAP.IBS
* Version 2 02/06/00  GLOBUS Release No. G11.0.00 29/06/00
*-----------------------------------------------------------------------------
* <Rating>-27</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE EB.MOB.FRMWRK.VALIDATE
*-----------------------------------------------------------------------------
    !** Template FOR validation routines
* @author youremail@temenos.com
* @stereotype validator
* @package infra.eb
*!
*-----------------------------------------------------------------------------
*** <region name= Modification History>
*-----------------------------------------------------------------------------
* 07/06/06 - BG_100011433
*            Creation
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*-----------------------------------------------------------------------------
*** </region>
*** <region name= Main section>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDARD.SELECTION

    GOSUB INITIALISE

    GOSUB PROCESS.MESSAGE
RETURN
*** </region>
*-----------------------------------------------------------------------------
VALIDATE:
* TODO - Add the validation code here.
* Set AF, AV and AS to the field, multi value and sub value and invoke STORE.END.ERROR
* Set ETEXT to point to the EB.ERROR.TABLE

*      AF = MY.FIELD.NAME                 <== Name of the field
*      ETEXT = 'EB-EXAMPLE.ERROR.CODE'    <== The error code
*      CALL STORE.END.ERROR               <== Needs to be invoked per error

    AF = 1          ;*ROUTINE

    ROUTINE.NAME = R.NEW(AF)

    COMPILED.OR.NOT = '' ; RETURN.INFO = ''
    CALL CHECK.ROUTINE.EXIST(ROUTINE.NAME, COMPILED.OR.NOT, RETURN.INFO)
    IF NOT(COMPILED.OR.NOT) THEN
        ETEXT = 'EB-ROUTINE.DOES.NOT.EXIST'
        CALL STORE.END.ERROR
    END

    AF = 2          ;*FILTER.RTN

    FILTER.RTN.NAME = R.NEW(AF)
    IF FILTER.RTN.NAME THEN
        COMPILED.OR.NOT = '' ; RETTURN.INFO = ''
        CALL CHECK.ROUTINE.EXIST(FILTER.RTN.NAME, COMPILED.OR.NOT, RETURN.INFO)
        IF NOT(COMPILED.OR.NOT) THEN
            ETEXT = 'EB-ROUTINE.DOES.NOT.EXIST'
            CALL STORE.END.ERROR
        END
    END

    AF = 3          ;*APPL

    REL.APPLS = R.NEW(AF)
    TOT.APPL = DCOUNT(REL.APPLS, @VM)
    FOR AV=1 TO TOT.APPL
        REL.APPL = REL.APPLS<1, AV>
        CALL GET.STANDARD.SELECTION.DETS(REL.APPL, REL.APPL.SS)

        AF = 4      ;*APPL.FIELDS

        FIELD.NAMES = R.NEW(AF)<1, AV>
        TOT.FIELDS = DCOUNT(FIELD.NAMES, @SM)

        FOR AS=1 TO TOT.FIELDS
            REL.FIELD.NAME = FIELD.NAMES<1, 1, AS>
            IF INDEX(REL.FIELD.NAME , '>', 1) THEN
                REL.FIELD.NAME = REL.FIELD.NAME['>',1,1]
            END
            LOCATE REL.FIELD.NAME IN REL.APPL.SS<SSL.SYS.FIELD.NAME, 1> SETTING FLD.POS ELSE
                LOCATE REL.FIELD.NAME IN REL.APPL.SS<SSL.USR.FIELD.NAME, 1> SETTING FLD.POS ELSE
                    ETEXT = 'EB-INVALID.FIELD.NAME'
                    CALL STORE.END.ERROR
                END
            END

            AF = 5  ;*APPL.COL.NAMES

            IF R.NEW(AF)<1, AV, AS> EQ '' THEN
                R.NEW(AF)<1, AV, AS> = REL.FIELD.NAME
            END
        NEXT AS

    NEXT AV

    ROUTINE.NAME = ''

    AV = 1 ; AS = 1
    AF = 6          ;*INPUT.FORMATTER

    ROUTINE.NAME = R.NEW(AF)
    IF ROUTINE.NAME THEN
        COMPILED.OR.NOT = '' ; RETURN.INFO = ''
        CALL CHECK.ROUTINE.EXIST(ROUTINE.NAME, COMPILED.OR.NOT, RETURN.INFO)
        IF NOT(COMPILED.OR.NOT) THEN
            ETEXT = 'EB-ROUTINE.DOES.NOT.EXIST'
            CALL STORE.END.ERROR
        END
    END

    ROUTINE.NAME = ''
    AF = 7          ;*OUTPUT.FORMATTER

    ROUTINE.NAME = R.NEW(AF)

    IF ROUTINE.NAME THEN
        COMPILED.OR.NOT = '' ; RETURN.INFO = ''
        CALL CHECK.ROUTINE.EXIST(ROUTINE.NAME, COMPILED.OR.NOT, RETURN.INFO)
        IF NOT(COMPILED.OR.NOT) THEN
            ETEXT = 'EB-ROUTINE.DOES.NOT.EXIST'
            CALL STORE.END.ERROR
        END
    END


RETURN
*-----------------------------------------------------------------------------
*** <region name= Initialise>
INITIALISE:
***

*
RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= Process Message>
PROCESS.MESSAGE:
    BEGIN CASE
        CASE MESSAGE EQ ''        ;* Only during commit...
            BEGIN CASE
                CASE V$FUNCTION EQ 'D'
                    GOSUB VALIDATE.DELETE
                CASE V$FUNCTION EQ 'R'
                    GOSUB VALIDATE.REVERSE
                CASE OTHERWISE        ;* The real VALIDATE...
                    GOSUB VALIDATE
            END CASE
        CASE MESSAGE EQ 'AUT' OR MESSAGE EQ 'VER'     ;* During authorisation and verification...
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
END
