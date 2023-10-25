* @ValidationCode : Mjo1NDA2OTkyMTk6Q3AxMjUyOjE2OTgyMzkyMzgyNzc6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Oct 2023 18:37:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>98</Rating>
*-----------------------------------------------------------------------------
*SUBROUTINE APAP.GET.LOAN.ACCT.DETAILS(ACTION.INFO, APPL.IDS, MOB.RESPONSE, MOB.ERROR)
SUBROUTINE APAP.GET.LOAN.ACCT.OPTFMT(MOB.REQUEST, MOB.RESPONSE)
*---------------------------------------------------------------------------------------------------
* Description :
*
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_EB.MOB.FRMWRK.COMMON
    $INSERT I_F.AA.PRODUCT
    $INSERT I_F.AA.OVERDUE
*---------------------------------------------------------------------------------------------------

    GOSUB INITIALISE

    GOSUB PROCESS

RETURN

*---------------------------------------------------------------------------------------------------
INITIALISE:
*----------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)

    FN.AA.PRODUCT = 'F.AA.PRODUCT'
    F.AA.PRODUCT = ''
    CALL OPF(FN.AA.PRODUCT, F.AA.PRODUCT)

    FN.AA.ARR.OVERDUE = 'F.AA.ARR.OVERDUE'
    F.AA.ARR.OVERDUE = ''
    CALL OPF(FN.AA.ARR.OVERDUE, F.AA.ARR.OVERDUE)

*    CALL ITSS.MF.GET.APPL.FIELDS(ACTION.INFO, APPL.IDS, MOB.RESPONSE, MOB.ERROR)

*    LOAN.HEADER = 'ACCOUNT.NUMBER':SM:'SHORT.TITLE':SM:'ACCOUNT.TYPE':SM:'OPENING.DATE':SM:'WORKING.BALANCE':SM:'ARRANGEMENT.ID':SM:'CURRENCY':SM:'START.DATE':SM:'MATURITY.DATE';*:SM:'LOAN.STATUS'

    LOCATE 'ARRANGEMENT.ID' IN MOB.RESPONSE<1, 1, 1> SETTING ARR.POS ELSE NULL
    LOCATE 'ACCOUNT.NUMBER' IN MOB.RESPONSE<1, 1, 1> SETTING ACC.POS ELSE NULL

    MOB.RESPONSE<1, 1, -1> = 'LOAN.STATUS':@SM:'INTEREST.RATE':@SM:'COMMITMENT.AMT':@SM:'MONTHLY.INSTALLMENT':@SM:'NO.OF.DUES':@SM:'TOTAL.DUES':@SM:'CONDITION':@SM:'CUR.CAPITAL':@SM:'LIBELLE':@SM:"FEE":@SM:"AMT.DUES.1":@SM:"AMT.DUES.2":@SM:"AMT.DUES.3":@SM:"NEXT.PAYMENT":@SM:"ORIG.CONTRACT.DATE"

RETURN

*---------------------------------------------------------------------------------------------------
PROCESS:
*-------

*    APPL.IDS.CNT = DCOUNT(APPL.IDS, FM)
    APPL.IDS.CNT = DCOUNT(MOB.RESPONSE, @VM)

    FOR ID.CNT = 2 TO APPL.IDS.CNT
*        APPL.ID = APPL.IDS<ID.CNT>
*        ACC.ERR = ''
*        CALL F.READ(FN.ACCOUNT, APPL.ID, R.ACCOUNT, F.ACCOUNT, ACC.ERR)
*        IF NOT(ACC.ERR) THEN
*            ARRANGEMENT.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
        ARRANGEMENT.ID = MOB.RESPONSE<1, ID.CNT, ARR.POS>
        ACCOUNT.ID = MOB.RESPONSE<1, ID.CNT, ACC.POS>

        Y.FEE = ""
        Y.DATE = TODAY

        IF APPL.IDS.CNT LE 2 THEN
            CALL REDO.GET.NEXT.PAYMENT.AMOUNT(ARRANGEMENT.ID,Y.DATE,Y.FEE)
        END

        Y.NEXT.PAYMENT =""

        GOSUB GET.AA.LOAN.STATUS
        GOSUB GET.AA.LOAN.REPORT.HEADER
        GOSUB GET.AA.LOAN.REPORT.FOOTER
        GOSUB GET.AA.ARR.OVERDUE
        GOSUB GET.AA.LOAN.NEXT.PAYMENT

        IF LOAN.STATUS NE 'NODISPLAY' THEN
            MOB.RESPONSE<1, ID.CNT, -1> = LOAN.STATUS:@SM:INTEREST.RATE:@SM:COMMITMENT.AMT:@SM:MONTHLY.INSTALLMENT:@SM:NO.OF.DUES:@SM:TOTAL.DUES:@SM:Y.CONDITION:@SM:Y.CUR.CAPITAL:@SM:Y.LIBELLE:@SM:Y.FEE::@SM:AMT.DUES.1:@SM:AMT.DUES.2:@SM:AMT.DUES.3:@SM:Y.NEXT.PAYMENT:@SM:Y.ORIG.CONTRACT.DATE
        END
*        END
    NEXT ID.CNT

RETURN
*---------------------------------------------------------------------------------------------------
GET.AA.LOAN.NEXT.PAYMENT:
*------------------
    O.DATA =""
    ENQ.SELECTION<2,1,1> = '@ID'
    ENQ.SELECTION<4,1> = ARRANGEMENT.ID
    CALL E.AA.GET.ARR.NEXT.PAYMENT
    Y.NEXT.PAYMENT = O.DATA
RETURN
*---------------------------------------------------------------------------------------------------
GET.AA.LOAN.STATUS:
*------------------

    AA.ERR = ''
    CALL F.READ(FN.AA.ARRANGEMENT, ARRANGEMENT.ID, R.AA.ARRANGEMENT, F.AA.ARRANGEMENT, AA.ERR)
    IF NOT(AA.ERR) THEN

        O.DATA = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>:'*':ARRANGEMENT.ID

        CALL REDO.CK.PAYOFF.ESTATUS

        LOAN.STATUS = O.DATA

        GOSUB GET.ACT.STATUS

        Y.ORIG.CONTRACT.DATE = R.AA.ARRANGEMENT<AA.ARR.ORIG.CONTRACT.DATE>
        Y.PRODUCT.ID = R.AA.ARRANGEMENT<AA.ARR.PRODUCT,1,1>
        AA.ERR = ''
        CALL F.READ(FN.AA.PRODUCT, Y.PRODUCT.ID, R.AA.PRODUCT, F.AA.PRODUCT, AA.ERR)
        Y.LIBELLE = R.AA.PRODUCT<AA.PDT.DESCRIPTION,1,1>
    END

RETURN

*---------------------------------------------------------------------------------------------------
GET.ACT.STATUS:
*--------------

    BEGIN CASE
        CASE LOAN.STATUS EQ 'CURRENT'
            LOAN.STATUS = 'Vigente'
        CASE LOAN.STATUS EQ 'MATURED'
            LOAN.STATUS = 'NODISPLAY'
* LOAN.STATUS = 'Cancelado'
        CASE LOAN.STATUS EQ 'UNAUTH'
            LOAN.STATUS = 'NODISPLAY'
* LOAN.STATUS = 'No Autorizado'
        CASE LOAN.STATUS EQ 'AUTH'
            LOAN.STATUS = 'NODISPLAY'
* LOAN.STATUS = 'Autorizado'
        CASE LOAN.STATUS EQ 'CANCEL'
            LOAN.STATUS = 'NODISPLAY'
*LOAN.STATUS = 'Cancelado'
        CASE LOAN.STATUS EQ 'AUTH-FWD'
            LOAN.STATUS = 'NODISPLAY'
*LOAN.STATUS = 'Autorizado-Futuro'
        CASE LOAN.STATUS EQ 'EXPIRED'
            LOAN.STATUS = 'Expirado'
            LOAN.STATUS.LIB = 'Expirado'
        CASE LOAN.STATUS EQ 'REVERSED'
            LOAN.STATUS = 'NODISPLAY'
* LOAN.STATUS = 'Reversado'
    END CASE

RETURN

*---------------------------------------------------------------------------------------------------
GET.AA.LOAN.REPORT.HEADER:
*-------------------------

    O.DATA = ARRANGEMENT.ID

    CALL E.MB.AA.REPORT.HEADER

    COMMITMENT.AMT = O.DATA['*', 5, 1]

    INTEREST.RATE = TRIM(O.DATA['*', 4, 1], '', 'D')

    O.DATA = ARRANGEMENT.ID

    CALL REDO.E.GET.OUT.BALANCE

    Y.CUR.CAPITAL = O.DATA
    IF APPL.IDS.CNT LE 2 THEN
        D.FIELDS<1> = 'ARRANGEMENT.ID'
        D.RANGE.AND.VALUE<1> = ARRANGEMENT.ID

*    RET.DATA = ARRANGEMENT.ID
        CALL REDO.NOFILE.AA.OVERVIEW.PAYSCH(RET.DATA)
        MONTHLY.INSTALLMENT = 0
        FOR I = 1 TO DCOUNT(RET.DATA,@FM)
            MONTHLY.INSTALLMENT += RET.DATA<I>['*',5, 1]
        NEXT I
    END
RETURN

GET.AA.ARR.OVERDUE:
    ENQ.DATA<2,1> = "ID.COMP.1"
    ENQ.DATA<4,1> = ARRANGEMENT.ID

    Y.CONDITION = ""
    R.ENQ<2> = "AA.ARR.OVERDUE"
    CALL E.AA.BUILD.ARR.COND(ENQ.DATA)
    AA.ARR.OVERDUE.ID = ENQ.DATA<4,1>
*  Y.CONDITION = AA.ARR.OVERDUE.ID
    CALL F.READ(FN.AA.ARR.OVERDUE, AA.ARR.OVERDUE.ID, R.AA.ARR.OVERDUE, F.AA.ARR.OVERDUE, AA.ERR.OV)
    IF NOT(AA.ERR.OV) THEN
        Y.CONDITION = R.AA.ARR.OVERDUE<AA.OD.LOCAL.REF,4>
        FOR IH = 1 TO DCOUNT(Y.CONDITION,@SM)
            IF Y.CONDITION<1,1,IH> MATCHES "Legal" : @VM : "CASTIGADO"  :@VM :"LEGAL" THEN
                Y.CONDITION = "NOPAY"
            END
        NEXT IH
        IF Y.CONDITION NE "NOPAY" THEN
            Y.CONDITION = "PAY"
        END
    END


RETURN


*---------------------------------------------------------------------------------------------------
GET.AA.LOAN.REPORT.FOOTER:
*-------------------------

*    O.DATA = ARRANGEMENT.ID
*
*    CALL E.MB.AA.REPORT.FOOTER
*
*    TOTAL.DUES = O.DATA['#', 8, 1]
*    PRIN.DUE = O.DATA['#', 2, 1]
*    PRIN.INT.DUE = O.DATA['*', 2, 1]['#', 2, 1]

    D.FIELDS<1> = '@ID'
    D.RANGE.AND.VALUE<1> = ACCOUNT.ID

    CALL REDO.BL.GET.ARRANGEMENT(RET.DATA)
*CONVERT FM TO " " IN RET.DATA
*CONVERT VM TO " " IN RET.DATA
*CONVERT SM TO " " IN RET.DATA
    NO.OF.DUES = 0
    TOTAL.DUES= 0
    AMT.DUES.1=0
    AMT.DUES.2=0
    AMT.DUES.3=0

    FOR I=1 TO DCOUNT(RET.DATA,@FM)
        NO.OF.DUES += 1

        O.DATA = RET.DATA<I>['*', 2, 1]

        CALL REDO.E.GET.OS.AMT

        IF NO.OF.DUES EQ 2 THEN
            AMT.DUES.1 += TOTAL.DUES
        END
        IF NO.OF.DUES EQ 3 THEN
            AMT.DUES.2 += TOTAL.DUES
        END
        IF NO.OF.DUES EQ 4 THEN
            AMT.DUES.3 += TOTAL.DUES
        END

        TOTAL.DUES+= O.DATA
    NEXT I
RETURN

*---------------------------------------------------------------------------------------------------

END
