SUBROUTINE REDO.CH.NOFILE.PINDEF(R.DATA)
**
* Subroutine Type : ENQUIRY
* Attached to     : REDO.E.CH.PINDEF
* Attached as     : NOFILE.ROUTINE
* Primary Purpose : Assign the definitive PIN number to Channel User.
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 1/11/10 - First Version.
*           ODR Reference: ODR-2010-06-0155.
*           Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP).
*           Roberto Mondragon - TAM Latin America.
*           rmondragon@temenos.com
*
* 16/11/10 - Version changed from REDO.CH.PINADM, to REDO.CH.PINADM,NEWDEF to
*            be used in OFS message.
*            Roberto Mondragon - TAM Latin America.
*            rmondragon@temenos.com
*
*  5/12/11 - Update to key for PIN encryption.
*            Roberto Mondragon - TAM Latin America.
*            rmondragon@temenos.com
*
* 13/06/12 - Update for a new return code if arrangement doesn't exist.
*            Roberto Mondragon - TAM Latin America.
*            rmondragon@temenos.com
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_ENQUIRY.COMMON

    $INSERT I_F.ACCOUNT
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_F.REDO.CH.PINADM

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.EB.EXTERNAL.USER = 'F.EB.EXTERNAL.USER'
    F.EB.EXTERNAL.USER = ''
    CALL OPF(FN.EB.EXTERNAL.USER,F.EB.EXTERNAL.USER)

    FN.REDO.CH.PINADM = 'F.REDO.CH.PINADM'
    F.REDO.CH.PINADM = ''
    CALL OPF(FN.REDO.CH.PINADM,F.REDO.CH.PINADM)

    G.DATE = ''
    I.DATE = DATE()
    CALL DIETER.DATE(G.DATE,I.DATE,'')

    OFS.HEADER = ""
    OFS.BODY = ""
    OFS.MSG = ""
    OFS.SRC = "CHADMONPROC4"
    RESP.OFS.MSG= ""
    TXN.COMM= ""

    LOCATE "EXT.USR" IN D.FIELDS<1> SETTING EXT.USR.POS THEN
        EXT.USR = D.RANGE.AND.VALUE<EXT.USR.POS>
    END

    LOCATE "PIN.USR" IN D.FIELDS<1> SETTING PIN.POS THEN
        PIN.USR = D.RANGE.AND.VALUE<PIN.POS>
    END

    R.EB.EXTERNAL.USER = ''; EXT.USR.ERR = ''
    CALL CACHE.READ(FN.EB.EXTERNAL.USER, EXT.USR, R.EB.EXTERNAL.USER, EXT.USR.ERR)
    IF R.EB.EXTERNAL.USER THEN
        CUSTOMER.EXT.USR = R.EB.EXTERNAL.USER<EB.XU.CUSTOMER>
    END ELSE
        R.DATA<-1> = "2"
        RETURN
    END

*PIN Encription.
    KEYUSED = "7"
    PIN = ENCRYPT(PIN.USR,KEYUSED,2)

    STARTTIME = FIELD(TIMEDATE()," ",0)

*Definitive PIN number update for REDO.CH.PINADM application as an OFS message.
    OFS.HEADER = "REDO.CH.PINADM,NEWDEF/I/PROCESS/1/0,/,": EXT.USR :","
    OFS.BODY = "PIN:1:1=": PIN :","
    OFS.BODY := "START.DATE:1:1=": TODAY :","
    OFS.BODY := "START.TIME:1:1=": STARTTIME :","
    OFS.BODY := "TYPE:1:1=DEFINITIVO,"

    OFS.MSG = OFS.HEADER : OFS.BODY

*Update action with definitive PIN number inputted.
    CALL OFS.GLOBUS.MANAGER(OFS.SRC,OFS.MSG)

    TEMP = FIELD(OFS.MSG,"/",3)
    IF FIELD(TEMP,",",1) EQ "1" THEN
        R.DATA<-1> = "1"
    END

RETURN

END
