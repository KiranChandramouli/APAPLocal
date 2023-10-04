* @ValidationCode : Mjo4NjM1NjQxNjM6Q3AxMjUyOjE2OTYzOTcxNDg5MTc6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Oct 2023 10:55:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
*-----------------------------------------------------------------------------
* <Rating>245</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*06-09-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE E.ISO.ATM.MINI.STMT.BLD.RTN(Y.ID.LIST)
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CURRENCY
    $INSERT I_F.INTERCO.PARAMETER
*

    GOSUB PROCESS
RETURN
*

INITIALISE:
*-----------*
*get the branch mnemonic using GET.ACCT.BRANCH rtn
    EQU COMMA TO ','
    Y.AC.POS ='' ;Y.AC.POS1 =''

    BAL.LEN ='020';ACC.TYPE ='01'
    Y.ID.LIST ='' ;
    CALL GET.ACCT.BRANCH(Y.ACCT.NO,Y.ACCT.BR.MNE,Y.ACCT.COMP.CDE)
    IF NOT (Y.ACCT.BR.MNE) THEN Y.ACCT.BR.MNE = 'BNK'
*    FN.ACCOUNT = 'F':Y.ACCT.BR.MNE:'.ACCOUNT'

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT =''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)      ;*open after changing com

RETURN          ;*From initialise
*----------------------------------------------------------------------*
PROCESS:
*-------*

    SEL.ACCOUNT = 'ACCOUNT'
    SEL.NO.TXNS = 'NO.OF.TXNS'
    FIND SEL.ACCOUNT IN ENQ.SELECTION SETTING Y.AC.POS1,Y.AC.POS ELSE Y.AC.POS =''
    FIND SEL.NO.TXNS IN ENQ.SELECTION SETTING Y.TXN.POS1,Y.TXN.POS ELSE Y.TXN.POS =''
*temp
    IF NOT(Y.TXN.POS) THEN
        NO.OF.TXNS=5
    END
    IF Y.AC.POS THEN
*get the account no from enquiry
        Y.ACCT.NO = ENQ.SELECTION<4,Y.AC.POS>
*        ACCT.LEN = R.INTERCO.PARAMETER<ST.ICP.ACCOUNT.NO.LENGTH>
*        CONVERT '"' TO '' IN Y.ACCT.NO
*       Y.ACCT.NO = FMT(Y.ACCT.NO,'R%':ACCT.LEN)
** get the branch mnemonic
        GOSUB INITIALISE
        NO.OF.TXNS = TRIM(ENQ.SELECTION<4,Y.TXN.POS>)
        CONVERT '"' TO '' IN NO.OF.TXNS
*        CONVERT '"' TO '' IN Y.ACCT.NO
*        LEN.TXNS = LEN(NO.OF.TXNS)
*        NO.OF.TXNS = NO.OF.TXNS[LEN.TXNS-1,2]
        IF Y.ACCT.NO THEN
            CONVERT '"' TO '' IN Y.ACCT.NO
            CALL AT.GET.ACCT.ENT.DETLS(Y.ACCT.NO,NO.OF.TXNS,TXN.DETLS)
            PRINT 'Account TXN Details ':TXN.DETLS
            TXN.DETLS.LIST=TXN.DETLS
*LEN.TXN.DETLS.LIST=LEN(TXN.DETLS.LIST)
*FMT.TXN.DETLS.LIST=FMT(LEN.TXN.DETLS.LIST,"R%3")
            LEN.TXN.DETLS = LEN (TXN.DETLS)
            LEN.TXN.DETLS = FMT(LEN.TXN.DETLS,'R%3')

            GOSUB GET.BALANCE
            GOSUB GET.UNIQUE.ID

            Y.ID.LIST = "STMT:1:1=":TXN.DETLS.LIST:COMMA:"BALANCE:1:1=":BAL.AFT.TXN:COMMA:"UNIQUE.ID:1:1=":Y.UNIQUE.ID

        END
        PRINT "IDs ARE:":Y.ID.LIST
    END ELSE
        ENQ.ERROR = 'ACCOUNT NUMBER OR NO.OF.TXNS MISSING!'
    END




RETURN          ;*From Process



GET.BALANCE:
*-----------*
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCT,F.ACCOUNT,AC.ER)
    CCY.CODE = R.ACCT<AC.CURRENCY>
    CALL F.READ(FN.CURRENCY,CCY.CODE,R.CCY,F.CURRENCY,ER.CCY)
    NUM.CCY = R.CCY<EB.CUR.NUMERIC.CCY.CODE>
    NUM.CCY = FMT(NUM.CCY,'3%R')
    BAL.AFT.TXN = R.ACCT<AC.WORKING.BALANCE>
*added by liril
*CALL AT.CALC.AVAIL.BALANCE(R.ACCT,BAL.AFT.TXN,AVAIL.BAL)
    APAP.ATM.atCalcAvailBalance(R.ACCT,BAL.AFT.TXN,AVAIL.BAL);*r22 manual code conversion
    
    BAL.AFT.TXN = AVAIL.BAL
    IF BAL.AFT.TXN LE '0' THEN
        BAL.SIGN ='D'
    END ELSE
        BAL.SIGN ='C'
    END
    BAL.AFT.TXN = ABS(BAL.AFT.TXN)
* end of addition

    BAL.AFT.TXN1 = FIELD(BAL.AFT.TXN,'.',1)
    BAL.AFT.TXN2 = FIELD(BAL.AFT.TXN,'.',2)
*    BAL.AFT.TXN1 = FMT(BAL.AFT.TXN1,'10%R')
    BAL.AFT.TXN1 = FMT(BAL.AFT.TXN1,'R%10')
*    BAL.AFT.TXN2 = FMT(BAL.AFT.TXN2,'2%L')
    BAL.AFT.TXN2 = FMT(BAL.AFT.TXN2,'L%2')
    BAL.AFT.TXN = BAL.AFT.TXN1:BAL.AFT.TXN2
    BAL.AFT.TXN = BAL.LEN:ACC.TYPE:'01':NUM.CCY:BAL.SIGN:BAL.AFT.TXN

RETURN          ;*From GET.BALANCE



GET.UNIQUE.ID:
*--------------*
    CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
    CONVERT '.' TO '' IN UNIQUE.TIME
    LEN.UNIQUE.TIME = LEN(UNIQUE.TIME) -6
    Y.UNIQUE.ID = UNIQUE.TIME[LEN.UNIQUE.TIME,6]

RETURN          ;*from GET.UNIQUE.ID
