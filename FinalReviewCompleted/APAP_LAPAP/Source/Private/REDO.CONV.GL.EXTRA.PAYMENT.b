$PACKAGE APAP.LAPAP
SUBROUTINE REDO.CONV.GL.EXTRA.PAYMENT
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
*
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description
*
** 24-04-2023 R22 Auto Conversion 
** 24-04-2023 Skanda R22 Manual Conversion - No changes
*-------------------------------------------------------------------------

    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_ENQUIRY.COMMON ;* R22 Auto conversion
    $INSERT I_F.RE.STAT.REP.LINE ;* R22 Auto conversion
    $INSERT I_F.EB.CONTRACT.BALANCES ;* R22 Auto conversion


    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****

    YACCOUNT.ID = O.DATA
    BAL.TYPE1 = "CURACCOUNT"
    YGL.CODE.TMP = ''; Y.IN.CONSOL.KEY = ''; Y.CONSOL.PART = ''; Y.CONSOL.KEY = ''
    R.EB.CONTRACT.BALANCES = ''; EB.CONTRACT.BALANCES.ERR = ''
    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'; F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)
    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'; F.RE.STAT.REP.LINE = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)
RETURN

PROCESS:
********
    CALL F.READ(FN.EB.CONTRACT.BALANCES,YACCOUNT.ID,R.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES,EB.CONTRACT.BALANCES.ERR)
    IF NOT(R.EB.CONTRACT.BALANCES) THEN
        O.DATA = ''
        RETURN
    END
    Y.CONSOL.KEY = R.EB.CONTRACT.BALANCES<ECB.CONSOL.KEY>
    Y.CONSOL.PART = FIELD(Y.CONSOL.KEY,'.',1,16)
    Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':BAL.TYPE1
    Y.VARIABLE = ''; Y.RPRTS = ''; Y.LINES = ''; Y.LINE = ''
    CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
    Y.LINE = Y.RPRTS:'.':Y.LINES
    REP.ERR = ''; R.LINE = ''; YGL.CODE.TMP = ''; YSAP.ACC.NO = ''
    CALL F.READ(FN.RE.STAT.REP.LINE,Y.LINE,R.LINE,F.RE.STAT.REP.LINE,REP.ERR)
    YGL.CODE.TMP = R.LINE<RE.SRL.DESC,1>
    YSAP.ACC.NO = R.LINE<RE.SRL.DESC,3>

    O.DATA = YGL.CODE.TMP:'*':YSAP.ACC.NO
RETURN
END
