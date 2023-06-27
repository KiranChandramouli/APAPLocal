* @ValidationCode : MjotMTM5NzcyMzc5NDpDcDEyNTI6MTY4NTk0OTY4ODAwMDpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jun 2023 12:51:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.INSURANCE.DETAILS.COPY(Y.FIN.ARR)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.NOF.INSURANCE.DETAILS
* ODR NUMBER    : ODR-2010-03-0174
*----------------------------------------------------------------------------------------------------
* Description   : This is No-file Enquiry routine. It will fetch the field details required for enquiry
*
* In parameter  :
* out parameter : Y.FIN.ARR
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 30-11-2010      MARIMUTHU s    ODR-2010-03-0174    Initial Creation
* 15-08-2012      H GANESH          PACS00198501     Modification
* 23-05-2023     Conversion Tool        R22 Auto Conversion - FM TO @FM AND VM TO @VM AND SM TO @SM AND ++ TO + =1
* 23-05-2023      ANIL KUMAR B          R22 Manual Conversion - AA.CUS.OWNER changed to AA.CUS.CUSTOMER and AA.CUS.PRIMARY.OWNER changed to AA.CUS.CUSTOMER AND ADD PACKAGE TO CALL RTN
*----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.COLLATERAL
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FRONT.CLAIMS
    $INSERT I_ENQUIRY.COMMON

    GOSUB OPEN.FILES
    GOSUB FORM.SELECTION
    GOSUB PROCESS
RETURN
*-------------------------------------------------
OPEN.FILES:
*-------------------------------------------------

    FN.APAP.H.INSURANCE.DETAILS = 'F.APAP.H.INSURANCE.DETAILS'
    F.APAP.H.INSURANCE.DETAILS  = ''
    CALL OPF(FN.APAP.H.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLATERAL = ''
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)

    FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'

    FN.REDO.FRONT.CLAIMS = 'F.REDO.FRONT.CLAIMS'
    F.REDO.FRONT.CLAIMS = ''
    CALL OPF(FN.REDO.FRONT.CLAIMS,F.REDO.FRONT.CLAIMS)

    FN.RCA = 'F.REDO.CREATE.ARRANGEMENT'
    F.RCA = ''
    CALL OPF(FN.RCA,F.RCA)

    FN.RCA.ID = 'F.REDO.CREATE.ARRANGEMENT.ID.ARRANGEMENT'
    F.RCA.ID = ''
    CALL OPF(FN.RCA.ID,F.RCA.ID)

    Y.FIN.ARR = ''

    Y.APLS = 'COLLATERAL'
    Y.FLDS = 'L.COL.PRO.DESC2'
    CALL MULTI.GET.LOC.REF(Y.APLS,Y.FLDS,POS.L)
    Y.DES.POS = POS.L<1,1>

RETURN
*-------------------------------------------------
FORM.SELECTION:
*-------------------------------------------------


     APAP.REDOENQ.redoEFormSelStmt(FN.APAP.H.INSURANCE.DETAILS, '', '', SEL.CMD)  ;*R22 MANUAL Conversion
    SEL.CMD := ' BY ASSOCIATED.LOAN'

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

    Y.ETS.VAL = ''
    LOCATE 'ESTATUS' IN D.FIELDS SETTING POS.ES THEN
        Y.ETS.VAL = D.RANGE.AND.VALUE<POS.ES>
    END

    LOCATE 'DATE.MOVE' IN D.FIELDS SETTING POS.DE THEN
        Y.DT.RNG = D.RANGE.AND.VALUE<POS.ES>
        Y.DT.RNG.1 = FIELD(Y.DT.RNG,@SM,1) ; Y.DT.RNG.2 = FIELD(Y.DT.RNG,@SM,2)
    END

RETURN
*-------------------------------------------------
PROCESS:
*-------------------------------------------------
    Y.VAR1 = 1

    LOOP
    WHILE Y.VAR1 LE NO.OF.REC
        Y.INS.ID = SEL.LIST<Y.VAR1>
        CALL F.READ(FN.APAP.H.INSURANCE.DETAILS,Y.INS.ID,R.APAP.H.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS,INS.ERR)
        Y.LOAN.IDS = R.APAP.H.INSURANCE.DETAILS<INS.DET.ASSOCIATED.LOAN>
        Y.DATE.TIME = '20':R.APAP.H.INSURANCE.DETAILS<INS.DET.DATE.TIME>[1,6]

        IF Y.LOAN.IDS THEN
            IF Y.DT.RNG THEN
                IF Y.DATE.TIME GE Y.DT.RNG.1 AND Y.DATE.TIME LE Y.DT.RNG.2 THEN
                    GOSUB PROCESS.LOANS
                END
            END ELSE
                GOSUB PROCESS.LOANS
            END
        END
        Y.VAR1 += 1
    REPEAT

RETURN
*-------------------------------------------------
PROCESS.LOANS:
*-------------------------------------------------
    Y.LOANS.CNT = DCOUNT(Y.LOAN.IDS,@VM)
    Y.VAR2 = 1
    LOOP
    WHILE Y.VAR2 LE Y.LOANS.CNT
        Y.AA.ID = Y.LOAN.IDS<1,Y.VAR2>
        GOSUB GET.DETAILS
        Y.VAR2 += 1
    REPEAT
RETURN
*-------------------------------------------------
GET.DETAILS:
*-------------------------------------------------

    GOSUB GET.RCA.DET
    GOSUB GET.ALTERNATE.ID
    GOSUB GET.ARRANGEMENT.DETAILS
    GOSUB GET.CUSTOMER.DETAILS
    GOSUB GET.INSURANCE.DETAILS
    GOSUB GET.TERM.DETAILS
    GOSUB OTHER.DETAILS
    GOSUB UPDATE.FINAL.ARRAY
RETURN

GET.RCA.DET:

    CALL F.READ(FN.RCA.ID,Y.AA.ID,R.RCA.ID,F.RCA.ID,ERR.RCA)
    IF NOT(R.RCA.ID) THEN
        RETURN
    END
    Y.RCA.ID = FIELD(R.RCA.ID,'*',2)

    CALL F.READ(FN.RCA,Y.RCA.ID,R.RCA,F.RCA,RCA.ERR)
    Y.POL.NUM = R.APAP.H.INSURANCE.DETAILS<INS.DET.ID.TEMPORAL>

    Y.POL.MM = R.RCA<REDO.FC.POLICY.NUMBER>

    LOCATE Y.POL.NUM IN R.RCA<REDO.FC.POLICY.NUMBER.AUX,1> SETTING POS.POL THEN
        Y.CLS.POL = R.RCA<REDO.FC.CLASS.POLICY>
        IF Y.CLS.POL EQ 'ED' THEN
            Y.ENDOR.AMT = SUM(R.RCA<REDO.FC.INS.SEC.COM.AMT>)
        END ELSE
            Y.INS.COM.AMT = SUM(R.RCA<REDO.FC.INS.SEC.COM.AMT>)
        END
    END

RETURN
*-------------------------------------------------
GET.ALTERNATE.ID:
*-------------------------------------------------

    EFF.DATE        = ''
    PROP.CLASS      = 'ACCOUNT'
    PROPERTY        = ''
    R.ACC.CONDITION = ''
    ERR.MSG         = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.ACC.CONDITION,ERR.MSG)
    Y.PREV.LOAN.NO = R.ACC.CONDITION<AA.AC.ALT.ID>
    Y.LOAN.NO      = ''
    IN.ACC.ID      = ''
    CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,Y.AA.ID,Y.LOAN.NO,ERR.TEXT)

RETURN
*-------------------------------------------------
GET.ARRANGEMENT.DETAILS:
*-------------------------------------------------

    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
    Y.PRODUCT       = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    Y.PRODUCT.GROUP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    Y.CUS.ID        = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    Y.COMP.CODE     = R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
RETURN
*-------------------------------------------------
GET.CUSTOMER.DETAILS:
*-------------------------------------------------

    EFF.DATE        = ''
    PROP.CLASS      = 'CUSTOMER'
    PROPERTY        = ''
    R.ACC.CONDITION = ''
    ERR.MSG         = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CUS.CONDITION,ERR.MSG)
*Y.CUS.IDS       = R.CUS.CONDITION<AA.CUS.PRIMARY.OWNER>
    Y.CUS.IDS       = R.CUS.CONDITION<AA.CUS.CUSTOMER>  ;*R22 Manual Conversion
*Y.CUS.IDS<1,-1> = R.CUS.CONDITION<AA.CUS.OWNER>
    Y.CUS.IDS<1,-1> = R.CUS.CONDITION<AA.CUS.CUSTOMER>  ;*R22 Manual Conversion
    Y.CUSTOMER.NAME = ''
    Y.DUB.IDS = ''
    CHANGE @VM TO @FM IN Y.CUS.IDS
    Y.VAR3 = 1
    Y.CUS.CNT = DCOUNT(Y.CUS.IDS,@FM)
    LOOP
    WHILE Y.VAR3 LE Y.CUS.CNT
        Y.CUSTOMER = Y.CUS.IDS<Y.VAR3>
        LOCATE Y.CUSTOMER IN Y.DUB.IDS SETTING CUS.POS ELSE
            CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
            Y.CUSTOMER.NAME<1,-1> = R.CUSTOMER<EB.CUS.SHORT.NAME>
            Y.DUB.IDS<-1> = Y.CUSTOMER
        END
        Y.VAR3 += 1
    REPEAT
RETURN
*-----------------------------------------
GET.INSURANCE.DETAILS:
*-----------------------------------------
    Y.POLICY.NUMBER   = R.APAP.H.INSURANCE.DETAILS<INS.DET.POLICY.NUMBER>
    Y.POLICY.TYPE     = R.APAP.H.INSURANCE.DETAILS<INS.DET.INS.POLICY.TYPE>
    Y.INS.COMPANY     = R.APAP.H.INSURANCE.DETAILS<INS.DET.INS.COMPANY>
    Y.CLASS.POLICY    = R.APAP.H.INSURANCE.DETAILS<INS.DET.CLASS.POLICY>
    Y.POLICY.EXP.DATE = R.APAP.H.INSURANCE.DETAILS<INS.DET.POL.EXP.DATE>
    Y.POLICY.ORG.DATE = R.APAP.H.INSURANCE.DETAILS<INS.DET.POLICY.ORG.DATE>
    Y.INSURED.AMOUNT  = R.APAP.H.INSURANCE.DETAILS<INS.DET.INS.AMOUNT>
    Y.PAYMNT.TYPE = R.APAP.H.INSURANCE.DETAILS<INS.DET.PAYMENT.TYPE>

    IF Y.PAYMNT.TYPE EQ 'INSURANCE' THEN
        Y.MON.POL.AMOUNT  = R.APAP.H.INSURANCE.DETAILS<INS.DET.MON.POL.AMT>
    END ELSE
        Y.MON.POL.AMOUNT  = R.APAP.H.INSURANCE.DETAILS<INS.DET.TOTAL.PRE.AMT>
    END
    Y.EXTRA.AMOUNT    = R.APAP.H.INSURANCE.DETAILS<INS.DET.EXTRA.AMT>
    Y.MANAGE.TYPE     = R.APAP.H.INSURANCE.DETAILS<INS.DET.MANAGEMENT.TYPE>
    Y.CURRENCY        = R.APAP.H.INSURANCE.DETAILS<INS.DET.CURRENCY>
    Y.COLLATERAL.CODE = R.APAP.H.INSURANCE.DETAILS<INS.DET.COLLATERAL.ID,Y.VAR2>
RETURN
*-----------------------------------------
GET.TERM.DETAILS:
*-----------------------------------------

    EFF.DATE        = ''
    PROP.CLASS      = 'TERM.AMOUNT'
    PROPERTY        = ''
    R.ACC.CONDITION = ''
    ERR.MSG         = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.TERM.CONDITION,ERR.MSG)
    Y.TERM            =  R.TERM.CONDITION<AA.AMT.TERM>
    Y.COL.CODE = '' ; Y.COL.DESCD = ''
*CHANGE VM TO VM IN Y.COLLATERAL.CODE
    CHANGE @SM TO @VM IN Y.COLLATERAL.CODE
    Y.COLL.CNT = DCOUNT(Y.COLLATERAL.CODE,@VM)
    Y.CNT1 = 1
    LOOP
    WHILE Y.CNT1 LE Y.COLL.CNT
        Y.COLL.ID  = Y.COLLATERAL.CODE<1,Y.CNT1>
        CALL F.READ(FN.COLLATERAL,Y.COLL.ID,R.COLLATERAL,F.COLLATERAL,COL.ERR)
        Y.COL.CODE<1,-1> = R.COLLATERAL<COLL.COLLATERAL.CODE>
        Y.COL.DESC = R.COLLATERAL<COLL.LOCAL.REF,Y.DES.POS>
        Y.COL.DESC = CHANGE(Y.COL.DESC,@SM," ")
        Y.COL.DESCD<1,-1> = Y.COL.DESC
        Y.CNT1 += 1
    REPEAT

RETURN
*------------------------------------------
OTHER.DETAILS:
*------------------------------------------

* CALL CACHE.READ(FN.REDO.APAP.PROPERTY.PARAM,Y.PRODUCT.GROUP,R.REDO.APAP.PROPERTY.PARAM,PAR.ERR)

* Y.INS.COMM.FIXED.PROPERTY = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.INS.COMM.FIXED>
* Y.INS.COMM.VAR.PROPERTY   = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.INS.COMM.VARIABLE>
* Y.ENDORSED.PROPERTY       = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.ENDORSE.COMM>

* GOSUB GET.SCHEDULE
* GOSUB GET.CHARGE.AMOUNTS

    Y.FIRST.PAYMENT.DATE = R.APAP.H.INSURANCE.DETAILS<INS.DET.INS.START.DATE>

    SEL.CMD.CLAIM = 'SELECT ':FN.REDO.FRONT.CLAIMS:' WITH ACCOUNT.ID EQ ':Y.LOAN.NO
    CALL EB.READLIST(SEL.CMD.CLAIM,SEL.LIST.CLAIM,'',NO.OF.REC.CLAIM,SEL.ERR)
    Y.REC.CLAIM = SEL.LIST.CLAIM<1>
    CALL F.READ(FN.REDO.FRONT.CLAIMS,Y.REC.CLAIM,R.REDO.CLAIMS,F.REDO.FRONT.CLAIMS,CLA.ERR)
    Y.CLAIM.STATUS = R.REDO.CLAIMS<FR.CL.STATUS>

    Y.ST.EST = ''
    IF Y.ETS.VAL THEN
        IF Y.ETS.VAL EQ Y.CLAIM.STATUS THEN
            Y.ST.EST = 'Y'
        END
    END ELSE
        Y.ST.EST = 'Y'
    END

RETURN
*------------------------------------------
*GET.SCHEDULE:
*------------------------------------------

* SIMULATION.REF = ''
* NO.RESET = '1'
* YREGION = ''
* YDATE = TODAY
* Y.YEAR = YDATE[1,4] + 2
* YDAYS.ORIG = Y.YEAR:TODAY[5,4]
* DATE.RANGE = TODAY:FM:YDAYS.ORIG    ;* Date range is passed for 2 years to avoid building schedule for whole loan term
* CALL AA.SCHEDULE.PROJECTOR(Y.AA.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, DUE.DATES, DUE.TYPES, DUE.METHODS,DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
* CHANGE SM TO FM IN DUE.PROPS
* CHANGE VM TO FM IN DUE.PROPS
* CHANGE SM TO FM IN DUE.PROP.AMTS
* CHANGE VM TO FM IN DUE.PROP.AMTS

*  RETURN
*------------------------------------------
*GET.CHARGE.AMOUNTS:
*------------------------------------------

* Y.INS.FIXED.COMMISSION  = 0
* Y.INS.VARIB.COMMISSION  = 0
* Y.END.COMMISSION        = 0

* Y.PROP                 = Y.INS.COMM.FIXED.PROPERTY
* GOSUB GET.PROP.AMOUNTS
* Y.INS.FIXED.COMMISSION = Y.PROP.AMT
* Y.PROP                 = Y.INS.COMM.VAR.PROPERTY
* GOSUB GET.PROP.AMOUNTS
* Y.INS.VARIB.COMMISSION = Y.PROP.AMT
* Y.PROP                 = Y.ENDORSED.PROPERTY
* GOSUB GET.PROP.AMOUNTS
* Y.END.COMMISSION       = Y.PROP.AMT

* RETURN
*------------------------------------------
*GET.PROP.AMOUNTS:
*------------------------------------------
* Y.PROP.AMT = 0
* Y.CNT2 = 1
* Y.PROP.CNT = DCOUNT(Y.PROP,VM)
* LOOP
* WHILE Y.CNT2 LE Y.PROP.CNT
*   Y.INDV.PROP = Y.PROP<1,Y.CNT2>
*   LOCATE Y.INDV.PROP IN DUE.PROPS SETTING PROP.POS THEN
*       Y.PROP.AMT += DUE.PROP.AMTS<PROP.POS>
*   END
*   Y.CNT2++
* REPEAT

* RETURN
*------------------------------------------
UPDATE.FINAL.ARRAY:
*------------------------------------------

    Y.TYPE.MOV = ''

    BEGIN CASE
        CASE R.APAP.H.INSURANCE.DETAILS<INS.DET.POLICY.STATUS> EQ 'CANCELADA'
            Y.TYPE.MOV = 'CANCELACION'
        CASE R.APAP.H.INSURANCE.DETAILS<INS.DET.POLICY.STATUS> EQ 'VENCIDA'
            Y.TYPE.MOV = 'MANTENIMIENTO'
        CASE R.APAP.H.INSURANCE.DETAILS<INS.DET.POLICY.STATUS> EQ 'VIGENTE'
            Y.TYPE.MOV = 'CREACION'
    END CASE


    IF Y.ST.EST EQ 'Y' THEN
        Y.FIN.ARR<-1> = Y.LOAN.NO:'*':Y.PREV.LOAN.NO:'*':Y.PRODUCT:'*':Y.CUSTOMER.NAME:'*':Y.POLICY.NUMBER:'*':Y.POLICY.TYPE:'*':Y.INS.COMPANY:'*':Y.CLASS.POLICY:'*':Y.POLICY.EXP.DATE:'*':Y.TERM:'*':Y.POLICY.ORG.DATE:'*':Y.FIRST.PAYMENT.DATE:'*':Y.COLLATERAL.CODE:'*':Y.COL.CODE:'*':Y.INSURED.AMOUNT:'*':Y.INS.COM.AMT:'*':Y.MON.POL.AMOUNT:'*':Y.EXTRA.AMOUNT:'*':Y.MANAGE.TYPE:'*':Y.INS.COM.AMT:'*':Y.ENDOR.AMT:'*':Y.CLAIM.STATUS:'*':Y.CURRENCY:'*':Y.COMP.CODE:'*':Y.COL.DESCD:'*':Y.TYPE.MOV:'*':Y.DATE.TIME
*                       1                 2            3               4                    5                   6                7                    8                 9                 10             11                      12                       13                 14               15                 16                  17                 18                  19                  20                     21                   22      23              24              25             26               27
    END

RETURN
END
