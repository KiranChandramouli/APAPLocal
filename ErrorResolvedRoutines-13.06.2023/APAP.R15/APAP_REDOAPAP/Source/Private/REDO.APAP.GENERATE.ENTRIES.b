* @ValidationCode : MjotMTQ4MDkzNzg1MDpDcDEyNTI6MTY4NDgzNjA0MDY2NjpJVFNTOi0xOi0xOjEwMzU6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1035
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.GENERATE.ENTRIES(MULTI.STMT)

*-----------------------------------------------------------------------------
* Description:
* This routine is a call routine to generate Entries
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : ganesh r
* PROGRAM NAME : REDO.B.INW.PROCESS
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 21.09.2010  ganesh r            ODR-2010-09-0148  INITIAL CREATION
* 16.11.2011  KAVITHA             PACS00163293       PACS00163293 FIX
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.USER
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_REDO.B.INW.PROCESS.COMMON

*Check for Raising Paid Stmt Entries



    MULTI.STMT = ''
    REFER.REASON = ''
    RETURN.REASON = ''

    IF RETURN.FLAG EQ '' THEN
        IF VAR.REC.STATUS THEN
            GOSUB ACCT.ENTRIES1
            GOSUB ACCT.ENTRIES2
        END

*PACS00163293-S
        LOCATE '21' IN VAR.REASON<1,1> SETTING REF.POS THEN
            REFER.REASON = 1
        END

*PACS00163293-E

        LOCATE '20' IN VAR.REASON<1,1> SETTING REF.POS THEN
            RETURN
        END

        LOCATE '19' IN VAR.REASON<1,1> SETTING RET.POS THEN
            RETURN.REASON = 1
        END

        IF REFER.FLAG EQ 1 AND REFER.REASON EQ 1 THEN
            GOSUB REF.ACC.ENTRIES1
        END

        IF REFER.FLAG EQ 1 AND REFER.REASON EQ '' THEN
            GOSUB REF.ENTRIES1
            GOSUB REF.ENTRIES2
        END
    END
    IF RETURN.FLAG EQ 1 AND RETURN.REASON EQ 1 THEN
        GOSUB RET.ENTRIES1
        GOSUB RET.ENTRIES2
    END
    IF RETURN.FLAG EQ 1 AND RETURN.REASON EQ '' THEN
        GOSUB RET.ACC.ENTRIES
    END

    CALL EB.ACCOUNTING("AC","SAO",MULTI.STMT,'')

RETURN

ACCT.ENTRIES1:
*Paid Stmt Entries

    IF VAL.AMT THEN
        R.STMT.ARR = ''
        R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAL.ACCT
        R.STMT.ARR<AC.STE.CURRENCY> = VAR.CURRENCY
        IF VAR.CURRENCY NE LCCY THEN
            R.STMT.ARR<AC.STE.AMOUNT.FCY> = -1 * VAL.AMT
        END
        ELSE
            R.STMT.ARR<AC.STE.AMOUNT.LCY> = -1 * VAL.AMT
        END
        R.STMT.ARR<AC.STE.CRF.TYPE> = "DEBIT"
        R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.INWARD.DR.CODE
        GOSUB BASIC.ACC.ENTRY
        MULTI.STMT<-1> = LOWER(R.STMT.ARR)
    END

    IF VAL.NOR.TAX THEN
        Y.CCY.ACC.NO   = VAL.ACCT[1,3]

        IF NUM(Y.CCY.ACC.NO) THEN
            R.STMT.ARR = ''

            R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAL.ACCT
            R.STMT.ARR<AC.STE.CURRENCY> = VAR.CURRENCY
            IF VAR.CURRENCY NE LCCY THEN
                R.STMT.ARR<AC.STE.AMOUNT.FCY> = - 1 * VAL.NOR.TAX
            END
            ELSE
                R.STMT.ARR<AC.STE.AMOUNT.LCY> = - 1 * VAL.NOR.TAX
            END
            R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.TAX.DR.CODE

            R.STMT.ARR<AC.STE.CRF.TYPE> = "DEBIT"
            GOSUB BASIC.ACC.ENTRY
            MULTI.STMT<-1> = LOWER(R.STMT.ARR)
        END
    END

RETURN

ACCT.ENTRIES2:
*Paid Stmt Entries

    IF VAL.AMT THEN
        R.STMT.ARR = ''
*R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.INW.SETTLE.CATEG
        R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.CAT.ACH.ACCT    ;* Changed to ACH Mirror Account
        R.STMT.ARR<AC.STE.AMOUNT.LCY> = VAL.AMT
*R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.INWARD.CR.CODE
        R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.CAT.ACH.CR.CODE
        R.STMT.ARR<AC.STE.CRF.TYPE> = "CREDIT"
        R.STMT.ARR<AC.STE.CURRENCY> = 'DOP'
        GOSUB BASIC.ACC.ENTRY
        MULTI.STMT<-1> = LOWER(R.STMT.ARR)
    END

    IF VAL.NOR.TAX THEN
        Y.CCY.ACC.NO   = VAL.ACCT[1,3]
        IF NUM(Y.CCY.ACC.NO) THEN
            R.STMT.ARR = ''
            R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.INW.TAX.CATEG
            R.STMT.ARR<AC.STE.AMOUNT.LCY> = VAL.NOR.TAX
            R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.TAX.CR.CODE
            R.STMT.ARR<AC.STE.CRF.TYPE> = "CREDIT"
            R.STMT.ARR<AC.STE.CURRENCY> = 'DOP'
            GOSUB BASIC.ACC.ENTRY
            MULTI.STMT<-1> = LOWER(R.STMT.ARR)
        END
    END

RETURN

REF.ACC.ENTRIES1:
*Refer Stmt Entries

    IF VAL.AMT THEN
        R.STMT.ARR = ''
        R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.INW.REF.CATEG
        R.STMT.ARR<AC.STE.AMOUNT.LCY> = -1 * VAL.AMT
        R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.INWARD.DR.CODE
        R.STMT.ARR<AC.STE.CRF.TYPE> = "DEBIT"
        R.STMT.ARR<AC.STE.CURRENCY> = 'DOP'
        GOSUB BASIC.ACC.ENTRY
        MULTI.STMT<-1> = LOWER(R.STMT.ARR)

        R.STMT.ARR = ''
        R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.INW.SETTLE.CATEG
        R.STMT.ARR<AC.STE.AMOUNT.LCY> = VAL.AMT
        R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.INWARD.CR.CODE
        R.STMT.ARR<AC.STE.CRF.TYPE> = "CREDIT"
        R.STMT.ARR<AC.STE.CURRENCY> = 'DOP'
        GOSUB BASIC.ACC.ENTRY
        MULTI.STMT<-1> = LOWER(R.STMT.ARR)
    END
RETURN

REF.ENTRIES1:
*Refer Stmt Entries

    IF VAL.AMT THEN
        R.STMT.ARR = ''
        R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAL.ACCT
        R.STMT.ARR<AC.STE.CURRENCY> = VAR.CURRENCY
        IF VAR.CURRENCY NE LCCY THEN
            R.STMT.ARR<AC.STE.AMOUNT.FCY> = -1 * VAL.AMT
        END
        ELSE
            R.STMT.ARR<AC.STE.AMOUNT.LCY> = -1 * VAL.AMT
        END
        R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.INWARD.DR.CODE
        R.STMT.ARR<AC.STE.CRF.TYPE> = "DEBIT"
        GOSUB BASIC.ACC.ENTRY
        MULTI.STMT<-1> = LOWER(R.STMT.ARR)
    END

    IF VAL.NOR.TAX THEN
        Y.CCY.ACC.NO   = VAL.ACCT[1,3]
        IF NUM(Y.CCY.ACC.NO) THEN
            R.STMT.ARR = ''
            R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAL.ACCT
            R.STMT.ARR<AC.STE.CURRENCY> = VAR.CURRENCY
            IF VAR.CURRENCY NE LCCY THEN
                R.STMT.ARR<AC.STE.AMOUNT.FCY> = -1 * VAL.NOR.TAX
            END
            ELSE
                R.STMT.ARR<AC.STE.AMOUNT.LCY> = -1 * VAL.NOR.TAX
            END
            R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.TAX.DR.CODE
            R.STMT.ARR<AC.STE.CRF.TYPE> = "DEBIT"
            GOSUB BASIC.ACC.ENTRY
            MULTI.STMT<-1> = LOWER(R.STMT.ARR)
        END
    END

    IF VAR.TOT.CHG.AMT THEN
        Y.CCY.ACC.NO   = VAL.ACCT[1,3]
        IF NUM(Y.CCY.ACC.NO) THEN
            R.STMT.ARR = ''
            R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAL.ACCT
            R.STMT.ARR<AC.STE.CURRENCY> = VAR.CURRENCY
            IF VAR.CURRENCY NE LCCY THEN
                R.STMT.ARR<AC.STE.AMOUNT.FCY> = -1 * VAR.TOT.CHG.AMT
            END
            ELSE
                R.STMT.ARR<AC.STE.AMOUNT.LCY> = -1 * VAR.TOT.CHG.AMT
            END
            R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.COMM.DR.CODE
            R.STMT.ARR<AC.STE.CRF.TYPE> = "DEBIT"
            GOSUB BASIC.ACC.ENTRY
            MULTI.STMT<-1> = LOWER(R.STMT.ARR)
        END
    END

    IF VAL.AMT THEN
        R.STMT.ARR = ''
*R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.INW.SETTLE.CATEG
        R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.CAT.ACH.ACCT    ;* ACH mirror account
        R.STMT.ARR<AC.STE.AMOUNT.LCY> = VAL.AMT
        R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.CAT.ACH.CR.CODE
        R.STMT.ARR<AC.STE.CRF.TYPE> = "CREDIT"
        R.STMT.ARR<AC.STE.CURRENCY> = 'DOP'
        GOSUB BASIC.ACC.ENTRY
        MULTI.STMT<-1> = LOWER(R.STMT.ARR)
    END

RETURN

REF.ENTRIES2:
*Refer Stmt Entries

    IF VAL.NOR.TAX THEN
        Y.CCY.ACC.NO   = VAL.ACCT[1,3]
        IF NUM(Y.CCY.ACC.NO) THEN
            R.STMT.ARR = ''
            R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.INW.TAX.CATEG
            R.STMT.ARR<AC.STE.AMOUNT.LCY> = VAL.NOR.TAX
            R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.TAX.CR.CODE
            R.STMT.ARR<AC.STE.CRF.TYPE> = "CREDIT"
            R.STMT.ARR<AC.STE.CURRENCY> = 'DOP'
            GOSUB BASIC.ACC.ENTRY
            MULTI.STMT<-1> = LOWER(R.STMT.ARR)
        END
    END

*PACS00163293-S
    IF VAR.TOT.CHG.AMT THEN
        Y.CCY.ACC.NO   = VAL.ACCT[1,3]
        IF NUM(Y.CCY.ACC.NO) THEN
            R.CATEG.ENT = ''
            R.CATEG.ENT<AC.CAT.ACCOUNT.NUMBER> = ''
            R.CATEG.ENT<AC.CAT.COMPANY.CODE> = ID.COMPANY
            R.CATEG.ENT<AC.CAT.AMOUNT.LCY> = VAR.TOT.CHG.AMT
            R.CATEG.ENT<AC.CAT.TRANSACTION.CODE> = VAR.COMM.CR.CODE
            R.CATEG.ENT<AC.CAT.CUSTOMER.ID>= VAR.CUSTOMER
            R.CATEG.ENT<AC.CAT.DEPARTMENT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
            R.CATEG.ENT<AC.CAT.PL.CATEGORY> = VAR.INW.CLEAR.CATEG
            R.CATEG.ENT<AC.CAT.PRODUCT.CATEGORY> = VAR.PRD.CATEG
            R.CATEG.ENT<AC.CAT.VALUE.DATE>= TODAY
            R.CATEG.ENT<AC.CAT.CURRENCY> = 'DOP'
            R.CATEG.ENT<AC.CAT.EXCHANGE.RATE> =''
            R.CATEG.ENT<AC.CAT.CURRENCY.MARKET> = "1"
            R.CATEG.ENT<AC.CAT.TRANS.REFERENCE> = REDO.ACCT.ID
            R.CATEG.ENT<AC.CAT.SYSTEM.ID> = "AC"
            R.CATEG.ENT<AC.CAT.BOOKING.DATE> = TODAY
            R.CATEG.ENT<AC.CAT.NARRATIVE> = ''
            R.CATEG.ENT<AC.CAT.LOCAL.REF,L.EB.IMAGE.POS,1> = VAL.IMG.ID
            R.CATEG.ENT<AC.CAT.CRF.TYPE> = "CREDIT"

            MULTI.STMT<-1> = LOWER(R.CATEG.ENT)
        END

    END
*PACS00163293-E

    IF VAL.AMT THEN
        R.STMT.ARR = ''
        R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.INW.REF.CATEG
        R.STMT.ARR<AC.STE.AMOUNT.LCY> = -1 * VAL.AMT
        R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.INWARD.DR.CODE
        R.STMT.ARR<AC.STE.CRF.TYPE> = "DEBIT"
        R.STMT.ARR<AC.STE.CURRENCY> = 'DOP'
        GOSUB BASIC.ACC.ENTRY
        MULTI.STMT<-1> = LOWER(R.STMT.ARR)
    END

    IF VAL.NOR.TAX THEN
        Y.CCY.ACC.NO   = VAL.ACCT[1,3]
        IF NUM(Y.CCY.ACC.NO) THEN
            R.STMT.ARR = ''
            R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.INW.TAX.CATEG
            R.STMT.ARR<AC.STE.AMOUNT.LCY> = -1 * VAL.NOR.TAX
            R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.TAX.DR.CODE
            R.STMT.ARR<AC.STE.CRF.TYPE> = "DEBIT"
            R.STMT.ARR<AC.STE.CURRENCY> = 'DOP'
            GOSUB BASIC.ACC.ENTRY
            MULTI.STMT<-1> = LOWER(R.STMT.ARR)

            R.STMT.ARR = ''
            R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAL.ACCT
            R.STMT.ARR<AC.STE.CURRENCY> = VAR.CURRENCY
            IF VAR.CURRENCY NE LCCY THEN
                R.STMT.ARR<AC.STE.AMOUNT.FCY> = VAL.NOR.TAX
            END ELSE
                R.STMT.ARR<AC.STE.AMOUNT.LCY> = VAL.NOR.TAX
            END

            R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.TAX.CR.CODE
            R.STMT.ARR<AC.STE.CRF.TYPE> = "CREDIT"
            GOSUB BASIC.ACC.ENTRY
            MULTI.STMT<-1> = LOWER(R.STMT.ARR)
        END
    END

    IF VAL.AMT THEN
        R.STMT.ARR = ''
        R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAL.ACCT
        R.STMT.ARR<AC.STE.CURRENCY> = VAR.CURRENCY
        IF VAR.CURRENCY NE LCCY THEN
            R.STMT.ARR<AC.STE.AMOUNT.FCY> = VAL.AMT
        END ELSE
            R.STMT.ARR<AC.STE.AMOUNT.LCY> = VAL.AMT
        END
        R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.INWARD.CR.CODE
        R.STMT.ARR<AC.STE.CRF.TYPE> = "CREDIT"
        GOSUB BASIC.ACC.ENTRY
        MULTI.STMT<-1> = LOWER(R.STMT.ARR)
    END

RETURN

RET.ENTRIES1:
*Refer Stmt Entries

    IF VAL.AMT THEN
        R.STMT.ARR = ''
        R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAL.ACCT
        R.STMT.ARR<AC.STE.CURRENCY> = VAR.CURRENCY
        IF VAR.CURRENCY NE LCCY THEN
            R.STMT.ARR<AC.STE.AMOUNT.FCY> = -1 * VAL.AMT
        END
        ELSE
            R.STMT.ARR<AC.STE.AMOUNT.LCY> = -1 * VAL.AMT
        END
        R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.INWARD.DR.CODE
        R.STMT.ARR<AC.STE.CRF.TYPE> = "DEBIT"
        GOSUB BASIC.ACC.ENTRY
        MULTI.STMT<-1> = LOWER(R.STMT.ARR)
    END

    IF VAL.NOR.TAX THEN
        Y.CCY.ACC.NO   = VAL.ACCT[1,3]
        IF NUM(Y.CCY.ACC.NO) THEN
            R.STMT.ARR = ''
            R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAL.ACCT
            R.STMT.ARR<AC.STE.CURRENCY> = VAR.CURRENCY
            IF VAR.CURRENCY NE LCCY THEN
                R.STMT.ARR<AC.STE.AMOUNT.FCY> = -1 * VAL.NOR.TAX
            END
            ELSE
                R.STMT.ARR<AC.STE.AMOUNT.LCY> = -1 * VAL.NOR.TAX
            END
            R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.TAX.DR.CODE
            R.STMT.ARR<AC.STE.CRF.TYPE> = "DEBIT"
            GOSUB BASIC.ACC.ENTRY
            MULTI.STMT<-1> = LOWER(R.STMT.ARR)
        END
    END

    IF VAL.AMT THEN
        R.STMT.ARR = ''
        R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.INW.SETTLE.CATEG
        R.STMT.ARR<AC.STE.AMOUNT.LCY> = VAL.AMT
        R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.INWARD.CR.CODE
        R.STMT.ARR<AC.STE.CRF.TYPE> = "CREDIT"
        R.STMT.ARR<AC.STE.CURRENCY> = 'DOP'
        GOSUB BASIC.ACC.ENTRY
        MULTI.STMT<-1> = LOWER(R.STMT.ARR)
    END


    IF VAL.NOR.TAX THEN
        Y.CCY.ACC.NO   = VAL.ACCT[1,3]
        IF NUM(Y.CCY.ACC.NO) THEN
            R.STMT.ARR = ''
            R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.INW.TAX.CATEG
            R.STMT.ARR<AC.STE.AMOUNT.LCY> = VAL.NOR.TAX
            R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.TAX.CR.CODE
            R.STMT.ARR<AC.STE.CRF.TYPE> = "CREDIT"
            R.STMT.ARR<AC.STE.CURRENCY> = 'DOP'
            GOSUB BASIC.ACC.ENTRY
            MULTI.STMT<-1> = LOWER(R.STMT.ARR)
        END
    END

RETURN

RET.ENTRIES2:
*Return Entries
    IF VAL.NOR.TAX THEN
        Y.CCY.ACC.NO   = VAL.ACCT[1,3]
        IF NUM(Y.CCY.ACC.NO) THEN
            R.STMT.ARR = ''
            R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.INW.TAX.CATEG
            R.STMT.ARR<AC.STE.AMOUNT.LCY> = -1 * VAL.NOR.TAX
            R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.TAX.DR.CODE
            R.STMT.ARR<AC.STE.CRF.TYPE> = "DEBIT"
            R.STMT.ARR<AC.STE.CURRENCY> = 'DOP'
            GOSUB BASIC.ACC.ENTRY
            MULTI.STMT<-1> = LOWER(R.STMT.ARR)
        END
    END

    IF VAL.AMT THEN
        R.STMT.ARR = ''
        R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.INW.RETURN.CATEG
        R.STMT.ARR<AC.STE.AMOUNT.LCY> = -1 * VAL.AMT
        R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.INWARD.DR.CODE
        R.STMT.ARR<AC.STE.CRF.TYPE> = "DEBIT"
        R.STMT.ARR<AC.STE.CURRENCY> = 'DOP'
        GOSUB BASIC.ACC.ENTRY
        MULTI.STMT<-1> = LOWER(R.STMT.ARR)


        R.STMT.ARR = ''
        R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAL.ACCT
        R.STMT.ARR<AC.STE.CURRENCY> = VAR.CURRENCY
        IF VAR.CURRENCY NE LCCY THEN
            R.STMT.ARR<AC.STE.AMOUNT.FCY> = VAL.AMT
        END
        ELSE
            R.STMT.ARR<AC.STE.AMOUNT.LCY> = VAL.AMT
        END
        R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.INWARD.DR.CODE
        R.STMT.ARR<AC.STE.CRF.TYPE> = "CREDIT"
        GOSUB BASIC.ACC.ENTRY
        MULTI.STMT<-1> = LOWER(R.STMT.ARR)
    END

    IF VAL.NOR.TAX THEN
        Y.CCY.ACC.NO   = VAL.ACCT[1,3]
        IF NUM(Y.CCY.ACC.NO) THEN
            R.STMT.ARR = ''
            R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAL.ACCT
            R.STMT.ARR<AC.STE.CURRENCY> = VAR.CURRENCY
            IF VAR.CURRENCY NE LCCY THEN
                R.STMT.ARR<AC.STE.AMOUNT.FCY> = VAL.NOR.TAX
            END
            ELSE
                R.STMT.ARR<AC.STE.AMOUNT.LCY> = VAL.NOR.TAX
            END
            R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.TAX.CR.CODE
            R.STMT.ARR<AC.STE.CRF.TYPE> = "CREDIT"
            GOSUB BASIC.ACC.ENTRY
            MULTI.STMT<-1> = LOWER(R.STMT.ARR)
        END
    END

RETURN

RET.ACC.ENTRIES:
*Return Entries

    IF VAL.AMT THEN
        R.STMT.ARR = ''
        R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.INW.RETURN.CATEG
        R.STMT.ARR<AC.STE.AMOUNT.LCY> = -1 * VAL.AMT
        R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.INWARD.DR.CODE
        R.STMT.ARR<AC.STE.CRF.TYPE> = "DEBIT"
        R.STMT.ARR<AC.STE.CURRENCY> = 'DOP'
        GOSUB BASIC.ACC.ENTRY
        MULTI.STMT<-1> = LOWER(R.STMT.ARR)

        R.STMT.ARR = ''
*R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.INW.SETTLE.CATEG
        R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = VAR.CAT.ACH.ACCT
        R.STMT.ARR<AC.STE.AMOUNT.LCY> = VAL.AMT
*R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.INWARD.CR.CODE
        R.STMT.ARR<AC.STE.TRANSACTION.CODE> = VAR.CAT.ACH.CR.CODE
        R.STMT.ARR<AC.STE.CRF.TYPE> = "CREDIT"
        R.STMT.ARR<AC.STE.CURRENCY> = 'DOP'
        GOSUB BASIC.ACC.ENTRY
        MULTI.STMT<-1> = LOWER(R.STMT.ARR)
    END

RETURN

BASIC.ACC.ENTRY:
*Common Call for raising Entries

    R.STMT.ARR<AC.STE.COMPANY.CODE> = ID.COMPANY
    R.STMT.ARR<AC.STE.CUSTOMER.ID> = VAR.CUSTOMER
    R.STMT.ARR<AC.STE.ACCOUNT.OFFICER> = VAR.ACCT.OFF
    R.STMT.ARR<AC.STE.PRODUCT.CATEGORY> = VAR.PRD.CATEG
    R.STMT.ARR<AC.STE.VALUE.DATE> = TODAY
    R.STMT.ARR<AC.STE.POSITION.TYPE> = "TR"
    R.STMT.ARR<AC.STE.OUR.REFERENCE> = REDO.ACCT.ID
    R.STMT.ARR<AC.STE.TRANS.REFERENCE> = REDO.ACCT.ID
    R.STMT.ARR<AC.STE.SYSTEM.ID> = "AC"
    R.STMT.ARR<AC.STE.BOOKING.DATE> = TODAY
    R.STMT.ARR<AC.STE.EXPOSURE.DATE> = TODAY
    R.STMT.ARR<AC.STE.CURRENCY.MARKET> = 1
    R.STMT.ARR<AC.STE.DEPARTMENT.CODE> = 1
    R.STMT.ARR<AC.STE.PROCESSING.DATE> = TODAY
    R.STMT.ARR<AC.STE.ORIG.CCY.MARKET> = 1
    R.STMT.ARR<AC.STE.LOCAL.REF,L.EB.IMAGE.POS,1> = VAL.IMG.ID
RETURN
END
