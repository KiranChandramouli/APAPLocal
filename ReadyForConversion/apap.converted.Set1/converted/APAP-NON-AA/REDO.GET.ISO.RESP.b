SUBROUTINE REDO.GET.ISO.RESP(Y.OUT.MSG)
*-----------------------------------------------------------------------------
*Modification Details:
*-----------------------------------------------------------------------------
* Date         Issue Ref      Name               Description
* 02-01-2012   PACS00167808   Balagurunathan     Initial Creation
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.VERSION
    $INSERT I_AT.ISO.COMMON
    $INSERT I_F.ATM.RES.COD.TABLE




    GOSUB INIT
    GOSUB PROCESS
RETURN

*---------------------------------------------------
INIT:
*---------------------------------------------------
    FN.ATM.RES.CODE = 'F.ATM.RES.COD.TABLE'
    CALL OPF(FN.ATM.RES.CODE,F.ATM.RES.CODE)
    ISO.RESPONSE = ''


    CALL CACHE.READ(FN.ATM.RES.CODE,'SYSTEM',R.ATM.RES.CODE,Y.ERR.READ)

RETURN
*--------
PROCESS:
*--------


    IF R.ATM.RES.CODE THEN
        CNT='1'
        FLAG = '1'
        BIN.CNT= DCOUNT(R.ATM.RES.CODE<AT.RES.CDE.MESSAGE>,@VM)
        LOOP
        WHILE (CNT LE BIN.CNT) AND FLAG
            Y.LOC.MSG = R.ATM.RES.CODE<AT.RES.CDE.MESSAGE,CNT>
            POS = INDEX(Y.OUT.MSG,Y.LOC.MSG,1)
            IF POS THEN
                ISO.RESPONSE = R.ATM.RES.CODE<AT.RES.CDE.RESPONSE.CODE,CNT>
                LOC.MSG=Y.LOC.MSG
                CNT = BIN.CNT + 1
                FLAG = 0
            END
            CNT+=1

        REPEAT

        IF FLAG EQ 1 THEN
* Y.OUT.RESP.MSG=FIELD(Y.OUT.MSG,",",2)
            ISO.RESPONSE='05'
            Y.OUT.RESP.MSG=FIELD( Y.OUT.RESP.MSG,"=",1)
            LOC.MSG=Y.OUT.RESP.MSG
            Y.MSG.DETAILS=" Card:": AT$INCOMING.ISO.REQ(2) :",Pcode:": AT$INCOMING.ISO.REQ(3):",Network:":AT$INCOMING.ISO.REQ(32):",":AT$INCOMING.ISO.REQ(33):",Trace:":AT$INCOMING.ISO.REQ(11):",FechaHora:":AT$INCOMING.ISO.REQ(7):
            MON.TP='04'
            REC.CON = 'ERROR MESSAGE NOT MAPPED FOR ERROR ': LOC.MSG : " " : Y.MSG.DETAILS
            DESC = REC.CON

            GOSUB LOG.C22
        END
        AT$AT.ISO.RESP.CODE=ISO.RESPONSE
        CALL REDO.UPD.ATM.REJ

        Y.OUT.MSG<1>=ISO.RESPONSE
        Y.OUT.MSG<2>=LOC.MSG
    END


RETURN
*------------
LOG.C22:
*------------

    INT.CODE = 'ATM001'
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    EX.USER = ''
    EX.PC = ''


    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)



RETURN


END
