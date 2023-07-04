$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.AC.LINE
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COMPANY
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.RE.STAT.REP.LINE

    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

*---------
OPENFILES:
*---------
    FN.EB.CONT.BAL.CA='F.EB.CONTRACT.BALANCES'
    F.EB.CONT.BAL.CA =''
    CALL OPF(FN.EB.CONT.BAL.CA,F.EB.CONT.BAL.CA)

    FN.RE.STAT.REP.LINE.CA='F.RE.STAT.REP.LINE'
    F.RE.STAT.REP.LINE.CA =''
    CALL OPF(FN.RE.STAT.REP.LINE.CA,F.RE.STAT.REP.LINE.CA)

RETURN
PROCESS:

    Y.ACCT.ID=O.DATA
    Y.LINE.NO=''
    CALL F.READ(FN.EB.CONT.BAL.CA,Y.ACCT.ID,R.EB.CONTRACT.BALANCES,F.EB.CONT.BAL.CA,EB.CONTRACT.BALANCES.ERR)
    IF R.EB.CONTRACT.BALANCES THEN
        Y.CONSOL.KEY    = R.EB.CONTRACT.BALANCES<ECB.CONSOL.KEY>
        Y.CONSOL.PART   = FIELD(Y.CONSOL.KEY,'.',1,16)
        YCRF.TYPE       =R.EB.CONTRACT.BALANCES<ECB.CURR.ASSET.TYPE>
        Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':YCRF.TYPE
        Y.VARIABLE = ''; Y.RPRTS = ''; Y.LINES = ''
        CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
        Y.LINE = Y.RPRTS:'.':Y.LINES
        CALL F.READ(FN.RE.STAT.REP.LINE.CA,Y.LINE,R.LINE,F.RE.STAT.REP.LINE.CA,REP.ERR)
        Y.LINE.NO= R.LINE<RE.SRL.DESC,1>
    END
    O.DATA=Y.LINE.NO
RETURN
END
