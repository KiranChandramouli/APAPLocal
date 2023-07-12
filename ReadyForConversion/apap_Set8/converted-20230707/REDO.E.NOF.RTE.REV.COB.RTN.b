SUBROUTINE REDO.E.NOF.RTE.REV.COB.RTN(TXN.REV.ARRAY)
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This is a no file enquiry routine for the COB enquiry REDO.RTE.REV.COB.REPORT
*-----------------------------------------------------------------------------------------------------
*APPLICATION
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.E.NOF.RTE.REV.COB.RTN
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE                    DESCRIPTION
* 29.04.2011      SUDHARSANAN S     PACS00023990                INITIAL CREATION
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.T24.FUND.SERVICES
    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
******
    FN.FUNDS.TRANSFER$HIS='F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER$HIS=''
    CALL OPF(FN.FUNDS.TRANSFER$HIS,F.FUNDS.TRANSFER$HIS)
    FN.TELLER$HIS='F.TELLER$HIS'
    F.TELLER$HIS=''
    CALL OPF(FN.TELLER$HIS,F.TELLER$HIS)
    FN.REDO.FT.TT.REV.REC='F.REDO.FT.TT.REV.REC'
    F.REDO.FT.TT.REV.REC=''
    CALL OPF(FN.REDO.FT.TT.REV.REC,F.REDO.FT.TT.REV.REC)
    SEL.CMD=''
    SEL.LIST=''
    NOR=''
    ERR=''
    FN.T24.FUND.SERVICES$HIS = 'F.T24.FUND.SERVICES$HIS'
    F.T24.FUND.SERVICES$HIS  = ''
    CALL OPF(FN.T24.FUND.SERVICES$HIS,F.T24.FUND.SERVICES$HIS)
RETURN
*********
PROCESS:
*********
*/Read the concat file to fetch the reversal records on particular day in concat file
    CALL F.READ(FN.REDO.FT.TT.REV.REC,TODAY,R.REDO.FT.TT.REV.REC,F.REDO.FT.TT.REV.REC,REV.ERR)
    IF NOT(R.REDO.FT.TT.REV.REC) THEN
        RETURN
    END
    LOOP
        REMOVE Y.FT.TT.ID FROM R.REDO.FT.TT.REV.REC SETTING FT.TT.POS
    WHILE Y.FT.TT.ID:FT.TT.POS
        Y.FT.TT.ID1=Y.FT.TT.ID[1,2]
        BEGIN CASE
            CASE Y.FT.TT.ID1 EQ 'FT'
                GOSUB FTSELECTION
            CASE Y.FT.TT.ID1 EQ 'TT'
                GOSUB TTSELECTION
            CASE Y.FT.TT.ID1 EQ 'TF'
                GOSUB TFSSELECTION
        END CASE
    REPEAT
RETURN
***********************************************************************
************
FTSELECTION:
************
    R.FUNDS.TRANSFER = '' ; ERR.FT = ''
    CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER$HIS,Y.FT.TT.ID,R.FUNDS.TRANSFER,ERR.FT)
    IF R.FUNDS.TRANSFER THEN
        TRANS.REFERENCE=FIELD(Y.FT.TT.ID,";",1)
        Y.DBT.AMT=R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>
        IF Y.DBT.AMT NE '' THEN
            AMOUNT.EXCEED=Y.DBT.AMT
        END ELSE
            AMOUNT.EXCEED=R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>
        END
        Y.DB.VAL.DTE=R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE>
        IF Y.DB.VAL.DTE  NE '' THEN
            TXN.DATE=Y.DB.VAL.DTE
        END ELSE
            TXN.DATE=R.FUNDS.TRANSFER<FT.CREDIT.VALUE.DATE>
        END
        REC.STATUS=R.FUNDS.TRANSFER<FT.RECORD.STATUS>
        TXN.REV.ARRAY<-1>=TRANS.REFERENCE:'*':AMOUNT.EXCEED:'*':TXN.DATE:'*':REC.STATUS
    END
RETURN
***************************************************************************************
************
TTSELECTION:
*************
    R.TELLER = ''
    ERR.TELLER = ''
    CALL EB.READ.HISTORY.REC(F.TELLER$HIS ,Y.FT.TT.ID,R.TELLER,ERR.TELLER)
    IF R.TELLER THEN
        TRANS.REFERENCE=FIELD(Y.FT.TT.ID,";",1)
        AMOUNT.EXCEED=R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
        VALUE.DTE2=R.TELLER<TT.TE.VALUE.DATE.2>
        IF VALUE.DTE2 THEN
            TXN.DATE=VALUE.DTE2
        END ELSE
            TXN.DATE=R.TELLER<TT.TE.VALUE.DATE.1>
        END
        REC.STATUS=R.TELLER<TT.TE.RECORD.STATUS>
        TXN.REV.ARRAY<-1>=TRANS.REFERENCE:'*':AMOUNT.EXCEED:'*':TXN.DATE:'*':REC.STATUS
    END
RETURN
*****************************************************************************************
TFSSELECTION:
*************
    R.T24.FUND.SERVICES  = ''
    T24.FUND.SERVICES.ER = ''
    CALL EB.READ.HISTORY.REC(F.T24.FUND.SERVICES$HIS,Y.FT.TT.ID,R.T24.FUND.SERVICES,T24.FUND.SERVICES.ER)
    IF R.T24.FUND.SERVICES THEN
        TRANS.REFERENCE = FIELD(Y.FT.TT.ID,";",1)
        AMOUNT.EXCEED   = R.T24.FUND.SERVICES<TFS.AMOUNT>
        VALUE.DTE2      = R.T24.FUND.SERVICES<TFS.BOOKING.DATE>
        REC.STATUS      = R.T24.FUND.SERVICES<TFS.RECORD.STATUS>
        TXN.REV.ARRAY<-1>=TRANS.REFERENCE:'*':AMOUNT.EXCEED:'*':TXN.DATE:'*':REC.STATUS
    END
RETURN
*****************************************************************************************
END
