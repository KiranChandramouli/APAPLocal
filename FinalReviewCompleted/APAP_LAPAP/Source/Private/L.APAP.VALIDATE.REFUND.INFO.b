* @ValidationCode : Mjo4ODk5NDI0ODg6Q3AxMjUyOjE2OTAxNjc1Mzg1NjE6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.VALIDATE.REFUND.INFO
*--------------------------------------------------------------------------------------------------
* Description           : Rutina para validar informacion a partir de un numero de prestamo
* Developed On          : 26/09/2018
* Developed By          : Anthony Martinez
* Development Reference : CN009467
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
* Defect Reference       Modified By                    Date of Change        Change Details
* CN009467               Anthony Martinez               26/09/2018            Creacion
*
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       CALL routine format modified
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ST.LAPAP.AA.LOAN.PARAM
    
    $USING APAP.AA

    Y.OUT.RECORD = ""
    Y.DEBIT.ACCT.NO = ""
    Y.TRANSACTION.TYPE = ""
    Y.DAYS.DISBURSEMENT.LOAN = ""
    Y.LOAN.NUMBER = COMI

    FN.ACC = "F.ACCOUNT"; FV.ACC = ""; R.ACC = ""; ERR.ACC = ""
    CALL OPF(FN.ACC, FV.ACC)

    FN.AA.ARR = "F.AA.ARRANGEMENT"; FV.AA.ARR = ""; R.AA.ARR = ""; ERR.AA.ARR = ""
    CALL OPF(FN.AA.ARR, FV.AA.ARR)

    FN.AA.LOAN.PARAM = "F.ST.LAPAP.AA.LOAN.PARAM"; FV.AA.LOAN.PARAM = ""; R.AA.LOAN.PARAM = ""; ERR.AA.LOAN.PARAM = ""
    SEL.LIST = ""; NO.OF.REC = ""; SEL.ERR = ""
    CALL OPF(FN.AA.LOAN.PARAM, FV.AA.LOAN.PARAM)

    CALL F.READ(FN.ACC, Y.LOAN.NUMBER, R.ACC, FV.ACC, ERR.ACC)
    AA.ARR.ID = R.ACC<AC.ARRANGEMENT.ID>

    CALL F.READ(FN.AA.ARR, AA.ARR.ID, R.AA.ARR, FV.AA.ARR, ERR.AA.ARR)
    Y.ARR.START.DATE = R.AA.ARR<AA.ARR.START.DATE>
    Y.ARR.STATUS = R.AA.ARR<AA.ARR.ARR.STATUS>

    IF Y.ARR.STATUS NE 'CURRENT' AND Y.ARR.STATUS NE 'AUTH' THEN

        ETEXT = "ESTE PRESTAMO NO SE ENCUENTRA ACTIVO"
        CALL STORE.END.ERROR
        RETURN

    END ELSE

*        CALL REDO.B.CON.LNS.BY.DEBTOR.AA.RECS(AA.ARR.ID,Y.OUT.RECORD)
        APAP.AA.redoBConLnsByDebtorAaRecs(AA.ARR.ID,Y.OUT.RECORD)        ;*Manual R22 conversion
        R.AA.CUSTOMER = FIELD(Y.OUT.RECORD, "*", 9)

        CALL GET.LOC.REF("AA.ARR.CUSTOMER", "L.AA.CAMP.TY", L.AA.CAMP.TY.POS)
        L.AA.CAMP.TY = R.AA.CUSTOMER<AA.CUS.LOCAL.REF, L.AA.CAMP.TY.POS, 1>

        SEL.CMD = " SELECT ": FN.AA.LOAN.PARAM :" WITH CAMPAIGN.CODE EQ " : L.AA.CAMP.TY
        CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR)

        IF NO.OF.REC EQ 0 THEN
            ETEXT = "PRESTAMO NO APLICA PARA REEMBOLSO"
            CALL STORE.END.ERROR
            RETURN
        END

        LOOP
            REMOVE Y.REC.ID FROM SEL.LIST SETTING RTE.POS
        WHILE Y.REC.ID DO

            CALL F.READ(FN.AA.LOAN.PARAM, Y.REC.ID, R.AA.LOAN.PARAM, FV.AA.LOAN.PARAM, ERR.AA.LOAN.PARAM)

            Y.KEY.ARR   = R.AA.LOAN.PARAM<ST.LAP67.KEY>
            Y.VALUE.ARR = R.AA.LOAN.PARAM<ST.LAP67.VALUE>

            Y.CANT.RECS = DCOUNT(Y.KEY.ARR, @VM)

            FOR A = 1 TO Y.CANT.RECS STEP 1
                IF Y.KEY.ARR<1, A> EQ "TRANSACTION.TYPE" THEN
                    Y.TRANSACTION.TYPE = Y.VALUE.ARR<1, A>
                END
                IF Y.KEY.ARR<1, A> EQ "DEBIT.ACCOUNT" THEN
                    Y.DEBIT.ACCT.NO = Y.VALUE.ARR<1, A>
                END
                IF Y.KEY.ARR<1, A> EQ "DAYS.DISBURSEMENT.LOAN" THEN
                    Y.DAYS.DISBURSEMENT.LOAN = Y.VALUE.ARR<1, A>
                END
            NEXT A

        REPEAT

        FN.FT = "FBNK.FUNDS.TRANSFER"; SEL.LIST = ""; NO.OF.REC = ""; SEL.ERR = ""

        SEL.CMD = "SELECT ":FN.FT:" WITH CHARGED.CUSTOMER EQ ": R.ACC<AC.CUSTOMER> :" AND TRANSACTION.TYPE EQ ": Y.TRANSACTION.TYPE :" AND CREDIT.THEIR.REF EQ ": Y.LOAN.NUMBER:" AND CREDIT.AMOUNT EQ 4000 AND ORDERING.CUST EQ 'REEMBOLSO' AND RECORD.STATUS EQ '' "
        CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR)

        IF NO.OF.REC EQ 0 THEN
            FN.FT = FN.FT:"$HIS"
            SEL.CMD = "SELECT ":FN.FT:" WITH CHARGED.CUSTOMER EQ ": R.ACC<AC.CUSTOMER> :" AND TRANSACTION.TYPE EQ ": Y.TRANSACTION.TYPE :" AND CREDIT.THEIR.REF EQ ": Y.LOAN.NUMBER:" AND CREDIT.AMOUNT EQ 4000 AND ORDERING.CUST EQ 'REEMBOLSO' AND RECORD.STATUS EQ '' "
            CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR)

        END

        IF NO.OF.REC GT 0 THEN

            REMOVE Y.REC.ID FROM SEL.LIST SETTING RTE.POS

            ETEXT = "EL REEMBOLSO A ESTE PRESTAMO YA FUE APLICADO EN EL FT ": Y.REC.ID
            CALL STORE.END.ERROR
            RETURN
        END

        CALL CDT('', Y.ARR.START.DATE, Y.DAYS.DISBURSEMENT.LOAN)

        IF Y.ARR.START.DATE LT TODAY THEN
            ETEXT = "PRESTAMO TIENE MAS DE ": Y.DAYS.DISBURSEMENT.LOAN : " DIAS DE SER DESEMBOLSADO"
            CALL STORE.END.ERROR
            RETURN
        END

        R.NEW(FT.DEBIT.ACCT.NO)       = Y.DEBIT.ACCT.NO
        R.NEW(FT.TRANSACTION.TYPE)    = Y.TRANSACTION.TYPE
        R.NEW(FT.CHARGED.CUSTOMER)    = R.ACC<AC.CUSTOMER>
        R.NEW(FT.PROFIT.CENTRE.DEPT)  = R.ACC<AC.ACCOUNT.OFFICER>

        RETURN
    END
END
