* @ValidationCode : MjotMTM4NzA1NTI1MjpDcDEyNTI6MTY4MTE5MDQ0NjcxMzpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 10:50:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.DD.AUTH.UPD.NCF
****************************************************************
*-------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : GANESH R
* Program Name : REDO.V.DD.AUTH.UPD.NCF
* ODR NUMBER : ODR-2009-10-0321
*-------------------------------------------------------------------------
* Description : This Auth routine is triggered when DD transaction is Authorised
* In parameter : None
* out parameter : None
*--------------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*11-04-2023       Conversion Tool        R22 Auto Code conversion          VM TO @VM, VAR.SEQ.NO+1 TO +=1
*11-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DD.DDI
    $INSERT I_F.DD.TXN.CODES
    $INSERT I_F.TRANSACTION
    $INSERT I_F.REDO.L.NCF.STOCK
    $INSERT I_F.REDO.L.NCF.STATUS
    $INSERT I_F.REDO.L.NCF.UNMAPPED
    $INSERT I_F.REDO.NCF.ISSUED

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*----------------------------------------------------------------------------------
*******
INIT:
******
*Initialisation

    PROCESS.GOAHEAD = 1
    STOCK.ID='SYSTEM'
    VAR.TXN.ID=''
    LRF.APP='DD.DDI'
    LRF.FIELD='L.NCF.REQUIRED'
    LRF.POS=''
RETURN
***********
OPEN.FILES:
***********
*Opening Files
    FN.REDO.L.NCF.STOCK='F.REDO.L.NCF.STOCK'
    F.REDO.L.NCF.STOCK =''
    CALL OPF(FN.REDO.L.NCF.STOCK,F.REDO.L.NCF.STOCK)

    FN.REDO.L.NCF.UNMAPPED='F.REDO.L.NCF.UNMAPPED'
    F.REDO.L.NCF.UNMAPPED=''
    CALL OPF(FN.REDO.L.NCF.UNMAPPED,F.REDO.L.NCF.UNMAPPED)

    FN.REDO.NCF.ISSUED='F.REDO.NCF.ISSUED'
    F.REDO.NCF.ISSUED=''
    CALL OPF(FN.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED)

    FN.REDO.L.NCF.STATUS='F.REDO.L.NCF.STATUS'
    F.REDO.L.NCF.STATUS=''
    CALL OPF(FN.REDO.L.NCF.STATUS,F.REDO.L.NCF.STATUS)

    FN.DD.TXN.CODES='F.DD.TXN.CODES'
    F.DD.TXN.CODES=''
    CALL OPF(FN.DD.TXN.CODES,F.DD.TXN.CODES)

RETURN
********
PROCESS:
********
*Checking for the values in the fields and Updating the Local Field
*Getting the local Field position
    CALL GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)
    POS.FT.NCF.REQ=LRF.POS<1,1>
    VAR.STATUS=R.NEW(DD.DDI.STATUS)
    VAR.DD.TXN.CODES.ID='SYSTEM'
* CALL F.READ(FN.REDO.L.NCF.STOCK,STOCK.ID,R.REDO.L.NCF.STOCK,F.REDO.L.NCF.STOCK,STOCK.ERR) ;*Tus Start
    CALL CACHE.READ(FN.REDO.L.NCF.STOCK,STOCK.ID,R.REDO.L.NCF.STOCK,STOCK.ERR) ; * Tus End
    FROM.MAIL=R.REDO.L.NCF.STOCK<ST.L.FROM.EMAIL.ID>
    TO.MAIL=R.REDO.L.NCF.STOCK<ST.L.TO.EMAIL.ID>
    SUBJ.MAIL=R.REDO.L.NCF.STOCK<ST.L.SUBJECT.MAIL>
    MSG.MAIL=R.REDO.L.NCF.STOCK<ST.L.MESSAGE.MAIL>
    IF VAR.STATUS EQ 'NEW.ITEM' THEN
        GOSUB DD.SUB1
    END
    IF VAR.STATUS EQ 'RETURNED.ITEM' THEN
        GOSUB DD.SUB2
    END
    IF VAR.STATUS EQ 'RESUBMIT.ITEM' THEN
        GOSUB DD.SUB3
    END
    IF VAR.STATUS EQ 'CLAIM.ITEM' THEN
        GOSUB DD.SUB4
    END
    IF VAR.STATUS EQ 'REJECT.ITEM' THEN
        GOSUB DD.SUB5
    END
    CALL F.READ(FN.TRANSACTION,VAR.TXN.ID,R.TRANSACTION,F.TRANSACTION,TXN.MSG)
    VAR.CHG.KEY=R.TRANSACTION<AC.TRA.CHARGE.KEY>
    IF VAR.CHG.KEY NE '' THEN
        GOSUB DD.SUB.PROCESS
    END
    QTY.AVAIL=R.REDO.L.NCF.STOCK<ST.QTY.AVAIL.ORG>
    MIN.NCF=R.REDO.L.NCF.STOCK<ST.L.MIN.NCF.ORG>
    IF QTY.AVAIL LT MIN.NCF THEN
        GOSUB MAIL.ALERT
    END
RETURN
**************
DD.SUB.PROCESS:
***************
*Getting the Charge Amount and Tax Amount
    CHARGE.AMT=''

RETURN

*******
DD.SUB1:
*******
*Getting the Transaction Code
* CALL F.READ(FN.DD.TXN.CODES,VAR.DD.TXN.CODES.ID,R.DD.TXN.CODES,F.DD.TXN.CODES,TXN.MSG) ;*Tus Start
    CALL CACHE.READ(FN.DD.TXN.CODES,VAR.DD.TXN.CODES.ID,R.DD.TXN.CODES,TXN.MSG) ; * Tus End
    VAR.TXN.ID=R.DD.TXN.CODES<DD.TC.NEW.ITEM.DR>
RETURN
*******
DD.SUB2:
*******
*Getting the Transaction Code
* CALL F.READ(FN.DD.TXN.CODES,VAR.DD.TXN.CODES.ID,R.DD.TXN.CODES,F.DD.TXN.CODES,TXN.MSG) ;*Tus Start
    CALL CACHE.READ(FN.DD.TXN.CODES,VAR.DD.TXN.CODES.ID,R.DD.TXN.CODES,TXN.MSG) ; * Tus End
    VAR.TXN.ID=R.DD.TXN.CODES<DD.TC.RETURN.ITEM.DR>
RETURN
*******
DD.SUB3:
*******
*Getting the Transaction Code
* CALL F.READ(FN.DD.TXN.CODES,VAR.DD.TXN.CODES.ID,R.DD.TXN.CODES,F.DD.TXN.CODES,TXN.MSG) ;*Tus Start
    CALL CACHE.READ(FN.DD.TXN.CODES,VAR.DD.TXN.CODES.ID,R.DD.TXN.CODES,TXN.MSG) ; * Tus End
    VAR.TXN.ID=R.DD.TXN.CODES<DD.TC.RESUBMIT.ITEM.DR>
RETURN
*******
DD.SUB4:
*******
*Getting the Transaction Code
* CALL F.READ(FN.DD.TXN.CODES,VAR.DD.TXN.CODES.ID,R.DD.TXN.CODES,F.DD.TXN.CODES,TXN.MSG) ;*Tus Start
    CALL CACHE.READ(FN.DD.TXN.CODES,VAR.DD.TXN.CODES.ID,R.DD.TXN.CODES,TXN.MSG) ; * Tus End
    VAR.TXN.ID=R.DD.TXN.CODES<DD.TC.CLAIM.ITEM.DR>
RETURN

*******
DD.SUB5:
*******
*Getting the Transaction Code
* CALL F.READ(FN.DD.TXN.CODES,VAR.DD.TXN.CODES.ID,R.DD.TXN.CODES,F.DD.TXN.CODES,TXN.MSG) ;*Tus Start
    CALL CACHE.READ(FN.DD.TXN.CODES,VAR.DD.TXN.CODES.ID,R.DD.TXN.CODES,TXN.MSG) ; * Tus End
    VAR.TXN.ID=R.DD.TXN.CODES<DD.TC.REJECT.ITEM.DR>
RETURN

*********
DD.PROCESS:
*********
*Checking for the Local Field
    VAR.NCF.REQ=R.NEW(DD.DDI.LOCAL.REF)<1,POS.FT.NCF.REQ>
    VAR.TXN.DATE=R.NEW(DD.DDI.DATE.TIME)
    VAR.DATE=20:VAR.TXN.DATE[1,6]
    CHARGE.AMOUNT=CHARGE.AMT
    VAR.CUS=R.NEW(DD.DDI.CUSTOMER.NO)
    TXN.ID=ID.NEW
    VAR.TAX.AMT=''
    IF CHARGE.AMOUNT NE '' THEN
        GOSUB PROCESS1
    END
    ELSE
        GOSUB UPDATE.TABLE2
    END
RETURN
*********
PROCESS1:
*********
    VAR.SERIES=R.REDO.L.NCF.STOCK<ST.SERIES>
    VAR.BUS.DIV=R.REDO.L.NCF.STOCK<ST.BUSINESS.DIV>
    VAR.PECF=R.REDO.L.NCF.STOCK<ST.PECF>
    VAR.AICF=R.REDO.L.NCF.STOCK<ST.AICF>
    VAR.TCF=R.REDO.L.NCF.STOCK<ST.TCF>
    VAR.SEQ.NO=R.REDO.L.NCF.STOCK<ST.SEQUENCE.NO>

    IF R.REDO.L.NCF.STOCK<ST.QTY.AVAIL.ORG> GT 0 THEN
        L.NCF.NUMBER=VAR.SERIES:VAR.BUS.DIV:VAR.PECF:VAR.AICF:VAR.TCF:VAR.SEQ.NO
        VAR.PREV.RANGE=R.REDO.L.NCF.STOCK<ST.PRE.ED.RG.OR>
        VAR.PREV.RANGE=VAR.PREV.RANGE<1,DCOUNT(VAR.PREV.RANGE,@VM)>
        IF VAR.SEQ.NO EQ VAR.PREV.RANGE THEN
            VAR.STRT.RG=R.REDO.L.NCF.STOCK<ST.L.STRT.RNGE.ORG>
            VAR.SEQ.NO=VAR.STRT.RG
        END
        ELSE
            VAR.SEQ.NO += 1   ;*R22 AUTO CODE CONVERSION
        END
        VAR.QTY.AVAIL=R.REDO.L.NCF.STOCK<ST.QTY.AVAIL.ORG>
        VAR.NCF.ISSUE=R.REDO.L.NCF.STOCK<ST.NCF.ISSUED.ORG>
        VAR.MIN.NCF=R.REDO.L.NCF.STOCK<ST.L.MIN.NCF.ORG>
        VAR.NCF.STATUS=R.REDO.L.NCF.STOCK<ST.NCF.STATUS.ORG>
        VAR.NCF.ISSUE += 1   ;*R22 AUTO CODE CONVERSION
        VAR.QTY.AVAIL -= 1   ;*R22 AUTO CODE CONVERSION
        IF VAR.QTY.AVAIL GE VAR.MIN.NCF THEN
            R.REDO.L.NCF.STOCK<ST.NCF.STATUS.ORG>='AVAILABLE'
        END
        ELSE
            R.REDO.L.NCF.STOCK<ST.NCF.STATUS.ORG>='UNAVAILABLE'
        END
        R.REDO.L.NCF.STOCK<ST.SEQUENCE.NO>=FMT(VAR.SEQ.NO,'8"0"R')
        R.REDO.L.NCF.STOCK<ST.QTY.AVAIL.ORG>=VAR.QTY.AVAIL
        R.REDO.L.NCF.STOCK<ST.NCF.ISSUED.ORG>=VAR.NCF.ISSUE
        CALL F.WRITE(FN.REDO.L.NCF.STOCK,STOCK.ID,R.REDO.L.NCF.STOCK)
        GOSUB UPDATE.TABLE1
    END
    ELSE
        GOSUB UPDATE.TABLE2
    END
RETURN
**************
UPDATE.TABLE1:
**************
*Updating ISSUED and Status Table
    NCF.ISSUE.ID=VAR.CUS:VAR.DATE:TXN.ID
    CALL F.READ(FN.REDO.NCF.ISSUED,NCF.ISSUE.ID,R.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED,ISSUE.MSG)
    R.REDO.NCF.ISSUED<ST.IS.TXN.ID>=TXN.ID
    R.REDO.NCF.ISSUED<ST.IS.CHARGE.AMOUNT>=CHARGE.AMOUNT
    R.REDO.NCF.ISSUED<ST.IS.TAX.AMOUNT>=VAR.TAX.AMT
    R.REDO.NCF.ISSUED<ST.IS.DATE> = VAR.DATE
    R.REDO.NCF.ISSUED<ST.IS.CUSTOMER>=VAR.CUS
    R.REDO.NCF.ISSUED<ST.IS.NCF> = L.NCF.NUMBER
    CALL F.WRITE(FN.REDO.NCF.ISSUED,NCF.ISSUE.ID,R.REDO.NCF.ISSUED)
    CALL F.READ(FN.REDO.L.NCF.STATUS,NCF.ISSUE.ID,R.REDO.L.NCF.STATUS,F.REDO.L.NCF.STATUS,STATUS.MSG)
    R.REDO.L.NCF.STATUS<NCF.ST.TRANSACTION.ID>=ID.NEW
    R.REDO.L.NCF.STATUS<NCF.ST.CUSTOMER.ID>=VAR.CUS
    R.REDO.L.NCF.STATUS<NCF.ST.DATE>= VAR.DATE
    R.REDO.L.NCF.STATUS<NCF.ST.CHARGE.AMOUNT>=CHARGE.AMOUNT
    R.REDO.L.NCF.STATUS<NCF.ST.TAX.AMOUNT>=VAR.TAX.AMT
    R.REDO.L.NCF.STATUS<NCF.ST.NCF>=L.NCF.NUMBER
    R.REDO.L.NCF.STATUS<NCF.ST.STATUS>='AVAILABLE'
    CALL F.WRITE(FN.REDO.L.NCF.STATUS,NCF.ISSUE.ID,R.REDO.L.NCF.STATUS)
RETURN
**************
UPDATE.TABLE2:
**************
*Updating UNMAPPED and Status Table
    NCF.ISSUE.ID=VAR.CUS:VAR.DATE:TXN.ID
    CALL F.READ(FN.REDO.L.NCF.UNMAPPED,NCF.ISSUE.ID,R.REDO.L.NCF.UNMAPPED,F.REDO.L.NCF.UNMAPPED,UNMAP.ERR)
    R.REDO.L.NCF.UNMAPPED<ST.UN.TXN.ID>=ID.NEW
    R.REDO.L.NCF.UNMAPPED<ST.UN.CHARGE.AMOUNT>=CHARGE.AMOUNT
    R.REDO.L.NCF.UNMAPPED<ST.UN.TAX.AMOUNT>=VAR.TAX.AMT
    R.REDO.L.NCF.UNMAPPED<ST.UN.CUSTOMER>=VAR.CUS
    R.REDO.L.NCF.UNMAPPED<ST.UN.DATE>=VAR.DATE
    R.REDO.L.NCF.UNMAPPED<ST.UN.BATCH>='NO'
    CALL F.WRITE(FN.REDO.L.NCF.UNMAPPED,NCF.ISSUE.ID,R.REDO.L.NCF.UNMAPPED)
    CALL F.READ(FN.REDO.L.NCF.STATUS,NCF.ISSUE.ID,R.REDO.L.NCF.STATUS,F.REDO.L.NCF.STATUS,STATUS.MSG)
    R.REDO.L.NCF.STATUS<NCF.ST.TRANSACTION.ID>=ID.NEW
    R.REDO.L.NCF.STATUS<NCF.ST.CUSTOMER.ID>=VAR.CUS
    R.REDO.L.NCF.STATUS<NCF.ST.DATE>=VAR.DATE
    R.REDO.L.NCF.STATUS<NCF.ST.CHARGE.AMOUNT>=CHARGE.AMOUNT
    R.REDO.L.NCF.STATUS<NCF.ST.TAX.AMOUNT>=VAR.TAX.AMT
    R.REDO.L.NCF.STATUS<NCF.ST.NCF>=''
    CALL F.WRITE(FN.REDO.L.NCF.STATUS,NCF.ISSUE.ID,R.REDO.L.NCF.STATUS)
    R.REDO.L.NCF.STATUS<NCF.ST.STATUS>='UNAVAILABLE'
    CALL F.WRITE(FN.REDO.L.NCF.STATUS,NCF.ISSUE.ID,R.REDO.L.NCF.STATUS)
RETURN
**********
MAIL.ALERT:
**********
*Sending Mail Alert
    CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
    VAR.UNIQUE.ID=UNIQUE.TIME
    FILENAME='APAP':VAR.UNIQUE.ID:'.TXT'
    FN.HRMS.FILE='MAIL.BP'
    F.HRMA.FILE=''
    CALL OPF(FN.HRMS.FILE ,F.HRMA.FILE)
    REC=FROM.MAIL:"#":TO.MAIL:"#":SUBJ.MAIL:"#":MSG.MAIL
    WRITE REC TO F.HRMA.FILE,FILENAME
RETURN

*-------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*-------------------------------------------------------------------
    VAL.STATUS=R.NEW(DD.DDI.RECORD.STATUS)

    IF VAL.STATUS[1,1] EQ 'R' THEN
        PROCESS.GOAHEAD = ""
    END

RETURN
END
