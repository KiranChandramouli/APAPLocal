* Version 2 03/04/00  GLOBUS Release No. G10.1.02 28/10/99
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE INTRF.MAPPING.CHECK.FIELDS
************************************************************************
*
*
************************************************************************
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PGM.FILE
    $INSERT I_F.ENQUIRY
    $INSERT I_F.VERSION
    $INSERT I_F.ENQUIRY.SELECT
    $INSERT I_F.INTRF.MAPPING
    $INSERT I_F.STANDARD.SELECTION
************************************************************************
*
*
************************************************************************
*
    GOSUB INITIALISE
*
************************************************************************
*
* Default the current field if input is null and the field is null
*
    IF INDEX(R.NEW(INTRF.MAP.OFS.UTIL.NAME),'ENQUIRY.SELECT',1) THEN
        RETURN     ;* No checks for enquiry temp
    END
    BEGIN CASE
        CASE AS
            INTO.FIELD = R.NEW(AF)<1,AV,AS>
        CASE AV
            INTO.FIELD = R.NEW(AF)<1,AV>
        CASE OTHERWISE
            INTO.FIELD = R.NEW(AF)
    END CASE
*
    IF COMI EQ '' AND INTO.FIELD EQ '' THEN
        GOSUB DEFAULT.FIELDS
    END

*
* Real validation here....
*
    GOSUB CHECK.FIELDS

*
* Now default other fields from this one if there is a value...
*
    IF COMI THEN
        COMI.ENRI.SAVE = COMI.ENRI
        COMI.ENRI = ''
        GOSUB DEFAULT.OTHER.FIELDS
        COMI.ENRI = COMI.ENRI.SAVE
    END

************************************************************************
*
* All done here
*
RETURN
*
************************************************************************
* Local subroutines...
************************************************************************
*
INITIALISE:
    E = ''
    ETEXT = ''
    SVM.POS=''
    UVM.POS=''
    R.SS.APP=''
    ENRI=''
*
* Open files...
*
    FN.STANDARD.SELECTION = 'F.STANDARD.SELECTION'
    CALL OPF(FN.STANDARD.SELECTION,F.STANDARD.SELECTION)

    FN.PGM.FILE = 'F.PGM.FILE'
    F.PGM.FILE = ''
    CALL OPF(FN.PGM.FILE,F.PGM.FILE)

    FN.ENQUIRY.SELECT = 'F.ENQUIRY.SELECT'
    F.ENQUIRY.SELECT = ''
    CALL OPF(FN.ENQUIRY.SELECT,F.ENQUIRY.SELECT)

    FN.ENQUIRY = 'F.ENQUIRY'
    F.ENQUIRY = ''
    CALL OPF(FN.ENQUIRY,F.ENQUIRY)

    FN.VERSION = 'F.VERSION'
    F.VERSION = ''
    CALL OPF(FN.VERSION,F.VERSION)

*
    IF R.NEW(INTRF.MAP.APPLICATION) THEN
        APP.NAME = R.NEW(INTRF.MAP.APPLICATION)
        R.SS.APP=''
        CALL CACHE.READ(FN.STANDARD.SELECTION, APP.NAME, R.SS.APP, ER.SS)
    END

RETURN
*
************************************************************************
*
DEFAULT.FIELDS:
*
    BEGIN CASE
*         CASE AF = XX.FIELD.NUMBER
*            COMI = TODAY

    END CASE

    CALL REFRESH.FIELD(AF,'')

RETURN
************************************************************************
DEFAULT.OTHER.FIELDS:

    DEFAULTED.FIELD = ''
    DEFAULTED.ENRI = ''
    BEGIN CASE
        CASE AF EQ INTRF.MAP.OFS.UTIL.NAME
            CALL F.READ(FN.ENQUIRY.SELECT,COMI,R.ENQUIRY.SELECT,F.ENQUIRY.SELECT,ES.ERR)
            IF NOT(R.ENQUIRY.SELECT) THEN
                CALL CACHE.READ(FN.ENQUIRY, COMI, R.ENQUIRY, ENQUIRY.ERR)
                IF R.ENQUIRY THEN
                    TEMP.1 = R.ENQUIRY<ENQ.FILE.NAME>[1,6]
                    IF TEMP.1 NE 'NOFILE' THEN
                        E = 'INVALID INPUT'
                    END
                END ELSE
                    CALL CACHE.READ(FN.VERSION, COMI, R.COMI.VERSION, VERSION.ERR)
                    IF R.COMI.VERSION THEN
                        FILE.NAME = FIELD(COMI,',',1)
                        CALL CACHE.READ(FN.PGM.FILE, FILE.NAME, R.PGM.FILE, PF.ERR)
                        IF R.PGM.FILE THEN
                            IF R.PGM.FILE<EB.PGM.TYPE> NE 'H' THEN
                                E = 'INVALID INPUT'
                            END
                        END ELSE
                            E = 'INVALID INPUT'
                        END
                    END ELSE
                        E = 'INVALID INPUT'
                    END
                END
            END ELSE
                E = 'INVALID INPUT'
            END

        CASE AF EQ INTRF.MAP.GLO.FLD.NAME
            DEFAULTED.FIELD = INTRF.MAP.GLO.FLD.LN.TYPE<1,AV>
            IF INDEX(COMI,':',1) THEN
                FIELD.NAME = FIELD(COMI,':',1)
            END ELSE
                FIELD.NAME = COMI
            END
            IF NOT(INDEX(COMI,'LOCAL.REF',1)) THEN
                FIND FIELD.NAME IN R.SS.APP<SSL.SYS.FIELD.NAME> SETTING FM.POS,SVM.POS,SM.POS ELSE POSN =''
                IF NOT(SVM.POS) THEN
                    FIND FIELD.NAME IN R.SS.APP<SSL.USR.FIELD.NAME> SETTING FM.POS,UVM.POS,SM.POS ELSE POSN =''
                END
                IF (SVM.POS) THEN
                    ENRI = R.SS.APP<SSL.SYS.SINGLE.MULT,SVM.POS>
                    ENRI := R.SS.APP<SSL.SYS.DISPLAY.FMT,SVM.POS>
                END ELSE

                    IF (UVM.POS) THEN
                        ENRI = R.SS.APP<SSL.USR.SINGLE.MULT,UVM.POS>
                        ENRI:= R.SS.APP<SSL.USR.DISPLAY.FMT,UVM.POS>
                    END
                END
                DEFAULTED.ENRI = ENRI

                R.NEW(INTRF.MAP.GLO.FLD.LN.TYPE)<1,AV> = ENRI
            END

        CASE AF EQ INTRF.MAP.FIELD.SRC.VALUE
            GOSUB CHECK.INPUT

    END CASE

    CALL REFRESH.FIELD(DEFAULTED.FIELD, DEFAULTED.ENRI)

RETURN

CHECK.INPUT:

    BEGIN CASE
        CASE R.NEW(INTRF.MAP.FIELD.SOURCE)<1,AV> EQ 'RTN'
            CALL CACHE.READ(FN.PGM.FILE, COMI, R.PGM.FILE, PF.ERR)
            IF R.PGM.FILE<EB.PGM.TYPE> NE 'S' THEN
                E = 'SHOULD HAVE A VALID PGM.FILE ENTRY'
            END
        CASE R.NEW(INTRF.MAP.FIELD.SOURCE)<1,AV> EQ 'CON' OR R.NEW(INTRF.MAP.FIELD.SOURCE)<1,AV> EQ 'INT' OR R.NEW(INTRF.MAP.FIELD.SOURCE)<1,AV> EQ 'EXT'
            IF COMI THEN
                E = 'INPUT NOT ALLOWED FOR SOURCE TYPE CON'
            END
    END CASE

RETURN

*
************************************************************************
*
CHECK.FIELDS:
*
* Where an error occurs, set E
*
*
    BEGIN CASE

        CASE AF EQ INTRF.MAP.APPLICATION
            IF COMI MATCHES 'NOFILE...' THEN
                E = 'SHOULD BE A VALID APPLICATION'
            END
    END CASE

CHECK.FIELD.END:
*
RETURN
*
* ***********************************************************************
*
END
