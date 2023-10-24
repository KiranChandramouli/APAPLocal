* @ValidationCode : Mjo4NDE0ODY2NDpDcDEyNTI6MTY4MjQxMjMzNTE1MzpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUT.LETTER.ISSUE
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.AUT.LETTER.ISSUE
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is AUTHORISATION routine for REDO.LETTER.ISSUE
* to launch an enquiry  based on type of letter



*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO                REFERENCE                   DESCRIPTION
*18.03.2010  H GANESH            ODR-2009-10-0838                 INITIAL CREATION
*24.06.2011  RIYAS               PACS00072833                   WIVE CHARGE CONDITION
*08.09.2011  Sudharsanan S       PACS00120764               Pass the ID Value to generate the enquiries for customer and bank copy
*06-04-2023  Conversion Tool     R22 Auto Code conversion           F.READ TO CACHE.READ
*06-04-2023  Samaran T           R22 Manual Code Conversion         No Changes
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DEAL.SLIP.FORMAT
    $INSERT I_GTS.COMMON
    $INSERT I_F.USER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.LETTER.ISSUE
    $INSERT I_System

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN


*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    FN.FT.COMMISSION.TYPE='F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE=''
RETURN

*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------

    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.LETTER = R.NEW(REDO.LET.ISS.TYPE.OF.LETTER)

    Y.WAIVE=R.NEW(REDO.LET.ISS.WAIVE.CHARGES)
    IF Y.WAIVE NE 'YES' THEN
        GOSUB STATEMENT.ENTRY
    END

*PACS00120764 - S
    VAR.ID = ID.NEW

    BEGIN CASE

        CASE Y.LETTER EQ 'AUDITOR'
            CALL System.setVariable("CURRENT.AUD",VAR.ID)
            NEW.TASK="ENQ REDO.AUDITOR.PDF.GEN Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK)
            NEW.TASK1="ENQ REDO.AUDITOR.PDF.GEN.COPY Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK1)
        CASE Y.LETTER EQ 'CONSULAR'
            CALL System.setVariable("CURRENT.CONS",VAR.ID)
            NEW.TASK="ENQ REDO.CONSULAR.PDF.GEN Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK)
            NEW.TASK1="ENQ REDO.CONSULAR.PDF.GEN.COPY Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK1)
        CASE Y.LETTER EQ 'INDIVIDUAL'
            CALL System.setVariable("CURRENT.IND",VAR.ID)
            NEW.TASK="ENQ REDO.INDIVIDUAL.REF.PDF.GEN Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK)
            NEW.TASK1="ENQ REDO.INDIVIDUAL.REF.PDF.GEN.COPY Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK1)

        CASE Y.LETTER EQ 'COMMERCIAL'
            CALL System.setVariable("CURRENT.COMM",VAR.ID)
            NEW.TASK="ENQ REDO.COMMERCIAL.REF.PDF.GEN Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK)
            NEW.TASK1="ENQ REDO.COMMERCIAL.REF.PDF.GEN.COPY Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK1)

        CASE Y.LETTER EQ 'INTERNAL'
            CALL System.setVariable("CURRENT.INT",VAR.ID)
            NEW.TASK="ENQ REDO.INTERNAL.TAX.PDF.GEN Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK)
            NEW.TASK1="ENQ REDO.INTERNAL.TAX.PDF.GEN.COPY Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK1)

        CASE Y.LETTER EQ 'BALANCE'
            CALL System.setVariable("CURRENT.BAL",VAR.ID)
            NEW.TASK="ENQ REDO.BALANCE.CERTF.PDF.GEN Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK)
            NEW.TASK1="ENQ REDO.BALANCE.CERTF.PDF.GEN.COPY Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK1)

    END CASE
*PACS00120764 - E

RETURN
*----------------------------------------------------------------------
STATEMENT.ENTRY:
*----------------------------------------------------------------------

    Y.ACCOUNT.NO=R.NEW(REDO.LET.ISS.CHARGE.LIQ.ACT)
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.CURRENCY=R.NEW(REDO.LET.ISS.CHARGE.CCY)
    Y.AMOUNT=R.NEW(REDO.LET.ISS.CHARGE.AMT)
    Y.ACC.CUR=R.ACCOUNT<AC.CURRENCY>
    Y.CUSTOMER=R.ACCOUNT<AC.CUSTOMER>
    Y.ACCT.OFFICER=R.ACCOUNT<AC.ACCOUNT.OFFICER>
    Y.PRODUCT.CATEGORY=R.ACCOUNT<AC.CATEGORY>
    Y.FT.COMMISSION.TYPE=R.NEW(REDO.LET.ISS.CHARGE.KEY)
    CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.FT.COMMISSION.TYPE, R.FT.COMMISSION.TYPE, COMM.ERR)    ;*R22 AUTO CODE CONVERSION
    Y.CATEGORY.ACCOUNT=R.FT.COMMISSION.TYPE<FT4.CATEGORY.ACCOUNT>
    Y.CODE.CR=R.FT.COMMISSION.TYPE<FT4.TXN.CODE.CR>
    Y.CODE.DR =R.FT.COMMISSION.TYPE<FT4.TXN.CODE.DR>
    R.STMT.ARR = ''
    R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = Y.ACCOUNT.NO
    R.STMT.ARR<AC.STE.COMPANY.CODE> = ID.COMPANY
    IF Y.ACC.CUR EQ Y.CURRENCY THEN
        R.STMT.ARR<AC.STE.AMOUNT.LCY> = -1*Y.AMOUNT
    END ELSE
        CCY.MKT='1'
        BUY.AMT=''
        CALL EXCHRATE(CCY.MKT,Y.ACC.CUR,BUY.AMT,Y.CURRENCY,Y.AMOUNT,'','','','',RETURN.CODE)
        R.STMT.ARR<AC.STE.AMOUNT.LCY> =-1*BUY.AMT
    END
    R.STMT.ARR<AC.STE.CURRENCY> =Y.ACC.CUR
    R.STMT.ARR<AC.STE.AMOUNT.FCY> = ''
    R.STMT.ARR<AC.STE.TRANSACTION.CODE> = Y.CODE.DR
    R.STMT.ARR<AC.STE.THEIR.REFERENCE>=''
    R.STMT.ARR<AC.STE.CUSTOMER.ID> =Y.CUSTOMER
    R.STMT.ARR<AC.STE.ACCOUNT.OFFICER> = Y.ACCT.OFFICER
    R.STMT.ARR<AC.STE.PRODUCT.CATEGORY> = Y.PRODUCT.CATEGORY
    R.STMT.ARR<AC.STE.VALUE.DATE> = TODAY
    R.STMT.ARR<AC.STE.DEPARTMENT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
    R.STMT.ARR<AC.STE.CURRENCY.MARKET>='1'
    R.STMT.ARR<AC.STE.TRANS.REFERENCE>= "LETTER.ISSUE"
    R.STMT.ARR<AC.STE.SYSTEM.ID> = "COMM"
    R.STMT.ARR<AC.STE.BOOKING.DATE> = TODAY
    MULTI.STMT=''
    MULTI.STMT<-1> = LOWER(R.STMT.ARR)
    GOSUB RAISE.CATG.ENTRIES
    V = REDO.LET.ISS.AUDIT.DATE.TIME
    CALL EB.ACCOUNTING("BM.CRCD.MERCH.UPLOAD","SAO",MULTI.STMT,'')
RETURN

*----------------------------------------------------------------------
RAISE.CATG.ENTRIES:
*----------------------------------------------------------------------

    R.CATEG.ENT = ''
    R.CATEG.ENT<AC.CAT.ACCOUNT.NUMBER> = ''
    R.CATEG.ENT<AC.CAT.COMPANY.CODE>=ID.COMPANY
    IF Y.CURRENCY NE LCCY THEN
        CCY.MKT='1'
        BUY.AMT=''
        CALL EXCHRATE(CCY.MKT,LCCY,BUY.AMT,Y.CURRENCY,Y.AMOUNT,'','','','',RETURN.CODE)
        R.CATEG.ENT<AC.CAT.AMOUNT.LCY> =BUY.AMT
    END ELSE
        R.CATEG.ENT<AC.CAT.AMOUNT.LCY> =Y.AMOUNT
    END
    R.CATEG.ENT<AC.CAT.CURRENCY> =LCCY
    R.CATEG.ENT<AC.CAT.TRANSACTION.CODE> = Y.CODE.CR
    R.CATEG.ENT<AC.CAT.CUSTOMER.ID> = R.ACCOUNT<AC.CUSTOMER>
    R.CATEG.ENT<AC.CAT.DEPARTMENT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    R.CATEG.ENT<AC.CAT.PL.CATEGORY> = Y.CATEGORY.ACCOUNT
    R.CATEG.ENT<AC.CAT.PRODUCT.CATEGORY> = R.ACCOUNT<AC.CATEGORY>
    R.CATEG.ENT<AC.CAT.VALUE.DATE> = TODAY
    R.CATEG.ENT<AC.CAT.EXCHANGE.RATE> = ''
    R.CATEG.ENT<AC.CAT.CURRENCY.MARKET> = "1"
    R.CATEG.ENT<AC.CAT.TRANS.REFERENCE> = 'LETTER.ISSUE'
    R.CATEG.ENT<AC.CAT.SYSTEM.ID> = "COMM"
    R.CATEG.ENT<AC.CAT.BOOKING.DATE> = TODAY
    R.CATEG.ENT<AC.CAT.NARRATIVE> ='LETTER.ISSUE.COM'
    MULTI.STMT<-1> = LOWER(R.CATEG.ENT)
RETURN

END
