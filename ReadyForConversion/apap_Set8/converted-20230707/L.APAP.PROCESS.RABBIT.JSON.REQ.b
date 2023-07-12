SUBROUTINE L.APAP.PROCESS.RABBIT.JSON.REQ(Y.SERVICE.NAME, Y.T24.DATA, Y.PARAM, Y.RABBIT.MQ.OUT)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.L.APAP.JSON.TO.OFS

*DEBUG
    GOSUB INITIALISE
    GOSUB REQUEST
*GOSUB PRE.ROUTINE
    GOSUB PROCESS.N.RESPONSE

RETURN

INITIALISE:
    Y.ERROR = ''
    Y.ERROR<3> = 'L.APAP.PROCESS.RABBIT.JSON.REQ'
    Y.MAPPING.NAME = Y.SERVICE.NAME

    CHANGE "||" TO @FM IN Y.T24.DATA

    JSON.REQUEST = ''
    JSON.RESPONSE = ''

    Y.DYN.REQUEST.KEY = ''
    Y.DYN.REQUEST.VALUE = ''
    Y.DYN.REQUEST.TYPE = ''

    Y.DYN.REQUEST.OFS.KEY = ''
    Y.DYN.REQUEST.OFS.TYPE = ''

    Y.DYN.RESPONSE.KEY = ''
    Y.DYN.RESPONSE.VALUE = ''
    Y.DYN.RESPONSE.TYPE = ''

    Y.DYN.MAPPING.IN = ''
    Y.RABBIT.MQ.IN = ''

    Y.DYN.MAPPING.OUT = ''
    Y.RABBIT.MQ.OUT = ''

    Y.OFS.IN.REQUEST = ''
    Y.OFS.IN.RESPONSE =  ''

    Y.OFS.OUT.REQUEST = ''
    Y.OFS.OUT.RESPONSE = ''

    Y.OBJECT.TYPE = ''
    Y.ADDNL.INFO = ''
RETURN

REQUEST:
*DEBUG
    IF TRIM(Y.PARAM, " ", "R") EQ ""  THEN
        Y.ERROR<1> = 1
        Y.ERROR<2> = "BLANK MESSAGE"
        RETURN
    END

*JSON.REQUEST  = Y.PARAM
    CALL L.APAP.JSON.STRINGIFY(Y.PARAM , JSON.REQUEST)
    Y.PARAM = ''
*LOAD DYN FROM JSON
    CALL L.APAP.JSON.TO.DYN(JSON.REQUEST, Y.DYN.REQUEST.KEY, Y.DYN.REQUEST.VALUE, Y.DYN.REQUEST.TYPE, Y.ERROR)
    IF Y.ERROR<1> EQ 1 THEN
        RETURN
    END
*FOR INPUT
    CALL L.APAP.GET.JSON.T24.MAPPING(Y.MAPPING.NAME,Y.DYN.MAPPING.IN,Y.RABBIT.MQ.IN, "", Y.ERROR)
    IF Y.ERROR<1> EQ 1 THEN
        RETURN
    END

    Y.OBJECT.TYPE = Y.DYN.MAPPING.IN<3>

*DEBUG
    BEGIN CASE
        CASE Y.OBJECT.TYPE EQ  'VERSION' OR Y.OBJECT.TYPE EQ 'ENQUIRY'
*FOR OUTPUT
*DEBUG
            CALL L.APAP.GET.JSON.T24.MAPPING(Y.RABBIT.MQ.IN<1>,Y.DYN.MAPPING.OUT,Y.RABBIT.MQ.OUT, Y.DYN.MAPPING.IN<4>, Y.ERROR)
            IF Y.ERROR<1> EQ 1 THEN
                RETURN
            END
*TRANSLATE INPUT FIELDS FROM JSON TO T24 FIELDS
*DEBUG
            CALL L.APAP.TRANSL.INPUT.FIELD(Y.DYN.REQUEST.KEY, Y.DYN.MAPPING.IN, Y.DYN.REQUEST.OFS.KEY, Y.DYN.REQUEST.OFS.TYPE, Y.ERROR)
            IF Y.ERROR<1> EQ 1 THEN
                RETURN
            END
*VALIDATED REQUIRIED FILEDS
*TBD
            IF Y.ERROR<1> EQ 1 THEN
                RETURN
            END
*CONVERT DYN ARRAY TO OFS
            Y.OBJECT = Y.DYN.MAPPING.IN<4>
            CHANGE ',' TO @FM IN Y.OBJECT

            Y.ADDNL.INFO<1>=Y.DYN.MAPPING.IN<3>
            Y.ADDNL.INFO<2>=Y.OBJECT<1>
            Y.ADDNL.INFO<3> = 'I'
            Y.ADDNL.INFO<4> = 'PROCESS'
            Y.ADDNL.INFO<5>=Y.OBJECT<2>
            Y.ADDNL.INFO<6> = ''
            Y.ADDNL.INFO<7> = ''
            Y.ADDNL.INFO<8> = Y.T24.DATA<3>
            Y.ADDNL.INFO<9> = Y.T24.DATA<1>
            Y.ADDNL.INFO<10> = Y.T24.DATA<2>

*DEBUG
            GOSUB PRE.ROUTINE
            IF Y.ERROR<1> EQ 1 THEN
                RETURN
            END

            CALL L.APAP.DYN.TO.OFS(Y.DYN.REQUEST.OFS.KEY, Y.DYN.REQUEST.VALUE, Y.DYN.REQUEST.OFS.TYPE, Y.ADDNL.INFO, Y.OFS.IN.REQUEST, Y.ERROR)
            IF Y.ERROR<1> EQ 1 THEN
                RETURN
            END
        CASE Y.OBJECT.TYPE = 'ROUTINE'
*FOR OUTPUT
            CALL L.APAP.GET.JSON.T24.MAPPING(Y.MAPPING.NAME,Y.DYN.MAPPING.OUT,Y.RABBIT.MQ.OUT,"",Y.ERROR)
            IF Y.ERROR<1> EQ 1 THEN
                RETURN
            END
        CASE 1
            Y.ERROR<1> = 1
            Y.ERROR<2> = "INVALID PARAMETER SETTING AT ST.L.APAP.JSON.TO.OFS>OBJECT.TYPE OF MAPPING: " :
    END CASE

RETURN

PRE.ROUTINE:
*DEBUG
    IF Y.ERROR<1> EQ 0 OR Y.ERROR<1> EQ '' THEN
        CALL L.APAP.RABBIT.PRE.ROUTINE(Y.DYN.MAPPING.IN, Y.DYN.REQUEST.OFS.KEY, Y.DYN.REQUEST.VALUE, Y.DYN.REQUEST.OFS.TYPE, Y.ADDNL.INFO, Y.ERROR)
    END

RETURN

PROCESS.N.RESPONSE:
*DEBUG
    IF Y.ERROR<1> EQ 0 OR Y.ERROR<1> EQ '' THEN
        BEGIN CASE
            CASE Y.OBJECT.TYPE EQ "VERSION"
                GOSUB PROCESS.OFS
                GOSUB RESPONSE.OFS
            CASE Y.OBJECT.TYPE EQ "ENQUIRY"
                GOSUB PROCESS.OFS
                GOSUB RESPONSE.ENQ
            CASE Y.OBJECT.TYPE EQ "ROUTINE"
                GOSUB PROCESS.RTN
                GOSUB RESPONSE.RTN
            CASE 1
                Y.ERROR<1> = 1
                Y.ERROR<2> = "INVALID PARAMETER SETTING AT ST.L.APAP.JSON.TO.OFS>OBJECT.TYPE OF MAPPING: " :
        END CASE

        IF Y.ERROR<1> EQ 1 THEN
            CALL L.APAP.JSON.ERROR(Y.ERROR, JSON.RESPONSE)
        END
        Y.PARAM = JSON.RESPONSE
    END
    ELSE
        CALL L.APAP.JSON.ERROR(Y.ERROR, JSON.RESPONSE)
        Y.PARAM = JSON.RESPONSE
    END

RETURN

PROCESS.OFS:
*DEBUG

*IF PUTENV('OFS_SOURCE=TAABS') THEN NULL
    IF PUTENV('OFS_SOURCE=LAPAP.JSON') THEN
        NULL
    END
    Y.CMT = ''
    CALL JF.INITIALISE.CONNECTION
    CALL OFS.BULK.MANAGER(Y.OFS.IN.REQUEST, Y.OFS.OUT.RESPONSE, Y.CMT)

    Y.RET.MSG = Y.OFS.OUT.RESPONSE
    CHANGE ',' TO @FM IN Y.RET.MSG
    CHANGE '/' TO @VM IN Y.RET.MSG<1>

    IF Y.RET.MSG<1,3> EQ '-1' THEN
        Y.ERROR<3> = 'L.APAP.PROCESS.RABBIT.JSON.REQ'
        Y.ERROR<1> = 1
        Y.ERROR<2> = 'OFS ERROR: ': Y.RET.MSG<2>
    END

RETURN

PROCESS.RTN:
*DEBUG
**ROUTINE TO HANDLED ROUTINE CALL, THE INPUT MUST BE A JSON REQUEST, THE OUTPUT MUST BE A DYNAMIC ARRAY USING THE @FM MARKER
*FOR VARAIBLES  Y.DYN.RESPONSE.KEY<@FM>, Y.DYN.RESPONSE.VALUE, Y.DYN.RESPONSE.TYPE<@FM> AND THE MARKER @VM/@SM
*FOR @VM Y.DYN.RESPONSE.VALUE<@FM,@VM>
*FOR @SM Y.DYN.RESPONSE.VALUE<@FM,@VM,@SM>
    CALL L.APAP.JSON.RTN.RUNNER(Y.DYN.MAPPING.OUT<4>, JSON.REQUEST, Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.DYN.RESPONSE.TYPE, Y.ERROR)
RETURN

RESPONSE.OFS:
*DEBUG
    IF Y.ERROR<1> NE 1 THEN
*CONVERT OFS REPOSPONSE TO DYN ARRAY
        CALL L.APAP.OFS.TO.DYN(Y.OFS.OUT.RESPONSE, Y.DYN.MAPPING.OUT<3>, Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.ERROR)
*TRANSLATE INPUT FIELDS FROM T24 FIELDS TO JSON
        CALL L.APAP.TRANSL.OUTPUT.FIELD(Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.DYN.RESPONSE.TYPE, Y.DYN.MAPPING.OUT, Y.ERROR)
*CREATE JSON RESPONSE FROM DYN
        CALL L.APAP.DYN.TO.JSON(Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.DYN.RESPONSE.TYPE, Y.DYN.MAPPING.OUT<2>, JSON.RESPONSE, Y.ERROR)
*MASK OUTPUT
    END
RETURN

RESPONSE.ENQ:
*DEBUG
    IF Y.ERROR<1> NE 1  THEN
*CONVERT OFS REPOSPONSE TO DYN ARRAY
        CALL L.APAP.OFS.TO.DYN(Y.OFS.OUT.RESPONSE, Y.DYN.MAPPING.OUT<3>, Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.ERROR)
*TRANSLATE INPUT FIELDS FROM T24 FIELDS TO JSON
        CALL L.APAP.TRANSL.OUTPUT.FIELD(Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.DYN.RESPONSE.TYPE, Y.DYN.MAPPING.OUT, Y.ERROR)
*CREATE JSON RESPONSE FROM DYN
        CALL L.APAP.DYN.TO.JSON(Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.DYN.RESPONSE.TYPE, Y.DYN.MAPPING.OUT<2>, JSON.RESPONSE, Y.ERROR)
*MASK OUTPUT
    END
RETURN

RESPONSE.RTN:
*DEBUG
    IF Y.ERROR<1> NE 1  THEN
*TRANSLATE INPUT FIELDS FROM T24 FIELDS TO JSON
        CALL L.APAP.TRANSL.OUTPUT.FIELD(Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.DYN.RESPONSE.TYPE, Y.DYN.MAPPING.OUT, Y.ERROR)
*CREATE JSON RESPONSE FROM DYN
        CALL L.APAP.DYN.TO.JSON(Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.DYN.RESPONSE.TYPE, Y.DYN.MAPPING.OUT<2>, JSON.RESPONSE, Y.ERROR)
*MASK OUTPUT
    END
RETURN

RETURN
END
