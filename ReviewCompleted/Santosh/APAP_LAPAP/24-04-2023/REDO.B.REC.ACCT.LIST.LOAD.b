$PACKAGE APAP.LAPAP

** 24-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 24-04-2023 Skanda R22 Manual Conversion - No changes

SUBROUTINE REDO.B.REC.ACCT.LIST.LOAD
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_F.STMT.ENTRY ;* R22 Auto conversion
    $INSERT I_F.MNEMONIC.COMPANY ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_REDO.B.REC.ACCT.LIST.COMMON ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion

    GOSUB INIT
RETURN

*****
INIT:
*****
    Y.DLM=","
    FN.RHRP='F.REDO.H.REPORTS.PARAM'
    F.RHRP =''
    CALL OPF(FN.RHRP,F.RHRP)

    FN.ACCOUNT ='F.ACCOUNT'
    F.ACCOUNT  =''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.STMT.ENTRY='F.STMT.ENTRY'
    F.STMT.ENTRY =''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.MNEMONIC.COMPANY='F.MNEMONIC.COMPANY'
    F.MNEMONIC.COMPANY =''
    CALL OPF(FN.MNEMONIC.COMPANY,F.MNEMONIC.COMPANY)

    FN.FT='F.FUNDS.TRANSFER'
    F.FT =''
    CALL OPF(FN.FT,F.FT)

    FN.TT='F.TELLER'
    F.TT =''
    CALL OPF(FN.TT,F.TT)

    FN.TFS='F.T24.FUND.SERVICES'
    F.TFS =''
    CALL OPF(FN.TFS,F.TFS)

    FN.FX='F.FOREX'
    F.FX =''
    CALL OPF(FN.FX,F.FX)


    FN.TT.HIS='F.TELLER$HIS'
    F.TT.HIS =''
    CALL OPF(FN.TT.HIS,F.TT.HIS)

    FN.FT.HIS='F.FUNDS.TRANSFER$HIS'
    F.FT.HIS =''
    CALL OPF(FN.FT.HIS,F.FT.HIS)

    FN.FX.HIS='F.FOREX$HIS'
    F.FX.HIS =''
    CALL OPF(FN.FX.HIS,F.FX.HIS)

    FN.EB.CONT.BAL.CA='F.EB.CONTRACT.BALANCES'
    F.EB.CONT.BAL.CA =''
    CALL OPF(FN.EB.CONT.BAL.CA,F.EB.CONT.BAL.CA)

    FN.RE.STAT.REP.LINE.CA='F.RE.STAT.REP.LINE'
    F.RE.STAT.REP.LINE.CA =''
    CALL OPF(FN.RE.STAT.REP.LINE.CA,F.RE.STAT.REP.LINE.CA)

    FN.FTTC='F.FT.TXN.TYPE.CONDITION'
    F.FTTC =''
    CALL OPF(FN.FTTC,F.FTTC)

    FN.TT.TXN='F.TELLER.TRANSACTION'
    F.TT.TXN =''
    CALL OPF(FN.TT.TXN,F.TT.TXN)

    FN.TXN='F.TRANSACTION'
    F.TXN =''
    CALL OPF(FN.TXN,F.TXN)

    FN.ACCT.EL.DAY='F.ACCT.ENT.LWORK.DAY'
    F.ACCT.EL.DAY =''
    CALL OPF(FN.ACCT.EL.DAY,F.ACCT.EL.DAY)

    CALL F.READ(FN.RHRP,'RECONRPT',R.RHRP,F.RHRP,ERR)
    Y.FIELD.LIST=R.RHRP<REDO.REP.PARAM.FIELD.NAME>
    Y.VALUE.LIST=R.RHRP<REDO.REP.PARAM.FIELD.VALUE>
    LOCATE 'DEF.ST.CATEG' IN Y.FIELD.LIST<1,1> SETTING Y.DEF.ST.CATEG.POS THEN
        DEF.ST.CATEG=Y.VALUE.LIST<1,Y.DEF.ST.CATEG.POS>
    END
    LOCATE 'DEF.ED.CATEG' IN Y.FIELD.LIST<1,1> SETTING Y.DEF.ED.CATEG.POS THEN
        DEF.ED.CATEG=Y.VALUE.LIST<1,Y.DEF.ED.CATEG.POS>
    END

    SEL.CMD.MNE = 'SELECT ': FN.MNEMONIC.COMPANY
    CALL EB.READLIST(SEL.CMD.MNE,Y.COMPANY.MNE.LIST,'',NO.OF.REC.MNE,SEL.ERR)
    Y.COMPANY.LIST=''
    LOOP
        REMOVE Y.COMPANY.MNE.ID FROM Y.COMPANY.MNE.LIST SETTING Y.COMPANY.MNE.POS
    WHILE Y.COMPANY.MNE.ID:Y.COMPANY.MNE.POS
        CALL CACHE.READ(FN.MNEMONIC.COMPANY, Y.COMPANY.MNE.ID, R.MNEMONIC.COMPANY, ERR) ;* R22 Auto conversion
        Y.COMPANY.LIST<-1>= R.MNEMONIC.COMPANY<AC.MCO.COMPANY>
    REPEAT
    LOCATE 'CURRENCY' IN Y.FIELD.LIST<1,1> SETTING Y.CUR.POS THEN
        Y.CUR.SEL.LIST    =Y.VALUE.LIST<1,Y.CUR.POS>
    END
    LOCATE 'ACCOUNT.ID' IN Y.FIELD.LIST<1,1> SETTING Y.ACC.POS THEN
        Y.ACC.SEL.LIST    =Y.VALUE.LIST<1,Y.ACC.POS>
    END
    LOCATE 'LINE' IN Y.FIELD.LIST<1,1> SETTING Y.LINE.POS THEN
        Y.LINE.SEL.LIST   =Y.VALUE.LIST<1,Y.LINE.POS>
    END

    LOCATE 'COMPANY.CODE' IN Y.FIELD.LIST<1,1> SETTING Y.COMP.POS THEN
        Y.COMP.SEL.LIST   =Y.VALUE.LIST<1,Y.COMP.POS>
    END

    LF.APP = 'TELLER':@FM:'FUNDS.TRANSFER':@FM:'FOREX':@FM:'T24.FUND.SERVICES':@FM:'SEC.TRADE'
    LF.FLD = 'L.ACTUAL.VERSIO':@VM:'L.COMMENTS':@FM:'L.ACTUAL.VERSIO':@VM:'L.COMMENTS':@FM:'L.ACTUAL.VERSIO':@FM:'L.COMMENTS':@FM:'L.COMMENTS'
    LF.POS = ''
    CALL MULTI.GET.LOC.REF(LF.APP,LF.FLD,LF.POS)
    Y.TT.ACT.VER.POS=LF.POS<1,1>
    Y.TT.LOC.CMT.POS=LF.POS<1,2>
    Y.FT.ACT.VER.POS=LF.POS<2,1>
    Y.FT.LOC.CMT.POS=LF.POS<2,2>
    Y.FX.ACT.VER.POS=LF.POS<3,1>
    Y.TF.LOC.CMT.POS=LF.POS<4,1>
    Y.ST.LOC.CMT.POS=LF.POS<5,1>

    FILE.NAME = R.RHRP<REDO.REP.PARAM.OUT.FILE.NAME>
    TEMP.PATH = R.RHRP<REDO.REP.PARAM.TEMP.DIR>
    OUT.PATH  = R.RHRP<REDO.REP.PARAM.OUT.DIR>

    IF TEMP.PATH AND FILE.NAME THEN
    END
    ELSE
        GOSUB LOG.C22
    END
    Y.REP.DATE=R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.REP.OPERAND='1'
RETURN

********
LOG.C22:
********
    ERR.MSG  = "Unable to open '":FILE.NAME:"'"
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    MON.TP   = 04
    REC.CON  = 'RECONRPT':ERR.MSG
    DESC     = 'RECONRPT':ERR.MSG
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)

RETURN
END
