* @ValidationCode : MjotOTU0NTM4Mjc4OkNwMTI1MjoxNjg2NTczNDMyNTIzOklUU1MxOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Jun 2023 18:07:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
*-----------------------------------------------------------------------------
* <Rating>-244</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.V.FT.AUTH.UPD.NCF
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.V.FT.AUTH.UPD.NCF
* ODR NUMBER    : ODR-2009-10-0321
*-------------------------------------------------------------------------
* Description : This Auth routine is triggered when FT transaction is Authorised
*--------------------------------------------------------------------------
*Modification History:
*----------------------------------------------------------------------------
* DATE            WHO               REFERENCE        DESCRIPTION
* 05-05-2011    Sudharsanan S       PACS00055359     Update exact local field name - L.NCF.NUMBER
* 15-05-2013    Vignesh Kumaar R    PACS00275478     NCF Mail changes related to INTERFACE.CONFIG.PRT param mail path
* 25-09-2015    Vignesh Kumaar R    PACS00469724     NCF not produced for the IVR transactions
* 12-Jun-2023  Santosh      Manual R22 conversion    New argument added in F.READU - RETRY
*---------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TAX
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.USER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.REDO.L.NCF.STOCK
    $INSERT I_F.REDO.L.NCF.STATUS
    $INSERT I_F.REDO.L.NCF.UNMAPPED
    $INSERT I_F.REDO.NCF.ISSUED
    $INSERT I_F.INTERFACE.CONFIG.PRT ;*PACS00275478

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
    MULTI.STMT = ''
    VAR.TXN.ID=''
    LRF.APP='FUNDS.TRANSFER'
    LRF.FIELD='L.NCF.REQUIRED':@VM:'TRANSACTION.REF':@VM:'L.NCF.NUMBER':@VM:'L.FT.TAX.TYPE':@VM:'L.NCF.TAX.NUM':@VM:'WAIVE.TAX':@VM:'L.TT.COMM.CODE':@VM:'L.TT.WV.COMM':@VM:'L.TT.COMM.AMT':@VM:'L.TT.TAX.CODE':@VM:'L.TT.WV.TAX':@VM:'L.TT.TAX.AMT'
    LRF.POS=''
    RETRY = '' ;*Manual R22 conversion
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
    FN.FUNDS.TRANSFER='F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER=''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
    FN.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
    F.COMMISSION.TYPE = ''
    CALL OPF(FN.COMMISSION.TYPE,F.COMMISSION.TYPE)
    FN.TAX = 'F.TAX'
    F.TAX  = ''
    CALL OPF(FN.TAX,F.TAX)
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.AA.NCF.IDS = "F.REDO.AA.NCF.IDS"
    F.REDO.AA.NCF.IDS  = ""
    CALL OPF(FN.REDO.AA.NCF.IDS,F.REDO.AA.NCF.IDS)

RETURN
********
PROCESS:
********
*Checking for the values in the fields and Updating the Local Field
*Getting the local Field position
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)
    POS.FT.NCF.REQ     = LRF.POS<1,1>
    POS.FT.TXN.REF     = LRF.POS<1,2>
    POS.FT.NCF.NO      = LRF.POS<1,3>
    FT.TAX.POS         = LRF.POS<1,4>
    POS.FT.NCF.NO.TAX  = LRF.POS<1,5>
    FT.WAIVE.TAX.POS   = LRF.POS<1,6>

    POS.L.TT.COMM.CODE = LRF.POS<1,7>
    POS.L.TT.WV.COMM   = LRF.POS<1,8>
    POS.L.TT.COMM.AMT  = LRF.POS<1,9>
    POS.L.TT.TAX.CODE  = LRF.POS<1,10>
    POS.L.TT.WV.TAX    = LRF.POS<1,11>
    POS.L.TT.TAX.AMT   = LRF.POS<1,12>

    GOSUB CHECK.PROCESS
RETURN
***************
READ.STK.TABLE:
***************


*   CALL F.READU(FN.REDO.L.NCF.STOCK,STOCK.ID,R.REDO.L.NCF.STOCK,F.REDO.L.NCF.STOCK,ERR)
    CALL F.READU(FN.REDO.L.NCF.STOCK,STOCK.ID,R.REDO.L.NCF.STOCK,F.REDO.L.NCF.STOCK,ERR,RETRY)   ;*Manual R22 conversion - New argument RETRY added

    FROM.MAIL    = R.REDO.L.NCF.STOCK<ST.L.FROM.EMAIL.ID>
    TO.MAIL      = R.REDO.L.NCF.STOCK<ST.L.TO.EMAIL.ID>
    SUBJ.MAIL    = R.REDO.L.NCF.STOCK<ST.L.SUBJECT.MAIL>
    MSG.MAIL     = R.REDO.L.NCF.STOCK<ST.L.MESSAGE.MAIL>
RETURN
*************
CHECK.PROCESS:
*************
*Checking for the Local Field

    GOSUB GET.VALUES

    GOSUB CHECK.TAX.AMT

    IF VAR.NCF.REQ EQ 'YES' AND VAR.CUS NE '' THEN
*Below commented lines are not in use
*        IF VAR.TXN.TYPE EQ 'ACDB' THEN
*            GOSUB READ.STK.TABLE
*            GOSUB DEBIT.PROCESS
*            QTY.AVAIL=R.REDO.L.NCF.STOCK<ST.L.QTY.AVAIL.DR>
*            MIN.NCF=R.REDO.L.NCF.STOCK<ST.MN.NCF.DR.NOTE>
*            IF QTY.AVAIL LT MIN.NCF THEN
*                GOSUB MAIL.ALERT
*            END
*        END
*        IF VAR.TXN.TYPE EQ 'ACCN' THEN
*            GOSUB READ.STK.TABLE
*            GOSUB CREDIT.PROCESS
*            QTY.AVAIL=R.REDO.L.NCF.STOCK<ST.L.QTY.AVAIL.CR>
*            MIN.NCF=R.REDO.L.NCF.STOCK<ST.MN.NCF.CR.NOTE>
*            IF QTY.AVAIL LT MIN.NCF THEN
*                GOSUB MAIL.ALERT
*            END
*        END
        IF VAR.TXN.TYPE NE 'ACCN' AND VAR.TXN.TYPE NE 'ACDB' THEN
            GOSUB FT.PROCESS
        END
    END
    ELSE
        GOSUB UPDATE.TABLE2
    END
RETURN
**********
GET.VALUES:
**********
*PACS00309586 - S
* Sum up the amount which is not waived in comm/ tax instead of summing all the waive comm/ tax amount.
    LOC.WAIVE.COMM = R.NEW(FT.LOCAL.REF)<1,POS.L.TT.WV.COMM>
    LOC.WAIVE.TAX  = R.NEW(FT.LOCAL.REF)<1,POS.L.TT.WV.TAX>
    CHANGE @SM TO @FM IN LOC.WAIVE.COMM
    CHANGE @SM TO @FM IN LOC.WAIVE.TAX
    LOC.WAIVE.COMM.CNT = DCOUNT(LOC.WAIVE.COMM,@FM)
    LOC.WAIVE.TAX.CNT  = DCOUNT(LOC.WAIVE.TAX,@FM)
    VAL.DATE         = R.NEW(FT.CREDIT.VALUE.DATE)  ;* Not required
*VAR.TOT.CHG.AMT  = SUM(R.NEW(FT.LOCAL.REF)<1,POS.L.TT.COMM.AMT>)

    CNT = 1 ; VAR.TOT.CHG.AMT = ''
    LOOP
    WHILE CNT LE LOC.WAIVE.COMM.CNT
        Y.LOC.WAIVE.COMM.VALUE = LOC.WAIVE.COMM<CNT>
        IF Y.LOC.WAIVE.COMM.VALUE NE 'YES' THEN
            VAR.TOT.CHG.AMT = R.NEW(FT.LOCAL.REF)<1,POS.L.TT.COMM.AMT,CNT> + VAR.TOT.CHG.AMT
            LOC.WAIVE.COMM.FLAG = 1
        END
        CNT++
    REPEAT
*PACS00309586 - E
    VAR.NCF.REQ      = R.NEW(FT.LOCAL.REF)<1,POS.FT.NCF.REQ>
    VAR.TXN.REF      = R.NEW(FT.LOCAL.REF)<1,POS.FT.TXN.REF>
    VAR.TXN.TYPE     = R.NEW(FT.TRANSACTION.TYPE)
    VAR.TXN.DATE     = R.NEW(FT.DATE.TIME)
    VAR.DATE         = 20:VAR.TXN.DATE[1,6]
    VAR.CHG.CCY      = R.NEW(FT.DEBIT.CURRENCY)
    VAR.CHG.AMT      = VAR.TOT.CHG.AMT
    CHARGE.AMOUNT     = VAR.CHG.CCY:' ':VAR.CHG.AMT

*VAR.ACCOUNT      = R.NEW(FT.CHARGES.ACCT.NO)
    VAR.ACCOUNT      = R.NEW(FT.DEBIT.ACCT.NO)      ;* Since Charge.acct.no will not be updated
    CALL F.READ(FN.ACCOUNT,VAR.ACCOUNT,R.ACCT,F.ACCOUNT,ACC.ERR)
    VAR.CUS = R.ACCT<AC.CUSTOMER>
    IF NOT(VAR.CUS) THEN
        VAR.CUS=R.NEW(FT.ORDERING.CUST)
    END
    GET.ACCT.OFFICER = R.ACCT<AC.ACCOUNT.OFFICER>   ;* Not required
    GET.CATEGORY     = R.ACCT<AC.CATEGORY>          ;* Not required
    TXN.ID=ID.NEW
RETURN
**********
FT.PROCESS:
**********
*PACS00309586 - S
* the below IF condition is not satisfied since the field is sub value set
*IF VAR.CHG.AMT GT 0 AND LOC.WAIVE.COMM NE 'YES' THEN
    Y.CNT=0
    IF VAR.CHG.AMT GT 0 AND LOC.WAIVE.COMM.FLAG EQ '1' THEN
        Y.CNT+=1
    END
    IF Y.TAX.AMT GT 0 AND LOC.WAIVE.TAX.FLAG EQ '1' THEN
        Y.CNT+=1
    END
    IF Y.CNT THEN
        CALL REDO.NCF.PERF.RTN(Y.CNT,Y.NCF.NO.LIST)
* Fix for PACS00469724 [NCF not produced for the IVR transactions]

    END ELSE
        Y.GET.CHR.AMT = R.NEW(FT.COMMISSION.AMT)
        IF Y.GET.CHR.AMT THEN
            VAR.CHG.AMT = R.NEW(FT.LOCAL.CHARGE.AMT)
            CHARGE.AMOUNT = VAR.CHG.CCY:' ':VAR.CHG.AMT
            LOC.WAIVE.COMM.FLAG = 1
            CALL REDO.NCF.PERF.RTN('1',Y.NCF.NO.LIST)
        END ELSE

            Y.GET.CHG.TYPE = R.NEW(FT.CHARGE.AMT)

            IF Y.GET.CHG.TYPE THEN

                VAR.CHG.AMT = R.NEW(FT.LOCAL.CHARGE.AMT)
                CHARGE.AMOUNT = VAR.CHG.CCY:' ':VAR.CHG.AMT
                LOC.WAIVE.COMM.FLAG = 1
                CALL REDO.NCF.PERF.RTN('1',Y.NCF.NO.LIST)
            END

        END


    END
    IF VAR.CHG.AMT GT 0 AND LOC.WAIVE.COMM.FLAG EQ '1' THEN
        L.NCF.NUMBER=Y.NCF.NO.LIST<1>
        DEL Y.NCF.NO.LIST<1>
        GOSUB PROCESS1
    END

    IF Y.TAX.AMT GT 0 AND LOC.WAIVE.TAX.FLAG EQ '1' THEN
        L.NCF.NUMBER.TAX=Y.NCF.NO.LIST<1>         ;* Fix for PACS00469724
        GOSUB PROCESS.TAX
    END
RETURN
*********
PROCESS1:
*********

    IF L.NCF.NUMBER THEN
        GOSUB UPDATE.TABLE
    END ELSE
        GOSUB UPDATE.TABLE2
    END
RETURN
*-------------------
PROCESS.TAX:
*-------------------

    IF L.NCF.NUMBER.TAX THEN
        GOSUB UPDATE.TABLE.TAX
    END ELSE
        GOSUB UPDATE.TABLE2
    END
RETURN
**************
DEBIT.PROCESS:
**************

* End of Fix

    VAR.QTY.AVAIL.DR=R.REDO.L.NCF.STOCK<ST.L.QTY.AVAIL.DR>
    IF VAR.QTY.AVAIL.DR GT 0 THEN
        GOSUB FT.PROCESS1
    END ELSE
        GOSUB UPDATE.TABLE2
    END
RETURN
***********
FT.PROCESS1:
***********
*Generating NCF number and Updating STOCK table
    VAR.SERIES=R.REDO.L.NCF.STOCK<ST.SERIES>
    VAR.BUS.DIV=R.REDO.L.NCF.STOCK<ST.BUSINESS.DIV>
    VAR.PECF=R.REDO.L.NCF.STOCK<ST.PECF>
    VAR.AICF=R.REDO.L.NCF.STOCK<ST.AICF>
    VAR.TCF=R.REDO.L.NCF.STOCK<ST.TCF>
    VAR.SEQ.NO=R.REDO.L.NCF.STOCK<ST.SEQUENCE.DR>
    L.NCF.NUMBER=VAR.SERIES:VAR.BUS.DIV:VAR.PECF:VAR.AICF:VAR.TCF:VAR.SEQ.NO
    VAR.PREV.DR.RANGE=R.REDO.L.NCF.STOCK<ST.PRE.ED.RG.DR>
    VAR.PREV.DR.RANGE=VAR.PREV.DR.RANGE<1,DCOUNT(VAR.PREV.DR.RANGE,@VM)>

    IF VAR.SEQ.NO EQ VAR.PREV.DR.RANGE THEN
        VAR.STRT.RG=R.REDO.L.NCF.STOCK<ST.L.ST.RG.DR.NOTE>
        VAR.SEQ.NO=VAR.STRT.RG
    END ELSE
        VAR.SEQ.NO=VAR.SEQ.NO+1
    END
    VAR.QTY.AVAIL=R.REDO.L.NCF.STOCK<ST.L.QTY.AVAIL.DR>
    VAR.NCF.ISSUE=R.REDO.L.NCF.STOCK<ST.NCF.ISSUED.DR>
    VAR.MIN.NCF=R.REDO.L.NCF.STOCK<ST.MN.NCF.DR.NOTE>
    VAR.NCF.STATUS=R.REDO.L.NCF.STOCK<ST.NCF.STATUS.DR>
    VAR.NCF.ISSUE=VAR.NCF.ISSUE + 1
    VAR.QTY.AVAIL=VAR.QTY.AVAIL - 1
    IF VAR.QTY.AVAIL GE VAR.MIN.NCF THEN
        VAR.NCF.STATUS='AVAILABLE'
    END ELSE
        VAR.NCF.STATUS='UNAVAILABLE'
    END
    R.REDO.L.NCF.STOCK<ST.L.QTY.AVAIL.DR> = VAR.QTY.AVAIL
    R.REDO.L.NCF.STOCK<ST.NCF.ISSUED.DR> = VAR.NCF.ISSUE
    R.REDO.L.NCF.STOCK<ST.NCF.STATUS.DR> = VAR.NCF.STATUS
    R.REDO.L.NCF.STOCK<ST.SEQUENCE.DR> = VAR.SEQ.NO
    CALL F.WRITE(FN.REDO.L.NCF.STOCK,STOCK.ID,R.REDO.L.NCF.STOCK)
    GOSUB UPDATE.TABLE1
RETURN
**************
CREDIT.PROCESS:
**************
*FOR CREDIT ADJUSTMENT
* Fix for PACS00275478 [NCF Mail changes related to INTERFACE.CONFIG.PRT param mail path #3]
*    CALL CACHE.READ(FN.REDO.L.NCF.STOCK,STOCK.ID,R.REDO.L.NCF.STOCK,STOCK.ERR) ;* Not a static table using F.READ
*    CALL F.READ(FN.REDO.L.NCF.STOCK,STOCK.ID,R.REDO.L.NCF.STOCK,F.REDO.L.NCF.STOCK,STOCK.ERR)

* End of Fix

    VAR.QTY.AVAIL.CR=R.REDO.L.NCF.STOCK<ST.L.QTY.AVAIL.CR>
    IF VAR.QTY.AVAIL.CR GT 0 THEN
        VAR.SERIES=R.REDO.L.NCF.STOCK<ST.SERIES>
        VAR.BUS.DIV=R.REDO.L.NCF.STOCK<ST.BUSINESS.DIV>
        VAR.PECF=R.REDO.L.NCF.STOCK<ST.PECF>
        VAR.AICF=R.REDO.L.NCF.STOCK<ST.AICF>
        VAR.TCF=R.REDO.L.NCF.STOCK<ST.TCF>
        VAR.SEQ.NO=R.REDO.L.NCF.STOCK<ST.SEQUENCE.CR>
        L.NCF.NUMBER=VAR.SERIES:VAR.BUS.DIV:VAR.PECF:VAR.AICF:VAR.TCF:VAR.SEQ.NO

        VAR.PREV.CR.RANGE=R.REDO.L.NCF.STOCK<ST.PRE.ED.RG.CR>
        VAR.PREV.CR.RANGE=VAR.PREV.CR.RANGE<1,DCOUNT(VAR.PREV.CR.RANGE,@VM)>

        IF VAR.SEQ.NO EQ VAR.PREV.CR.RANGE THEN
            VAR.STRT.RG=R.REDO.L.NCF.STOCK<ST.L.ST.RG.CR.NOTE>
            VAR.SEQ.NO=VAR.STRT.RG
        END ELSE
            VAR.SEQ.NO=VAR.SEQ.NO+1
        END
        VAR.QTY.AVAIL=R.REDO.L.NCF.STOCK<ST.L.QTY.AVAIL.CR>
        VAR.NCF.ISSUE=R.REDO.L.NCF.STOCK<ST.L.NCF.ISSUED.CR>
        VAR.MIN.NCF=R.REDO.L.NCF.STOCK<ST.MN.NCF.CR.NOTE>
        VAR.NCF.STATUS=R.REDO.L.NCF.STOCK<ST.NCF.STATUS.CR>
        VAR.NCF.ISSUE=VAR.NCF.ISSUE + 1
        VAR.QTY.AVAIL=VAR.QTY.AVAIL - 1
        IF VAR.QTY.AVAIL GE VAR.MIN.NCF THEN
            VAR.NCF.STATUS='AVAILABLE'
        END ELSE
            VAR.NCF.STATUS='UNAVAILABLE'
        END
        R.REDO.L.NCF.STOCK<ST.L.QTY.AVAIL.CR> = VAR.QTY.AVAIL
        R.REDO.L.NCF.STOCK<ST.L.NCF.ISSUED.CR> = VAR.NCF.ISSUE
        R.REDO.L.NCF.STOCK<ST.NCF.STATUS.CR> = VAR.NCF.STATUS
        R.REDO.L.NCF.STOCK<ST.SEQUENCE.CR> = VAR.SEQ.NO
        CALL F.WRITE(FN.REDO.L.NCF.STOCK,STOCK.ID,R.REDO.L.NCF.STOCK)
        GOSUB UPDATE.TABLE1
    END ELSE
        GOSUB UPDATE.TABLE2
    END
RETURN
**********
MAIL.ALERT:
**********
*Sending Mail Alert
    CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
    VAR.UNIQUE.ID=UNIQUE.TIME
    FILENAME='APAP':VAR.UNIQUE.ID:'.TXT'

* Fix for PACS00275478 [NCF Mail changes related to INTERFACE.CONFIG.PRT param mail path #4]
*    FN.HRMS.FILE='MAIL.BP'
    GOSUB GET.MAIL.FOLDER
    FN.HRMS.FILE = Y.MAILIN.FOLDER
* End of Fix

    F.HRMA.FILE=''
    CALL OPF(FN.HRMS.FILE ,F.HRMA.FILE)
    REC=FROM.MAIL:"#":TO.MAIL:"#":SUBJ.MAIL:"#":MSG.MAIL
    WRITE REC TO F.HRMA.FILE,FILENAME
 
RETURN

*----------------
GET.MAIL.FOLDER:
*----------------
    R.INT.CONFIG = ''
    FN.INTERFACE.CONFIG.PRT = 'F.INTERFACE.CONFIG.PRT'
    F.INTERFACE.CONFIG.PRT = ''
    CALL OPF(FN.INTERFACE.CONFIG.PRT,F.INTERFACE.CONFIG.PRT)

    CALL CACHE.READ(FN.INTERFACE.CONFIG.PRT,"email",R.INT.CONFIG,EMAILL.ERR)
    IF R.INT.CONFIG THEN
        Y.FOLDER.TYPE = R.INT.CONFIG<INTRF.MSG.INT.FLD.NAME>
        Y.FOLDER.NAME = R.INT.CONFIG<INTRF.MSG.INT.FLD.VAL>
        CHANGE @VM TO @FM IN Y.FOLDER.TYPE
        CHANGE @VM TO @FM IN Y.FOLDER.NAME

        LOCATE "EMAIL_FOLDER_PATH" IN Y.FOLDER.TYPE SETTING TYPE.POS THEN
            Y.MAILIN.FOLDER = Y.FOLDER.NAME<TYPE.POS>
        END

        LOCATE "ERROR_FOLDER_PATH" IN Y.FOLDER.TYPE SETTING TYPE.POS THEN
            Y.ERROR.FOLDER = Y.FOLDER.NAME<TYPE.POS>
        END
    END

RETURN

**************
UPDATE.TABLE:
**************
*Updating ISSUED and Status Table
    NCF.ISSUE.ID=VAR.CUS:'.':VAR.DATE:'.':TXN.ID
    CALL F.READ(FN.REDO.NCF.ISSUED,NCF.ISSUE.ID,R.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED,ISSUE.MSG)
    R.REDO.NCF.ISSUED<ST.IS.TXN.ID>=TXN.ID
    R.REDO.NCF.ISSUED<ST.IS.CHARGE.AMOUNT>=CHARGE.AMOUNT
    R.REDO.NCF.ISSUED<ST.IS.DATE> = VAR.DATE
    R.REDO.NCF.ISSUED<ST.IS.CUSTOMER>=VAR.CUS
    R.REDO.NCF.ISSUED<ST.IS.ACCOUNT> = VAR.ACCOUNT
    NCF.CNT = DCOUNT(R.REDO.NCF.ISSUED<ST.IS.NCF>,@VM)
    R.REDO.NCF.ISSUED<ST.IS.NCF,NCF.CNT+1> = L.NCF.NUMBER
    R.NEW(FT.LOCAL.REF)<1,POS.FT.NCF.NO>=L.NCF.NUMBER
    CALL F.WRITE(FN.REDO.NCF.ISSUED,NCF.ISSUE.ID,R.REDO.NCF.ISSUED)
    CALL F.READ(FN.REDO.L.NCF.STATUS,NCF.ISSUE.ID,R.REDO.L.NCF.STATUS,F.REDO.L.NCF.STATUS,STATUS.MSG)
    R.REDO.L.NCF.STATUS<NCF.ST.TRANSACTION.ID>=ID.NEW
    R.REDO.L.NCF.STATUS<NCF.ST.CUSTOMER.ID>=VAR.CUS
    R.REDO.L.NCF.STATUS<NCF.ST.DATE>= VAR.DATE
    R.REDO.L.NCF.STATUS<NCF.ST.CHARGE.AMOUNT>=CHARGE.AMOUNT
    NCF.ST.CNT = DCOUNT(R.REDO.L.NCF.STATUS<NCF.ST.NCF>,@VM)
    R.REDO.L.NCF.STATUS<NCF.ST.NCF,NCF.ST.CNT+1>=L.NCF.NUMBER
    R.REDO.L.NCF.STATUS<NCF.ST.STATUS>='AVAILABLE'
    CALL F.WRITE(FN.REDO.L.NCF.STATUS,NCF.ISSUE.ID,R.REDO.L.NCF.STATUS)
RETURN
*-----------------------
UPDATE.TABLE.TAX:
*-----------------------
    NCF.ISSUE.ID=VAR.CUS:'.':VAR.DATE:'.':TXN.ID
    CALL F.READ(FN.REDO.NCF.ISSUED,NCF.ISSUE.ID,R.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED,ISSUE.MSG)
    R.REDO.NCF.ISSUED<ST.IS.TXN.ID>=TXN.ID
    R.REDO.NCF.ISSUED<ST.IS.TAX.AMOUNT>=VAR.TAX.AMT
    R.REDO.NCF.ISSUED<ST.IS.DATE> = VAR.DATE
    R.REDO.NCF.ISSUED<ST.IS.CUSTOMER>=VAR.CUS
    R.REDO.NCF.ISSUED<ST.IS.ACCOUNT> = VAR.ACCOUNT
    NCF.CNT = DCOUNT(R.REDO.NCF.ISSUED<ST.IS.NCF>,@VM)
    R.REDO.NCF.ISSUED<ST.IS.NCF,NCF.CNT+1> = L.NCF.NUMBER.TAX
    R.NEW(FT.LOCAL.REF)<1,POS.FT.NCF.NO.TAX>=L.NCF.NUMBER.TAX
    CALL F.WRITE(FN.REDO.NCF.ISSUED,NCF.ISSUE.ID,R.REDO.NCF.ISSUED)
    CALL F.READ(FN.REDO.L.NCF.STATUS,NCF.ISSUE.ID,R.REDO.L.NCF.STATUS,F.REDO.L.NCF.STATUS,STATUS.MSG)
    R.REDO.L.NCF.STATUS<NCF.ST.TRANSACTION.ID>=ID.NEW
    R.REDO.L.NCF.STATUS<NCF.ST.CUSTOMER.ID>=VAR.CUS
    R.REDO.L.NCF.STATUS<NCF.ST.DATE>= VAR.DATE
    R.REDO.L.NCF.STATUS<NCF.ST.TAX.AMOUNT>=VAR.TAX.AMT
    NCF.ST.CNT = DCOUNT(R.REDO.L.NCF.STATUS<NCF.ST.NCF>,@VM)
    R.REDO.L.NCF.STATUS<NCF.ST.NCF,NCF.ST.CNT+1>=L.NCF.NUMBER.TAX
    R.REDO.L.NCF.STATUS<NCF.ST.STATUS>='AVAILABLE'
    CALL F.WRITE(FN.REDO.L.NCF.STATUS,NCF.ISSUE.ID,R.REDO.L.NCF.STATUS)
RETURN
**************
UPDATE.TABLE1:
**************
*Updating ISSUED and Status Table
    NCF.ISSUE.ID=VAR.CUS:'.':VAR.DATE:'.':TXN.ID
    CALL F.READ(FN.REDO.NCF.ISSUED,NCF.ISSUE.ID,R.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED,ISSUE.MSG)
    R.REDO.NCF.ISSUED<ST.IS.TXN.ID>=TXN.ID
    R.REDO.NCF.ISSUED<ST.IS.CHARGE.AMOUNT>=CHARGE.AMOUNT
    R.REDO.NCF.ISSUED<ST.IS.TAX.AMOUNT>=VAR.TAX.AMT
    R.REDO.NCF.ISSUED<ST.IS.DATE> = VAR.DATE
    R.REDO.NCF.ISSUED<ST.IS.CUSTOMER>=VAR.CUS
    R.REDO.NCF.ISSUED<ST.IS.ACCOUNT> = VAR.ACCOUNT
    CALL F.READ(FN.FUNDS.TRANSFER,VAR.TXN.REF,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FT.ERR)
    VAL.TXN.REF=R.FUNDS.TRANSFER<FT.LOCAL.REF><1,POS.FT.NCF.NO>
    R.REDO.NCF.ISSUED<ST.IS.NCF> = VAL.TXN.REF
    R.REDO.NCF.ISSUED<ST.IS.MODIFIED.NCF>=L.NCF.NUMBER
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
    NCF.ISSUE.ID=VAR.CUS:'.':VAR.DATE:'.':TXN.ID
    CALL F.READ(FN.REDO.L.NCF.UNMAPPED,NCF.ISSUE.ID,R.REDO.L.NCF.UNMAPPED,F.REDO.L.NCF.UNMAPPED,UNMAP.ERR)
    R.REDO.L.NCF.UNMAPPED<ST.UN.TXN.ID>=ID.NEW
    R.REDO.L.NCF.UNMAPPED<ST.UN.CHARGE.AMOUNT>=CHARGE.AMOUNT
    R.REDO.L.NCF.UNMAPPED<ST.UN.TXN.TYPE>=VAR.TXN.TYPE
    R.REDO.L.NCF.UNMAPPED<ST.UN.TAX.AMOUNT>=VAR.TAX.AMT
    R.REDO.L.NCF.UNMAPPED<ST.UN.DATE>=VAR.DATE
    R.REDO.L.NCF.UNMAPPED<ST.UN.CUSTOMER>=VAR.CUS
    R.REDO.L.NCF.UNMAPPED<ST.UN.ACCOUNT> = VAR.ACCOUNT
    R.REDO.L.NCF.UNMAPPED<ST.UN.BATCH>='NO'
    CALL F.WRITE(FN.REDO.L.NCF.UNMAPPED,NCF.ISSUE.ID,R.REDO.L.NCF.UNMAPPED)
    CALL F.READ(FN.REDO.L.NCF.STATUS,NCF.ISSUE.ID,R.REDO.L.NCF.STATUS,F.REDO.L.NCF.STATUS,STATUS.MSG)
    R.REDO.L.NCF.STATUS<NCF.ST.TRANSACTION.ID>=ID.NEW
    R.REDO.L.NCF.STATUS<NCF.ST.CUSTOMER.ID>=VAR.CUS
    R.REDO.L.NCF.STATUS<NCF.ST.DATE>=VAR.DATE
    R.REDO.L.NCF.STATUS<NCF.ST.CHARGE.AMOUNT>=CHARGE.AMOUNT
    R.REDO.L.NCF.STATUS<NCF.ST.TAX.AMOUNT>=VAR.TAX.AMT
    R.REDO.L.NCF.STATUS<NCF.ST.NCF>=''
    R.REDO.L.NCF.STATUS<NCF.ST.STATUS>='UNAVAILABLE'
    CALL F.WRITE(FN.REDO.L.NCF.STATUS,NCF.ISSUE.ID,R.REDO.L.NCF.STATUS)
RETURN
*-------------------------------------------------------------------
CHECK.TAX.AMT:
*-------------------------------------------------------------------
    FT.DR.CURRENCY  = R.NEW(FT.DEBIT.CURRENCY)
    TRANS.DR.AMT    = R.NEW(FT.DEBIT.AMOUNT)
*PACS00309586 - S
*Sum up the amount which is not waived in comm/ tax instead of summing all the waive comm/ tax amount.
    VAR.TAX.AMT = ''
*VAR.TAX.AMT = SUM(R.NEW(FT.LOCAL.REF)<1,POS.L.TT.TAX.AMT>)

    TAX.CNT = 1
    LOOP
    WHILE TAX.CNT LE LOC.WAIVE.TAX.CNT
        Y.LOC.WAIVE.TAX.VALUE = LOC.WAIVE.TAX<TAX.CNT>
        IF Y.LOC.WAIVE.TAX.VALUE NE 'YES' THEN
            VAR.TAX.AMT = R.NEW(FT.LOCAL.REF)<1,POS.L.TT.TAX.AMT,TAX.CNT> + VAR.TAX.AMT
            LOC.WAIVE.TAX.FLAG = 1
        END
        TAX.CNT++
    REPEAT
*PACS00309586 - E
    Y.TAX.AMT = VAR.TAX.AMT
    IF VAR.TAX.AMT THEN
        VAR.TAX.AMT = FT.DR.CURRENCY:' ':VAR.TAX.AMT
    END ELSE
        VAR.TAX.AMT = '0.00'
    END

RETURN
*-------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*-------------------------------------------------------------------

    VAL.STATUS=R.NEW(FT.RECORD.STATUS)

    IF VAL.STATUS[1,1] EQ 'R' THEN
        PROCESS.GOAHEAD = ""
    END

RETURN
*----------------------------------------------------------------------
END