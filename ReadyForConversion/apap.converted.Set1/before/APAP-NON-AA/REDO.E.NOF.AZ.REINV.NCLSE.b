*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.E.NOF.AZ.REINV.NCLSE(ENQ.DATA)
*-----------------------------------------------------------------------------
*
* Bank name: APAP
* Decription: The Enquiry to show the non-closed reinvested account in the Enquiry report REDO.AZ.REINV.NCLSE.
* Developed By: V.P.Ashokkumar
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT


    GOSUB INIT
    GOSUB PROCESS
    RETURN


INIT:
*****
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'; F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT, F.AZ.ACCOUNT)
    FN.AZ.ACCT.BAL.HIST = 'F.AZ.ACCT.BAL.HIST'; F.AZ.ACCT.BAL.HIST = ''
    CALL OPF(FN.AZ.ACCT.BAL.HIST, F.AZ.ACCT.BAL.HIST)
    FN.AZ.ACCOUNT$HIS = 'F.AZ.ACCOUNT$HIS'; F.AZ.ACCOUNT$HIS = ''
    CALL OPF(FN.AZ.ACCOUNT$HIS, F.AZ.ACCOUNT$HIS)
    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    L.TYPE.INT.PAY.POS = ''
    CALL GET.LOC.REF('AZ.ACCOUNT','L.TYPE.INT.PAY',L.TYPE.INT.PAY.POS)
    RETURN

PROCESS:
*********
    Y.AZ.HIST = ''; R.AZ.HIST.IDS = ''; YHIST.CNT = ''; ERR.SEL = ''
    Y.AZ.HIST = 'SELECT ':FN.AZ.ACCT.BAL.HIST:" WITH NOTES EQ 'CONTRACT CLOSED'"
    CALL EB.READLIST(Y.AZ.HIST,R.AZ.HIST, '', YHIST.CNT,ERR.SEL)
    YCNT.FL = 0
    LOOP
        REMOVE AZ.ACCT.ID FROM R.AZ.HIST SETTING AZ.POSN
    WHILE AZ.ACCT.ID:AZ.POSN
        YCNT.FL ++
        CRT YCNT.FL:"/":YHIST.CNT
        Y.AZ.ID = ''; Y.CLOSE.DATE = ''; L.TYPE.INT.PAY.VAL = ''
        Y.AZ.ID = FIELDS(AZ.ACCT.ID, '-', 1)
        Y.CLOSE.DATE = FIELDS(AZ.ACCT.ID, '-', 2)
        ERR.AZ.ACCOUNT = ''; R.AZ.ACCOUNT = ''; YINT.LIQACCT = ''
        Y.AC.HIST.ID = Y.AZ.ID:';1'
        CALL F.READ(FN.AZ.ACCOUNT$HIS, Y.AC.HIST.ID, R.AZ.ACCOUNT, F.AZ.ACCOUNT$HIS,ERR.AZ.ACCOUNT)
        YINT.LIQACCT = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
        IF NOT(YINT.LIQACCT) OR NOT(ISDIGIT(YINT.LIQACCT)) THEN
            CONTINUE
        END
        L.TYPE.INT.PAY.VAL = R.AZ.ACCOUNT<AZ.LOCAL.REF,L.TYPE.INT.PAY.POS>
        IF L.TYPE.INT.PAY.VAL NE 'Reinvested' THEN
            CONTINUE
        END
        ERR.ACCOUNT = ''; R.ACCOUNT = ''; YORG.PRIN = ''; YAC.ONLINE.ACTBAL = ''
        CALL F.READ(FN.ACCOUNT,YINT.LIQACCT,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
        IF NOT(R.ACCOUNT) THEN
            CONTINUE
        END
        YORG.PRIN = R.AZ.ACCOUNT<AZ.ORIG.PRINCIPAL>
        YAC.ONLINE.ACTBAL = R.ACCOUNT<AC.ONLINE.ACTUAL.BAL>
        ENQ.DATA<-1> = Y.AZ.ID:'|':YORG.PRIN:'|':Y.CLOSE.DATE:'|':YINT.LIQACCT:'|':YAC.ONLINE.ACTBAL

    REPEAT
    RETURN

END
