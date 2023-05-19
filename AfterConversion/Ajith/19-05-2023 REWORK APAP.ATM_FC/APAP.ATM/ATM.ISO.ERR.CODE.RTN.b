* @ValidationCode : MjotMTMxMTk2MjMwMDpDcDEyNTI6MTY4NDUwMjU5MDcwMDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 18:53:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   = to EQ , VM to @VM
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE ATM.ISO.ERR.CODE.RTN(OUT.MSG)
*------------------------------------------------------------------------------------------------------
*DESCRIPTION
* Routine to map the response code
*------------------------------------------------------------------------------------------------------
*APPLICATION
* OFS.SOURCE
*-------------------------------------------------------------------------------------------------------

*
* Input / Output
* --------------
* IN     : OUT.MSG  -  OFS response from the T24 based on the Input sent by the ISO request
* OUT    : OUT.MSG  -  OFS response amended with Response Code
*
* DATE          WHO             REFERENCE        DESCRIPTION
*16 DEC 2010   BALAGURUNATHAN  ODR-2010-08-0469  Added routine to update rejected log
*----------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.VERSION
    $INSERT I_AT.ISO.COMMON
    $INSERT I_F.ATM.RES.COD.TABLE
    $USING APAP.LAPAP
    $USING APAP.REDOCHNLS
 
    GOSUB INIT

    GOSUB PROCESS

    LOC.MSG=''
RETURN

*------------------------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------------------------
    FN.ATM.RES.CODE = 'F.ATM.RES.COD.TABLE'
    F.ATM.RES.CODE = ''
    CALL OPF(FN.ATM.RES.CODE,F.ATM.RES.CODE)
    ISO.RESPONSE = ''

RETURN

*------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------------


    IF NOT(INDEX(OUT.MSG,'/',1)) AND INDEX(OUT.MSG,'UNIQUE.TXN.CODE:1:1=',1) THEN
        RETURN          ;* Do not execute for routine req applicable tcclient
    END
*ELSE
*        IF NOT(INDEX(OUT.MSG,'/',1))  THEN
*            ISO.RESPONSE = '05'
*            LOC.MSG=OUT.MSG
*            CALL REDO.UPD.ATM.REJ
*            OUT.MSG='Y.ISO.RESPONSE:1:1=':ISO.RESPONSE
*        END
*    END

    CALL CACHE.READ(FN.ATM.RES.CODE,'SYSTEM',R.ATM.RES.CODE,E.ATM.RES.CODE)
    STATUS.MSG = FIELD(OUT.MSG,',',1)
    STATUS.MSG = FIELD(STATUS.MSG,'/',3)

*    IF STATUS.MSG EQ 1 OR STATUS.MSG EQ '' THEN
    IF STATUS.MSG EQ 1 THEN
        OUT.MSG:=',Y.ISO.RESPONSE:1:1=00'   ;* We want IHLD
        RETURN
    END
    IF INDEX(OUT.MSG,'RECORD.STATUS:1:1=IHLD',1) THEN
        GOSUB VERSION.LEVEL
    END ELSE
        STATUS.MSG = FIELD(OUT.MSG,',',1)

        IF INDEX(STATUS.MSG,'-',1) OR NOT(STATUS.MSG) THEN
            GOSUB LOOP1
        END
        IF ISO.RESPONSE EQ '' THEN
            ISO.RESPONSE = '05'
        END

        Y.ISO.RESPONSE = ISO.RESPONSE
        OUT.MSG3 = 'Y.ISO.RESPONSE:1:1=':ISO.RESPONSE
        AT$AT.ISO.RESP.CODE = ISO.RESPONSE

        CALL APAP.LAPAP.redoUpdAtmRej()   ;* UPDATES  ATM REJECTION TABLE


        OUT.MSG=OUT.MSG3
    END

RETURN  ;* Main return

*------------------------------------------------------------------------------------------------------
VERSION.LEVEL:
*------------------------------------------------------------------------------------------------------

    IF PGM.VERSION EQ ",REV.DUP" THEN
        ISO.RESPONSE = '98'
    END
    ELSE
        IF PGM.VERSION EQ ",ATM.DUP" THEN
            ISO.RESPONSE = '99'
        END
        ELSE
            ISO.RESPONSE = '05'
        END
    END
    OUT.MSG = OUT.MSG:',Y.ISO.RESPONSE:1:1=':ISO.RESPONSE
RETURN

*------------------------------------------------------------------------------------------------------
LOOP1:
*------------------------------------------------------------------------------------------------------
    IF R.ATM.RES.CODE THEN
        CNT='1'
        FLAG = '1'
        BIN.CNT= DCOUNT(R.ATM.RES.CODE<AT.RES.CDE.MESSAGE>,@VM)
        LOOP
        WHILE (CNT LE BIN.CNT) AND FLAG
            Y.LOC.MSG = R.ATM.RES.CODE<AT.RES.CDE.MESSAGE,CNT>
            POS = INDEX(OUT.MSG,Y.LOC.MSG,1)
            IF POS THEN
                ISO.RESPONSE = R.ATM.RES.CODE<AT.RES.CDE.RESPONSE.CODE,CNT>
                LOC.MSG=Y.LOC.MSG
                CNT = BIN.CNT + 1
                FLAG = 0
            END
            CNT+=1

        REPEAT

        IF FLAG EQ 1 THEN ;*R22 AUTO CODE CONVERSION
            Y.OUT.RESP.MSG=FIELD(OUT.MSG,",",2)
            Y.OUT.RESP.MSG=FIELD( Y.OUT.RESP.MSG,",",1)
            LOC.MSG=Y.OUT.RESP.MSG
            Y.MSG.DETAILS= " Card:":AT$INCOMING.ISO.REQ(2) :",Pcode:": AT$INCOMING.ISO.REQ(3):",Network:":AT$INCOMING.ISO.REQ(32):",":AT$INCOMING.ISO.REQ(33):",Trace:":AT$INCOMING.ISO.REQ(11):",FechaHora:":AT$INCOMING.ISO.REQ(7):
            MON.TP='04'
            REC.CON = 'ERROR MESSAGE NOT MAPPED FOR ERROR ': LOC.MSG : " " : Y.MSG.DETAILS
            DESC = REC.CON

            GOSUB LOG.C22
        END
    END


RETURN

LOG.C22:



    INT.CODE = 'ATM001'
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    EX.USER = ''
    EX.PC = ''


    CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*R22 MANUAL CODE CONVERSION

RETURN

*------------------------------------------------------------------------------------------------------
END
