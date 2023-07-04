* @ValidationCode : MjotMTc2NjU2NjA0MTpDcDEyNTI6MTY4NjY3NDI3MDU1NDpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:07:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* @(#) REDO.B.CUS.TAX.RETENTIONS Ported to jBASE 16:17:05  28 NOV 2017
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.CUS.TAX.RETENTIONS(Y.NCF.CUS.ID)
*---------------------------------------------------------------------------------------------
*
* Description           : This is the Routine Used to fetch all the movements or transactions made by the customer monthly.
*
* Developed By          : Amaravathi Krithika B
*
* Development Reference : RegN11
*
* Attached To           : Batch - BNK/REDO.B.CUS.TAX.RETENTIONS
*
* Attached As           : Online Batch Routine to COB
*---------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : Y.CUS.ID -@ID of customer
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*---------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*---------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*-----------------------------------------------------------------------------------------------------------------
* PACS00375393           Ashokkumar.V.P                 11/12/2014            New mapping changes - Rewritten the whole source.
* APAP-132               Ashokkumar.V.P                 03/02/2016            Spliting the file based on customer identification
* CN008525               APAP                           04/03/2018            New fields added for DG01 report.
*                        Ghayathri T                    06/06/2023            R22 Manual Conversion - L.ID.PERS.BENEF.POS,L.COUNTRY.POS,R.REDO.H.REPORTS.PARAM,
*                                                                             Y.PARAM.ID variable Added in I_REDO.B.CUS.TAX.RETENTIONS.COMMON file
*                        Conversion Tool                24/05/2023            R22 Auto Conversion - Changed T24.BP in insert
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.DATES
    $INSERT I_BATCH.FILES
    $INSERT I_F.AC.CHARGE.REQUEST
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.BENEFICIARY

    $INSERT I_REDO.B.CUS.TAX.RETENTIONS.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_F.REDO.H.TAX.DATA.CHECKS
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_F.REDO.NCF.ISSUED
    $INSERT I_F.REDO.CLEARING.OUTWARD
    $INSERT I_F.REDO.APAP.CLEARING.INWARD

    GOSUB CHK.REDO.NCF
RETURN

CHK.REDO.NCF:
*-----------
*Getting the Customer ID from REDO.NCF.ISSUED Application
    Y.FIN.TAX.AMT = ''; Y.CUS.IDEN = '';  Y.IDEN.TYPE = '0'; L.TT.WV.TAX.VAL = ''; CUST.TYPE = ''
    Y.CUS.NAT = ''; Y.CUS.CIDENT = ''; Y.CUS.RNC = ''; Y.CUS.LEGAL.ID = ''; Y.CUS.FORE = ''; YCUTENT.ID = ''
    L.CU.ACTANAC.VAL = ''; L.CU.NOUNICO.VAL = ''; Y.TXN.REF = ''; Y.DATE.RCF = ''; YF.DATE.RCF = ''; FT.TT.ACCT = ''
    YLEG.IDEN.VAL = ''; ENT.ID = ''; R.STMT.ENTRY = ''; STMT.ENTRY.ERR = ''; Y.ACR.STATUS = ''; Y.CUS.IDEN1 = ''
    Y.FX.STATUS = ''; Y.FT.STATUS = ''; Y.TT.STATUS = ''; TRANS.REF = ''; AMT.LCY = ''; L.TT.CLNT.TYPE.VAL = ''
    CU.TIPO.CL = ''; YACCT.JOINT = ''; YCM.CUST.TYPE = ''; YCM.CUS.IDEN = ''; YR.CUSTOMER= ''; L.TT.CLNT.TYPE.VAL = ''
    Y.TXN.TYPE = ''; Y.BEN.CUST.TYPE = ''; Y.BEN.IDENT = ''

    ENT.ID = FIELD(Y.NCF.CUS.ID,'*',2)
    CALL F.READ(FN.STMT.ENTRY,ENT.ID,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENTRY.ERR)
    IF STMT.ENTRY.ERR THEN
        RETURN
    END
    THER.REF = R.STMT.ENTRY<AC.STE.THEIR.REFERENCE>
    AMT.LCY = R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
    Y.CUSTOMER = R.STMT.ENTRY<AC.STE.CUSTOMER.ID>
    Y.DATE.RCF = R.STMT.ENTRY<AC.STE.BOOKING.DATE>
    TRANS.REF = R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
    Y.TXN.REF = FIELD(TRANS.REF,'\',1)
    GOSUB GET.CUS.DTLS
RETURN

GET.CUS.DTLS:
*-----------
*Getting the Customer Related Values.
    BEGIN CASE
        CASE Y.TXN.REF[1,2] EQ 'TT'
            GOSUB READ.TELLER
            Y.TT.STATUS = R.TELLER<TT.TE.RECORD.STATUS>
            IF NOT(R.TELLER) OR Y.TT.STATUS EQ 'REVE' THEN
                RETURN
            END
            Y.FIN.TAX.AMT = R.TELLER<TT.TE.LOCAL.REF,Y.TT.TAX.AMT.POS>
            L.TT.WV.TAX.VAL = R.TELLER<TT.TE.LOCAL.REF,L.TT.WV.TAX.POS>
            YLEG.IDEN.VAL = R.TELLER<TT.TE.LOCAL.REF,L.TT.LEGAL.ID.POS>
            L.TT.CLNT.TYPE.VAL = R.TELLER<TT.TE.LOCAL.REF,L.TT.CLNT.TYPE.POS>
            GOSUB TT.TRANSACTION
        CASE Y.TXN.REF[1,2] EQ 'FT'
            GOSUB READ.FUNDS.TRANS
            Y.FT.STATUS = R.FUNDS.TRANSFER<FT.RECORD.STATUS>
            IF NOT(R.FUNDS.TRANSFER) OR Y.FT.STATUS EQ 'REVE' THEN
                RETURN
            END
            Y.FIN.TAX.AMT = R.FUNDS.TRANSFER<FT.LOCAL.REF,Y.FT.TAX.AMT.POS>
            L.TT.WV.TAX.VAL = R.FUNDS.TRANSFER<FT.LOCAL.REF,L.FT.WV.TAX.POS>
            YLEG.IDEN.VAL = R.FUNDS.TRANSFER<FT.LOCAL.REF,L.FT.LEGAL.ID.POS>
            GOSUB FT.TRANSACTION
        CASE Y.TXN.REF[1,3] EQ 'CHG'
            GOSUB READ.AC.REQUEST
            Y.ACR.STATUS = R.AC.CHARGE.REQUEST<CHG.RECORD.STATUS>
            IF NOT(R.AC.CHARGE.REQUEST) OR Y.ACR.STATUS EQ 'REVE' THEN
                RETURN
            END
            Y.FIN.TAX.AMT = AMT.LCY
            GOSUB ACR.TRANSACTION
        CASE 1
            GOSUB GET.INWARD.PROCESS
            GOSUB GET.OUTWARD.PROCESS
    END CASE

    IF L.TT.WV.TAX.VAL EQ 'YES' OR L.TT.WV.TAX.VAL EQ 'SI' THEN
        Y.CUS.IDEN = Y.APAP.ID
        Y.CUS.IDEN1 = FMT(Y.APAP.ID, "R(#-##-#####-#)")
        CUST.TYPE = 'E1'
    END

    IF Y.FIN.TAX.AMT AND Y.CUS.IDEN NE '' THEN
        GOSUB WRITE.SEQ.VAL
    END
RETURN



TT.TRANSACTION:
***************
    GOSUB TT.ACCT.VAL
    IF NOT(Y.CUSTOMER) THEN
        GOSUB READ.ACCOUNT
    END
    IF NOT(YLEG.IDEN.VAL) AND NOT(Y.CUSTOMER) THEN
        Y.CUSTOMER = R.TELLER<TT.TE.LOCAL.REF,L.TT.DOC.NUM.POS>
        GOSUB GET.CUST.DET
    END
    GOSUB READ.CUSTOMER
    GOSUB CUST.IDEN.1
RETURN

TT.ACCT.VAL:
************
    FT.TT.DEBIT.ACCT.NO = ''
    Y.DR.CR.MARKER = R.TELLER<TT.TE.DR.CR.MARKER>
    IF Y.DR.CR.MARKER EQ 'DEBIT' THEN
        FT.TT.DEBIT.ACCT.NO = R.TELLER<TT.TE.ACCOUNT.1>
    END ELSE
        FT.TT.DEBIT.ACCT.NO = R.TELLER<TT.TE.ACCOUNT.2>
    END
    FT.TT.ACCT = FT.TT.DEBIT.ACCT.NO
RETURN

FT.TRANSACTION:
***************
    FT.TT.ACCT = R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>
    IF NOT(Y.CUSTOMER) THEN
        FT.TT.DEBIT.ACCT.NO = R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>
        GOSUB READ.ACCOUNT
    END
    GOSUB READ.CUSTOMER
    GOSUB CUST.IDEN.1
RETURN

ACR.TRANSACTION:
****************
    FT.TT.ACCT = R.AC.CHARGE.REQUEST<CHG.DEBIT.ACCOUNT>
    IF NOT(Y.CUSTOMER) THEN
        FT.TT.DEBIT.ACCT.NO = R.AC.CHARGE.REQUEST<CHG.DEBIT.ACCOUNT>
        GOSUB READ.ACCOUNT
    END
    GOSUB CUST.DET.REP
RETURN

GET.INWARD.PROCESS:
*******************
    R.REDO.APAP.CLEARING.INWARD = ''; REDO.APAP.CLEARING.INWARD.ERR = ''
    CALL F.READ(FN.REDO.APAP.CLEARING.INWARD,Y.TXN.REF,R.REDO.APAP.CLEARING.INWARD,F.REDO.APAP.CLEARING.INWARD,REDO.APAP.CLEARING.INWARD.ERR)
    IF NOT(R.REDO.APAP.CLEARING.INWARD) THEN
        RETURN
    END
    Y.FIN.TAX.AMT = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.TAX.AMOUNT>
    Y.CUSTOMER = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.CUSTOMER.NO>
    FT.TT.DEBIT.ACCT.NO = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.ACCOUNT.NO>
    IF NOT(Y.CUSTOMER) THEN
        GOSUB READ.ACCOUNT
    END
    GOSUB CUST.DET.REP
RETURN

GET.OUTWARD.PROCESS:
********************
    DRAW.ACCT = ''; CHQ.NO = ''; OUT.ID = ''; YTEMP.FIN.TAX.AMT = 0
    DRAW.ACCT = FIELD(Y.TXN.REF,'.',1); CHQ.NO = FIELD(Y.TXN.REF,'.',2)
    CHQ.NO = TRIM(CHQ.NO,"0","L")
    OUT.ID = DRAW.ACCT:'-':CHQ.NO
    R.REDO.CLEARING.OUTWARD = ''; REDO.CLEARING.OUTWARD.ERR = ''
    CALL F.READ(FN.REDO.CLEARING.OUTWARD,OUT.ID,R.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD,REDO.CLEARING.OUTWARD.ERR)
    IF NOT(R.REDO.CLEARING.OUTWARD) THEN
        RETURN
    END
    YTEMP.FIN.TAX.AMT = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.AMOUNT> * 0.0015
    Y.FIN.TAX.AMT = FMT(YTEMP.FIN.TAX.AMT,'R2')
    FT.TT.DEBIT.ACCT.NO = DRAW.ACCT
    GOSUB READ.ACCOUNT
    GOSUB CUST.DET.REP
RETURN

CUST.DET.REP:
*************
    GOSUB READ.CUSTOMER
    GOSUB GET.CUST.IDEN
    IF NOT(Y.CUS.IDEN) AND Y.CUS.LEGAL.ID THEN
        Y.CUS.IDEN = Y.CUS.NAT:Y.CUS.LEGAL.ID
        Y.CUS.IDEN1 = Y.CUS.IDEN
    END
RETURN

CUST.IDEN.1:
************
    GOSUB GET.CUST.IDEN
    IF Y.CUS.IDEN THEN
        RETURN
    END ELSE
        GOSUB GET.CUST.ID
    END
RETURN

GET.CUST.IDEN:
**************
    IF NOT(R.CUSTOMER) THEN
        RETURN
    END
    OUT.ARR = ''
*    CALL DR.REG.GET.CUST.TYPE(R.CUSTOMER,OUT.ARR)
    APAP.LAPAP.drRegGetCustType(R.CUSTOMER,OUT.ARR) ;* R22 Manual Conversion
    Y.CUS.NAT = R.CUSTOMER<EB.CUS.NATIONALITY>
    Y.CUS.CIDENT = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CIDENT.POS>
    Y.CUS.RNC = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.RNC.POS>
    CU.TIPO.CL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>
    Y.CUS.LEGAL.ID = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    Y.CUS.IDEN1 = OUT.ARR<2>
    CUST.TYPE = OUT.ARR<1>
    BEGIN CASE
        CASE Y.CUS.CIDENT NE ''
            Y.CUS.IDEN = Y.CUS.CIDENT
            Y.CUS.IDEN1 = FMT(Y.CUS.CIDENT, "R(###-#######-#)")
            Y.IDEN.TYPE = '2'
        CASE Y.CUS.RNC NE ''
            Y.CUS.IDEN = Y.CUS.RNC
            Y.CUS.IDEN1 = FMT(Y.CUS.RNC, "R(#-##-#####-#)")
            Y.IDEN.TYPE = '1'
        CASE CU.TIPO.CL EQ 'CLIENTE MENOR' AND Y.CUS.CIDENT EQ ''
            IF NOT(FT.TT.DEBIT.ACCT.NO) THEN
                FT.TT.DEBIT.ACCT.NO = FT.TT.ACCT
            END
            IF NOT(R.ACCOUNT) THEN
                GOSUB READ.ACCOUNT
            END
            YACCT.JOINT = R.ACCOUNT<AC.JOINT.HOLDER,1>
            YR.CUSTOMER = R.CUSTOMER; Y.CUSTOMER = YACCT.JOINT
            GOSUB READ.CUSTOMER
*            CALL DR.REG.GET.CUST.TYPE(R.CUSTOMER,OUT.ARR)
            APAP.LAPAP.drRegGetCustType(R.CUSTOMER,OUT.ARR) ;* R22 Manual Conversion
            YCM.CUST.TYPE = OUT.ARR<1>
            Y.CUST.IDEN1 = OUT.ARR<2>
            Y.CUST.IDEN = Y.CUST.IDEN1
            R.CUSTOMER = YR.CUSTOMER
    END CASE
RETURN

READ.CUSTOMER:
**************
    R.CUSTOMER = ''; Y.CUS.ERR = ''
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
RETURN

GET.CUST.ID:
************
    Y.NATION = ''; YLEG.TYPE = ''
    YLEG.TYPE = FIELD(YLEG.IDEN.VAL,'.',1)
    BEGIN CASE
        CASE YLEG.TYPE EQ 'CEDULA' AND YLEG.TYPE NE ''
            Y.CUS.IDEN = FIELD(YLEG.IDEN.VAL,'.',2)
            Y.CUS.IDEN1 = FMT(Y.CUS.IDEN1, "R(###-#######-#)")
            Y.IDEN.TYPE = '2'
        CASE YLEG.TYPE EQ 'RNC'
            Y.CUS.IDEN = FIELD(YLEG.IDEN.VAL,'.',2)
            Y.CUS.IDEN1 = FMT(Y.CUS.IDEN1, "R(#-##-#####-#)")
            Y.IDEN.TYPE = '1'
        CASE YLEG.TYPE EQ 'PASAPORTE'
            Y.CUS.IDEN = FIELD(YLEG.IDEN.VAL,'.',2)
            Y.CUS.IDEN = Y.CUS.NAT:Y.CUS.IDEN
            Y.CUS.IDEN1 = Y.CUS.IDEN
    END CASE
    IF NOT(Y.CUST.IDEN) THEN
        Y.CUST.IDEN = Y.CUST.IDEN1
    END
    IF Y.CUS.LEGAL.ID AND Y.CUS.IDEN EQ '' THEN
        Y.CUS.IDEN = Y.CUS.NAT:Y.CUS.LEGAL.ID
        Y.CUS.IDEN1 = Y.CUS.IDEN
    END
    IF NOT(CUST.TYPE) AND L.TT.CLNT.TYPE.VAL THEN
        CUST.TYPE = L.TT.CLNT.TYPE.VAL
    END
RETURN

READ.ACCOUNT:
*************
    R.ACCOUNT = ''; ACC.ERR = ''
    CALL F.READ(FN.ACCOUNT,FT.TT.DEBIT.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT THEN
        Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
    END
RETURN

READ.TELLER:
************
    R.TELLER = ''; TELLER.ERR = '';Y.TRANS.REF = ''; TELLER.HIS.ERR = ''; Y.TT.STATUS = ''
    CALL F.READ(FN.TELLER,Y.TXN.REF,R.TELLER,F.TELLER,TELLER.ERR)
    IF NOT(R.TELLER) THEN
        Y.TRANS.REF = Y.TXN.REF
        CALL EB.READ.HISTORY.REC(F.TELLER.HIS,Y.TRANS.REF,R.TELLER,TELLER.HIS.ERR)
    END
RETURN

READ.FUNDS.TRANS:
*****************
    R.FUNDS.TRANSFER = ''; FUNDS.TRANSFER.ERR = ''; Y.TRANS.REF = ''; FUNDS.TRANSFER.HIS.ERR = ''
    CALL F.READ(FN.FUNDS.TRANSFER,Y.TXN.REF,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.TRANSFER.ERR)
    IF NOT(R.FUNDS.TRANSFER) THEN
        Y.TRANS.REF = Y.TXN.REF
        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,Y.TRANS.REF,R.FUNDS.TRANSFER,FUNDS.TRANSFER.HIS.ERR)
    END
RETURN

READ.AC.REQUEST:
****************
    ERR.AC.CHARGE.REQUEST = ''; R.AC.CHARGE.REQUEST = ''; AC.CHARGE.REQUEST.HIS.ERR = ''; Y.TRANS.REF = ''
    CALL F.READ(FN.AC.CHARGE.REQUEST,Y.TXN.REF,R.AC.CHARGE.REQUEST,F.AC.CHARGE.REQUEST,ERR.AC.CHARGE.REQUEST)
    IF NOT(R.AC.CHARGE.REQUEST) THEN
        Y.TRANS.REF = Y.TXN.REF
        CALL EB.READ.HISTORY.REC(F.AC.CHARGE.REQUEST.HST,Y.TRANS.REF,R.AC.CHARGE.REQUEST,AC.CHARGE.REQUEST.HIS.ERR)
    END
RETURN
READ.BENEFICIARY:
*****************
    R.BENEFICIARY = ''; ERR.BENEFICIARY = ''
    CALL F.READ(FN.BENEFICIARY,Y.BENEFICIARY,R.BENEFICIARY,F.BENEFICIARY,ERR.BENEFICIARY)
RETURN
*------------------------------------------
*------------------------------------------
GET.BENEFICIARY.DTLS:
    BEGIN CASE
        CASE Y.TXN.REF[1,2] EQ 'TT'
            Y.BEN.CUST.TYPE = L.TT.CLNT.TYPE.VAL
            Y.BEN.IDENT = R.TELLER<TT.TE.LOCAL.REF,L.ID.PERS.BENEF.POS>;* R22 Manual conversion L.ID.PERS.BENEF.POS variable Added in I_REDO.B.CUS.TAX.RETENTIONS.COMMON file
            Y.BEN.COUNTRY = R.TELLER<TT.TE.LOCAL.REF,L.COUNTRY.POS>;* R22 Manual conversion L.COUNTRY.POS variable Added in I_REDO.B.CUS.TAX.RETENTIONS.COMMON file
            IF Y.BEN.COUNTRY NE 'DO' THEN
                Y.BEN.IDENT = Y.BEN.COUNTRY : Y.BEN.IDENT
            END
*According to DGII flyer no. 009/18, this two field will appear only for FT, hence let's blank those fields.
            Y.BEN.CUST.TYPE = ''
            Y.BEN.IDENT = ''
        CASE Y.TXN.REF[1,2] EQ 'FT'
*FUNDS.TRANSFER>BENEFICIARY.ID --> BENEFICIARY>L.BEN.DOC.ARCIB|L.BEN.CEDULA
*(Has to be calculated as is in the report field 2)
            Y.BENEFICIARY = R.FUNDS.TRANSFER<FT.BENEFICIARY.ID>
            IF (Y.BENEFICIARY) THEN
                OUT.ARR2 = ''
*               CALL L.APAP.BEN.PER.TYPE.RT(Y.BENEFICIARY,OUT.ARR2)
                APAP.LAPAP.lApapBenPerTypeRt(Y.BENEFICIARY,OUT.ARR2) ;* R22 Manual Conversion
                Y.BEN.CUST.TYPE = OUT.ARR2<1>
                Y.BEN.IDENT = OUT.ARR2<2>
*Finally we're going to check if the FT.TXN.TYPE is elegible to pass APAP as beneficiary...
                Y.FT.TXN.TYPE = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
                CALL F.READ(FN.ST.L.APAP.DG01.APAP.BEN.TXN,'FUNDS.TRANSFER',R.ST.L.APAP,F.ST.L.APAP.DG01.APAP.BEN.TXN,ERR.ST.L.APAP)

                IF R.ST.L.APAP NE '' THEN
                    Y.ST.L.APAP.VAL = R.ST.L.APAP<1>
*Y.CANT.ST = DCOUNT(Y.ST.L.APAP.VAL,@VM)
*FOR I = 1 TO Y.CANT.ST STEP 1
*    IF Y.ST.L.APAP.VAL<1,I> EQ Y.FT.TXN.TYPE THEN
*        Y.BEN.CUST.TYPE = 'E1'
*        Y.BEN.IDENT = '4-01-00013-1'
*    END
*NEXT I
                    IF OUT.ARR2 EQ '' THEN

                        FINDSTR Y.FT.TXN.TYPE IN Y.ST.L.APAP.VAL SETTING Ap, Vp THEN
                            Y.BEN.CUST.TYPE = 'E1'
                            Y.BEN.IDENT = '4-01-00013-1'
                        END ELSE
                            RETURN
                        END
                    END

                END

            END ELSE
                Y.FT.TXN.TYPE = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
                CALL F.READ(FN.ST.L.APAP.DG01.APAP.BEN.TXN,'FUNDS.TRANSFER',R.ST.L.APAP,F.ST.L.APAP.DG01.APAP.BEN.TXN,ERR.ST.L.APAP)
                IF R.ST.L.APAP NE '' THEN
                    Y.ST.L.APAP.VAL = R.ST.L.APAP<1>
                    FINDSTR Y.FT.TXN.TYPE IN Y.ST.L.APAP.VAL SETTING Ap, Vp THEN
                        Y.BEN.CUST.TYPE = 'E1'
                        Y.BEN.IDENT = '4-01-00013-1'
                    END ELSE
                        RETURN
                    END

                END
            END

        CASE Y.TXN.REF[1,3] EQ 'CHG'



    END CASE

RETURN
*-------------------------------------------
*-------------------------------------------
WRITE.SEQ.VAL:
*-------------
    YCUTENT.ID = 'REGN11-':Y.CUS.IDEN:'-':ENT.ID

    IF Y.TXN.REF[1,2] EQ "TT" THEN
        Y.TXN.TYPE = "C"
    END
    IF Y.TXN.REF[1,2] EQ "FT" THEN
        Y.TXN.TYPE = "T"
    END
    GOSUB GET.BENEFICIARY.DTLS
    YF.DATE.RCF = Y.DATE.RCF[1,6]
    Y.FINAL.MSG = Y.CUS.IDEN:',':Y.IDEN.TYPE:',':YF.DATE.RCF:',':Y.FIN.TAX.AMT:',':CUST.TYPE
    IF Y.FINAL.MSG THEN
        CALL F.WRITE(FN.DR.REG.REGN11.WORKFILE,YCUTENT.ID,Y.FINAL.MSG)
    END
    C$SPARE(352) = ''; C$SPARE(353) = ''; C$SPARE(354) = ''; C$SPARE(355) = ''; YDG.DATE.RCF = ''; C$SPARE(356) = ''; C$SPARE(357) = ''; C$SPARE(358) = '';
    YDG.DATE.RCF = Y.DATE.RCF[1,4]:'/':Y.DATE.RCF[5,2]:'/':Y.DATE.RCF[7,2]
    IF NOT(YCM.CUST.TYPE) THEN
        YCM.CUST.TYPE = CUST.TYPE
    END

    C$SPARE(352) = YCM.CUST.TYPE
    C$SPARE(353) = Y.CUS.IDEN1[1,15]
    C$SPARE(354) = YDG.DATE.RCF
    C$SPARE(355) = Y.FIN.TAX.AMT
    C$SPARE(356) = Y.TXN.TYPE
    C$SPARE(357) = Y.BEN.CUST.TYPE
    C$SPARE(358) = Y.BEN.IDENT
    YDG.CUTENT.ID = 'DG01-':Y.CUS.IDEN:'-':ENT.ID
    MAP.FMT = 'MAP'
    ID.RCON.L = "REDO.RCL.DG01"
    ID.APP = Y.PARAM.ID ;* R22 Manual conversion Y.PARAM.ID variable Added in I_REDO.B.CUS.TAX.RETENTIONS.COMMON file
    R.APP = R.REDO.H.REPORTS.PARAM ;* R22 Manual conversion R.REDO.H.REPORTS.PARAM variable Added in I_REDO.B.CUS.TAX.RETENTIONS.COMMON file
    R.APP = ''
    APP = FN.REDO.H.REPORTS.PARAM
    R.RETURN.MSG= ''; ERR.MSG= ''
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    IF R.RETURN.MSG THEN
        CALL F.WRITE(FN.DR.REG.REGN11.WORKFILE,YDG.CUTENT.ID,R.RETURN.MSG)
    END
RETURN

GET.CUST.DET:
*************
    ERR.CUSTOMER.L.CU.CIDENT = ''; R.CUSTOMER.L.CU.CIDENT = ''
    CALL F.READ(FN.CUSTOMER.L.CU.CIDENT,Y.CUSTOMER,R.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT,ERR.CUSTOMER.L.CU.CIDENT)
    IF R.CUSTOMER.L.CU.CIDENT THEN
        Y.CUSTOMER = R.CUSTOMER.L.CU.CIDENT
        RETURN
    END
    ERR.CUSTOMER.L.CU.RNC = ''; R.CUSTOMER.L.CU.RNC = ''
    CALL F.READ(FN.CUSTOMER.L.CU.RNC,Y.CUSTOMER,R.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC,ERR.CUSTOMER.L.CU.RNC)
    IF R.CUSTOMER.L.CU.RNC THEN
        Y.CUSTOMER = R.CUSTOMER.L.CU.RNC
        RETURN
    END
    ERR.CUSTOMER.L.CU.PASS.NAT = ''; R.CUSTOMER.L.CU.PASS.NAT = ''
    CALL F.READ(FN.CUSTOMER.L.CU.PASS.NAT,Y.CUSTOMER,R.CUSTOMER.L.CU.PASS.NAT,F.CUSTOMER.L.CU.PASS.NAT,ERR.CUSTOMER.L.CU.PASS.NAT)
    IF R.CUSTOMER.L.CU.PASS.NAT THEN
        Y.CUSTOMER = R.CUSTOMER.L.CU.PASS.NAT
        RETURN
    END
RETURN
END
