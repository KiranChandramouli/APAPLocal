SUBROUTINE REDO.E.NOF.RTE.REV.RTN(TXN.REV.ARRAY)
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This is a no file enquiry routine for the enquiry REDO.RTE.REV.REPORT
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
* PROGRAM NAME : REDO.E.NOF.RTE.REV.RTN
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE                    DESCRIPTION
*08.02.2010      SUDHARSANAN s     ODR-2009-10-0472            INITIAL CREATION
* 22 July 2010   Shiva Prasad Y    ODR-2009-10-0318 B.126     Added TFS part for reversed rec display
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
    FN.FUNDS.TRANSFER='F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER=''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
    FN.TELLER='F.TELLER$HIS'
    F.TELLER=''
    CALL OPF(FN.TELLER,F.TELLER)
    FN.FT.TT='F.REDO.FT.TT.REV'
    F.FT.TT=''
    CALL OPF(FN.FT.TT,F.FT.TT)
    SEL.CMD=''
    SEL.LIST=''
    NOR=''
    ERR=''
* Modification start - ODR-2009-10-0318 B.126 dated on 22 July 2010

    FN.T24.FUND.SERVICES = 'F.T24.FUND.SERVICES$HIS'
    F.T24.FUND.SERVICES  = ''
    CALL OPF(FN.T24.FUND.SERVICES,F.T24.FUND.SERVICES)

* Modification end - ODR-2009-10-0318 B.126 dated on 22 July 2010
* 20121109 - VNL - B.30 / S
    LOCATE "TRANSACTION.ID" IN ENQ.SELECTION<2,1> SETTING POS THEN
        WENQS.4            = ENQ.SELECTION<4,POS>
    END
* 20121109 - VNL - B.30 / E
RETURN

*********
PROCESS:
*********
*/Select the values from concat table
    SEL.CMD='SELECT ':FN.FT.TT
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)

    LOOP
        REMOVE Y.FT.TT.ID FROM SEL.LIST SETTING FT.TT.POS
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
    Y.FT.ID=FIELD(Y.FT.TT.ID,';',1)
*
    IF Y.FT.ID[1,12] EQ WENQS.4 OR WENQS.4 EQ "" THEN
*
        CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.TT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,ERR.FT)
        TRANS.REFERENCE=Y.FT.ID
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
*
    END
*
RETURN

***************************************************************************************
************
TTSELECTION:
*************

    Y.TT.ID=FIELD(Y.FT.TT.ID,';',1)
*
    IF Y.TT.ID[1,12] EQ WENQS.4 OR WENQS.4 EQ "" THEN

        CALL F.READ(FN.TELLER,Y.FT.TT.ID,R.TELLER,F.TELLER,ERR.TELLER)
        TRANS.REFERENCE=Y.TT.ID
        AMOUNT.EXCEED=R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
        VALUE.DTE2=R.TELLER<TT.TE.VALUE.DATE.2>
        IF VALUE.DTE2 NE '' THEN
            TXN.DATE=VALUE.DTE2
        END ELSE
            TXN.DATE=R.TELLER<TT.TE.VALUE.DATE.1>
        END
        REC.STATUS=R.TELLER<TT.TE.RECORD.STATUS>
        TXN.REV.ARRAY<-1>=TRANS.REFERENCE:'*':AMOUNT.EXCEED:'*':TXN.DATE:'*':REC.STATUS
*
    END
*
RETURN

*****************************************************************************************
* Modification start - ODR-2009-10-0318 B.126 dated on 22 July 2010
*************
TFSSELECTION:
*************
    T24.FUND.SERVICES.ID = FIELD(Y.FT.TT.ID,';',1)
*
    IF T24.FUND.SERVICES.ID EQ WENQS.4 OR WENQS.4 EQ "" THEN
*
        R.T24.FUND.SERVICES  = ''
        T24.FUND.SERVICES.ER = ''
        CALL F.READ(FN.T24.FUND.SERVICES,T24.FUND.SERVICES.ID,R.T24.FUND.SERVICES,F.T24.FUND.SERVICES,T24.FUND.SERVICES.ER)

        TRANS.REFERENCE = T24.FUND.SERVICES.ID
        AMOUNT.EXCEED   = R.T24.FUND.SERVICES<TFS.AMOUNT>
        VALUE.DTE2      = R.T24.FUND.SERVICES<TFS.BOOKING.DATE>
        REC.STATUS      = R.T24.FUND.SERVICES<TFS.RECORD.STATUS>
        TXN.REV.ARRAY<-1>=TRANS.REFERENCE:'*':AMOUNT.EXCEED:'*':TXN.DATE:'*':REC.STATUS
*
    END
*
RETURN

*****************************************************************************************
* Modification end - ODR-2009-10-0318 B.126 dated on 22 July 2010


END
