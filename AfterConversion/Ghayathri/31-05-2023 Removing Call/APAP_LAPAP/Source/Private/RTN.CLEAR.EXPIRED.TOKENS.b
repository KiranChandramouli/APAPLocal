* @ValidationCode : MjoxMDQ0MDUzODU0OkNwMTI1MjoxNjg1NTM2OTIyNzQ1OmhhaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 18:12:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED
*21-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE RTN.CLEAR.EXPIRED.TOKENS

    $INSERT I_COMMON ;*R22 AUTO CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.SPF
    $INSERT I_F.USER ;*R22 AUTO CONVERSION END
 
    FN.OS.TOKEN = "F.OS.TOKEN"
    F.OS.TOKEN = ""
    CALL OPF(FN.OS.TOKEN,F.OS.TOKEN)

    FN.OS.TOKEN.USE = "F.OS.TOKEN.USE"
    F.OS.TOKEN.USE = ""
    CALL OPF(FN.OS.TOKEN.USE,F.OS.TOKEN.USE)

    FN.USER = "F.USER"
    F.USER = ""
    CALL OPF(FN.USER,F.USER)

    SEL.OTU = ''; SEL.OTUREC = ''; OTURECS.LIST = ''; SEL.OTUERR = ''
    SEL.OTU = "SELECT ":FN.OS.TOKEN.USE
    CALL EB.READLIST(SEL.CMD,SEL.REC,"",NO.OF.RECS,SEL.ERR)
    EXECUTE SEL.OTU RTNLIST OTURECS.LIST
    SEL.OTU1 = 'QSELECT F.OS.TOKEN.USE'
    EXECUTE SEL.OTU1 PASSLIST OTURECS.LIST RTNLIST SEL.OTUREC

    SEL.CMD = ''; SEL.REC = ''; NO.OF.RECS = ''; SEL.ERR = ''
    SEL.CMD = "SELECT ":FN.OS.TOKEN
    CALL EB.READLIST(SEL.CMD,SEL.REC,"",NO.OF.RECS,SEL.ERR)
    LOOP
        REMOVE TOKEN.ID FROM SEL.REC SETTING TOKEN.ID.POS
    WHILE TOKEN.ID:TOKEN.ID.POS
        TOK.RD.ERR = ''; R.OS.TOKEN = ''; R.TOK.USE = ''; TOK.USE.RD.ERR = ''
        CALL F.READ(FN.OS.TOKEN,TOKEN.ID,R.OS.TOKEN,F.OS.TOKEN,TOK.RD.ERR)
        IF NOT(TOK.RD.ERR) THEN
            GOSUB PROCESS.TOKEN
        END
    REPEAT
RETURN

PROCESS.TOKEN:
**************
    TIME.CREATED = R.OS.TOKEN<4>
    LAST.DATE = R.OS.TOKEN<5>
    CUR.DATE = DATE()
    CUR.TIME = TIME()
    REASON = ''
    USED.TIME = ''
* To remove TOKEN.USER from OS.TOKEN.USE
    TOKEN.USER =  R.OS.TOKEN<1>
    LOCATE TOKEN.ID IN SEL.OTUREC<1> SETTING TOKEN.IN.USE THEN
        IF (LAST.DATE LT CUR.DATE) THEN ;* lock out of date
            REASON = 'Token created on ':LAST.DATE:' but not cleared until ':CUR.DATE
            GOSUB DEL.TOKEN
            RETURN
        END
        IF (INDEX(TOKEN.ID, "*", 1)) THEN         ;* Delete only last day ARCIB records
            NULL
        END ELSE
            USED.TIME = CUR.TIME-TIME.CREATED
            IF (USED.TIME) GE 600 THEN          ;* Delete All tokens for internal users created before 10 minutes (User cannot be continuosly online more than 4 hours)
                HOURS = OCONV(USED.TIME,"MT.")
                REASON = "Token used for ":HOURS:" hours"
                GOSUB DEL.TOKEN
            END
        END
    END ELSE
* Delete all unused Tokens
        REASON = "Unable to find Token use. Redundant token"
        GOSUB DEL.TOKEN
    END
RETURN

DEL.TOKEN:
**********
    DELETE F.OS.TOKEN, TOKEN.ID
    PRINT "TOKEN ":TOKEN.ID:" FOR USER ":TOKEN.USER:" IS EXPIRED, SO REMOVED FROM F.OS.TOKEN REASON: ":REASON
RETURN
END
