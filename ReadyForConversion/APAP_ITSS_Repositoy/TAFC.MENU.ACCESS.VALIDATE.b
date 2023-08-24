*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE TAFC.MENU.ACCESS.VALIDATE
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PGM.FILE
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.TAFC.MENU.ACCESS
*-----------------------------------------------------------------------------
* For Future Use..... We can Introduce a Validation Routine later.

    GOSUB INITIALISE

    GOSUB MAIN.PROCESS

    RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*----------

    VER.ERR = '' ; SS.ID = '' ; APPL.SS.REC = ''

    FN.VERSION = 'F.VERSION'
    F.VERSION = ''
    CALL OPF(FN.VERSION, F.VERSION)

    FN.PGM.FILE = 'F.PGM.FILE'
    F.PGM.FILE = ''
    CALL OPF(FN.PGM.FILE, F.PGM.FILE)

    RETURN

*-----------------------------------------------------------------------------
MAIN.PROCESS:
*------------

*    AF = 3
    AF = EB.TMA.CASE.DESC
    DCNT = DCOUNT(R.NEW(AF), @VM)

    FOR AV = 1 TO DCNT

        IF R.NEW(4)<1,AV> EQ '' AND R.NEW(9)<1, AV> EQ '' AND R.NEW(10)<1, AV> EQ '' AND R.NEW(11)<1, AV> EQ '' THEN
            FOR I=4 TO 11
                AF = I
                ETEXT = 'EITHER OF THIS IS MANDATORY'
                CALL STORE.END.ERROR
                IF I EQ 4 THEN I = 8
            NEXT I
            ETEXT = ''
        END

        BEGIN CASE
        CASE R.NEW(4)<1,AV> NE '' AND (R.NEW(9)<1, AV> NE '' OR R.NEW(10)<1, AV> NE '' OR R.NEW(11)<1, AV> NE '')
            ETEXT = 'ONLY ONE OF THIS CAN BE CONFIGURED'
        CASE R.NEW(9)<1, AV> NE '' AND (R.NEW(4)<1, AV> NE '' OR R.NEW(10)<1, AV> NE '' OR R.NEW(11)<1, AV> NE '')
            ETEXT = 'ONLY ONE OF THIS CAN BE CONFIGURED'
        CASE R.NEW(10)<1, AV> NE '' AND (R.NEW(4)<1, AV> NE '' OR R.NEW(9)<1, AV> NE '' OR R.NEW(11)<1, AV> NE '')
            ETEXT = 'ONLY ONE OF THIS CAN BE CONFIGURED'
        CASE R.NEW(11)<1, AV> NE '' AND (R.NEW(4)<1, AV> NE '' OR R.NEW(9)<1, AV> NE '' OR R.NEW(10)<1, AV> NE '')
            ETEXT = 'ONLY ONE OF THIS CAN BE CONFIGURED'
        END CASE
        IF ETEXT THEN
            FOR I=4 TO 11
                AF = I
                ETEXT = 'ONLY ONE OF THIS CAN BE CONFIGURED'
                CALL STORE.END.ERROR
                IF I EQ 4 THEN I = 8
            NEXT I
            ETEXT = ''
        END

*        AF = 4
        AF = EB.TMA.APPL.VERSION
        APPL.VER = R.NEW(AF)<1, AV>
*               LOC.APPL = APPL.VER[',', 1, 1]

        IF APPL.VER NE '' THEN
            IF INDEX(APPL.VER, ',', 1) THEN
                CALL F.READ(FN.VERSION, APPL.VER, R.VER, F.VERSION, VER.ERR)
            END ELSE
                CALL F.READ(FN.PGM.FILE, APPL.VER, R.PGM.FILE, F.PGM.FILE, VER.ERR)
                IF NOT(VER.ERR) THEN
                    IF R.PGM.FILE<EB.PGM.TYPE> MATCHES 'H':@VM:'U':@VM:'W' ELSE
                        VER.ERR = 'NOT A VALID APPLICATION'
                    END
                END ELSE
                    VER.ERR = 'EB-APPLN.MISS'
                END
            END

            IF VER.ERR THEN
                ETEXT = VER.ERR
                CALL STORE.END.ERROR
            END ELSE
                SS.ID = APPL.VER[',', 1, 1]
                CALL GET.STANDARD.SELECTION.DETS(SS.ID, APPL.SS.REC)
                FN.APPL = 'F.':SS.ID
            END
        END

*        AF = 5
        AF = EB.TMA.FUNCTION
        APPL.FUNC = R.NEW(AF)<1, AV>

        BEGIN CASE
        CASE APPL.VER EQ '' AND APPL.FUNC NE ''
            ETEXT = 'NOT A VALID FUNCTION FOR OPERATION'
        CASE APPL.VER NE '' AND APPL.FUNC EQ ''
            ETEXT = 'MANDATORY INPUT IF APPL.VER IS SET'
        CASE APPL.FUNC NE '' AND NOT(APPL.FUNC MATCHES 'I':@VM:'A':@VM:'V')
            ETEXT = 'NOT A VALID FUNCTION FOR OPERATION'
        END CASE
        IF ETEXT NE '' THEN
            CALL STORE.END.ERROR
        END

*        AF = 6
        AF = EB.TMA.APPL.ID
        APPL.TXN.ID = R.NEW(AF)<1, AV>
        BEGIN CASE
        CASE APPL.VER EQ '' AND APPL.TXN.ID NE ''
            ETEXT = "NOT A VALID SETTING IF APPL.VER IS ''"
        CASE APPL.VER NE '' AND APPL.TXN.ID EQ ''
            ETEXT = 'MANDATORY INPUT IF APPL.VER IS SET'
        CASE APPL.TXN.ID NE ''
            APPL.ERR = ''
            CALL F.READ(FN.APPL, APPL.TXN.ID, R.APPL.TXN, '', APPL.ERR)
            IF APPL.ERR THEN
                ETEXT = 'NEW RECORDS NOT ALLOWED'
            END
        END CASE
        IF ETEXT NE '' THEN
            CALL STORE.END.ERROR
        END

*        AF = 7
        AF = EB.TMA.APPL.FLD
        TOT.FIELDS = DCOUNT(R.NEW(AF)<1, AV>, SM)
        FIELD.NAMES = R.NEW(AF)<1, AV>
        FOR AS=1 TO TOT.FIELDS
            APPL.FIELD.NAME = FIELD.NAMES<1, 1, AS>[':', 1, 1]
            LOCATE APPL.FIELD.NAME IN APPL.SS.REC<SSL.SYS.FIELD.NAME, 1> SETTING FLD.POS ELSE
                LOCATE APPL.FIELD.NAME IN APPL.SS.REC<SSL.USR.FIELD.NAME, 1> SETTING FLD.POS ELSE
                    ETEXT = 'EB-INVALID.FIELD.NAME'
                    CALL STORE.END.ERROR
                END
            END
        NEXT AS

*        AF = 9
        AF = EB.TMA.CALL.ROUT
        RTN.NAME = R.NEW(AF)<1, AV>
        IF RTN.NAME THEN
            GOSUB CHECK.ROUTINE
        END

*        AF = 10
        AF = EB.TMA.EXEC.JSH.CMD
*        JSH.CMD = R.NEW(AF)<1, AV>
        JSH.CMD = TRIM(R.NEW(AF)<1, AV>, " ", "B")[' ', 1, 1]
        IF JSH.CMD NE '' AND JSH.CMD NE 'RUNTIME' THEN
            EXECUTE 'jshow -c ':JSH.CMD CAPTURING JSHOW.OUT
            IF JSHOW.OUT<1,1>[':',1 , 1][' ', 1, 1] MATCHES 'Executable':@VM:'jCL':@VM:'Paragraph' ELSE
                ETEXT = 'NOT A VALID EXECUTABLE'
                CALL STORE.END.ERROR
                ETEXT = ''
            END
        END

*        AF = 11
        AF = EB.TMA.EXEC.SH.CMD
*        JSH.CMD = R.NEW(AF)<1, AV>
        JSH.CMD = TRIM(R.NEW(AF)<1, AV>, " ", "B")[' ', 1, 1]
        IF JSH.CMD NE '' AND JSH.CMD NE 'RUNTIME' THEN
            EXECUTE 'which ':JSH.CMD CAPTURING WHICH.OUT
            IF INDEX(WHICH.OUT, 'which: no ':JSH.CMD, 1) THEN
                ETEXT = 'DOES NOT EXIST'
                CALL STORE.END.ERROR
                ETEXT = ''
            END
        END


    NEXT AV

    RETURN

*-----------------------------------------------------------------------------
CHECK.ROUTINE:
*-------------

    IF RTN.NAME THEN
        COMPILED.OR.NOT = '' ; RETURN.INFO = ''
        CALL CHECK.ROUTINE.EXIST(RTN.NAME, COMPILED.OR.NOT, RETURN.INFO)
        IF NOT(COMPILED.OR.NOT) THEN
            ETEXT = 'EB-ROUTINE.DOES.NOT.EXIST'
            CALL STORE.END.ERROR
        END
    END

    RETURN

*-----------------------------------------------------------------------------

END
