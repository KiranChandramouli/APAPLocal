* @ValidationCode : MjotNjgwODQ4Nzc3OkNwMTI1MjoxNjg0NTAyNjE1NzA4OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 18:53:35
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
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE ATM.ISO.SYS.ERR.RTN(OUT.MSG)
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
    $USING APAP.REDOCHNLS
    $USING APAP.LAPAP


    GOSUB INIT
    GOSUB PROCESS
    LOC.MS=LOC.MSG
    LOC.MSG=LOC.MSG1
* CALL REDO.UPD.ATM.REJ
    CALL APAP.LAPAP.redoUpdAtmRej();*r22 manual code comversion
    LOC.MSG=LOC.MS
RETURN

*------------------------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------------------------
    FN.ATM.RES.CODE = 'F.ATM.RES.COD.TABLE'
*F.ATM.RES.CODE = ''
*CALL OPF(FN.ATM.RES.CODE,F.ATM.RES.CODE)
    ISO.RESPONSE = ''
RETURN

*------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------------

    CALL CACHE.READ(FN.ATM.RES.CODE,'SYSTEM',R.ATM.RES.CODE,E.ATM.RES.CODE)
    Y.MSG.DETAILS= " Card:":AT$INCOMING.ISO.REQ(2) :",Pcode": AT$INCOMING.ISO.REQ(3):",Network":AT$INCOMING.ISO.REQ(32):",":AT$INCOMING.ISO.REQ(33):",Trace:":AT$INCOMING.ISO.REQ(11):",FechaHora:":AT$INCOMING.ISO.REQ(7):",XX":
    IF AT$AT.RES.MAP.ID EQ 0 OR AT$AT.RES.MAP.ID EQ '' THEN
        MON.TP='04'
        REC.CON = 'NO VALID ISO REQ MAP':Y.MSG.DETAILS
        DESC = 'NO VALID ISO REQ MAP FOR TXN ' :Y.MSG.DETAILS
        AT$AT.RES.MAP.ID=AT$INCOMING.ISO.REQ(1)
        LOC.MSG1='NO VALID ISO REQ MAP'
    END ELSE

        IF OUT.MSG EQ 'SECURITY VIOLATION' OR OUT.MSG EQ 'VIOLACICN DE SEGURIDAD' OR OUT.MSG EQ 'SECURITY VIOLATION DURING SIGN ON PROCESS' THEN

            MON.TP='08'
            REC.CON = OUT.MSG :'FOR TXN ': Y.MSG.DETAILS
            DESC = OUT.MSG :'FOR TXN ': Y.MSG.DETAILS
            AT$AT.RES.MAP.ID=AT$INCOMING.ISO.REQ(1)
            LOC.MSG1='SECURITY VIOLATION'
        END

    END
    GOSUB LOG.C22
    OUT.MSG="system error occured"
    GOSUB LOOP1
    OUT.MSG='Y.ISO.RESPONSE:1:1=':ISO.RESPONSE
    AT$AT.ISO.RESP.CODE=ISO.RESPONSE

RETURN  ;* Main return


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
            LOC.MSG = R.ATM.RES.CODE<AT.RES.CDE.MESSAGE,CNT>
            POS = INDEX(OUT.MSG,LOC.MSG,1)
            IF POS THEN
                ISO.RESPONSE = R.ATM.RES.CODE<AT.RES.CDE.RESPONSE.CODE,CNT>
                CNT = BIN.CNT + 1
                FLAG = 0
            END
            CNT+=1

        REPEAT
    END
RETURN
*------------------------------------------------------------------------------------------------------
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


*   CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*R22 MANUAL CODE CONVERSION
RETURN
END
