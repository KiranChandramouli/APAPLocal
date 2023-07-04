* @ValidationCode : MjoxNzI1NTI4MzcwOkNwMTI1MjoxNjg0ODU0Mzk2MTkyOklUU1M6LTE6LTE6MjI5MToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 2291
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.REVAL.FCY.PROD.POS
*---------------------------------------------------------------------------------------------
*DESCRIPTION
*------------
* This is a post routine that will consolidate the amount in the table REDO.L.REVAL.FCY.PROD.POS based
* on the USD amount and it will raise a CATEG.ENTRY
*---------------------------------------------------------------------------------------------
* Input / Output
* --------------
* IN     : Y.FINAL.ARR
* OUT    : -NA-
*
* Dependencies
* ------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* CHANGE REQUEST / DEVELOPMENT REF:
*---------------------------------------------------------------------------------------------
* Revision History
* ----------------
* Date          Who                 Reference         Description
* 01-12-2011   Victor Panchi                          Multibooking
* 01-12-2011   Marcelo Gudino                         Multibooking
* 31-10-2018   Juanmanuel Lobos                       Multibooking
* 03-12-2018   Juanmanuel Lobos                       Multibooking
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND ++ TO += 1
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.REDO.L.REVAL.FCY.PROD.POS
    $INSERT I_REDO.B.REVAL.FCY.PROD.POS.COMMON
    $INSERT I_F.REDO.H.REVALUATION.PARAM

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PARAMETER.READ
    GOSUB PROCESS.ENTRIES

RETURN

*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------

    TOTAL.CAT.AMT = ''
    PRODUCT.FLAG = ''
    Y.PRODUCT.CCY = ''
    Y.TOTAL.CATEG.AMT = ''
    Y.AMOUNT = ''
    Y.PRODUCT.CODE = ''
    TERMIN.FLAG = ''
    R.EVB.L.GAAP.REVAL.FCY.PROD.POS = ''
    EVB.L.GAAP.REVAL.FCY.PROD.POS.ERR = ''
    TXN.GAAP.CODE = ''
    PRODUCT.CNT.START = ''
    POS.START = ''
    PRODUCT.CNT.END = ''
    PRODUCT.START = ''
    CATEG.ENTRY.ID = ''
    CATEG.POS = ''
    R.CATEG.ENTRY = ''
    CATEG.ERR = ''
    TOTAL.AMT = 0
    CATEG.AMT = ''
    CATEG.TRANS = ''
    CATEG.NARR = ''
    CATEG.PL.CATEG = ''
    CATEG.VALUE = ''
    CATEG.CUR = ''
    CATEG.FAMT = ''
    CATEG.EXPOSURE = ''
    CATEG.MARKET = ''
    CATEG.DEPT = ''
    CATEG.TRANS.REF = ''
    CATEG.SYS.ID = ''
    CATEG.BOOKING = ''
    GAAP.L.ID = ''
    Y.REV.ARR = ''
    R.EVB.H.GAAP.REVALUATION.PARAM = ''
    Y.SYS.ID = ''
    PRODUCT.CNT.START.LIST = ''
    SYSTEM.ID = ''
    SYSTEM.ID = ID.COMPANY
    Y.ARR.COMPANY = ''
    Y.TOTAL.PL.AMT = 0
RETURN

*--------------------------------------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------------------------------------

    FN.EVB.L.GAAP.REVAL.FCY.PROD.POS = 'F.REDO.L.REVAL.FCY.PROD.POS'
    F.EVB.L.GAAP.REVAL.FCY.PROD.POS = ''
    CALL OPF(FN.EVB.L.GAAP.REVAL.FCY.PROD.POS,F.EVB.L.GAAP.REVAL.FCY.PROD.POS)

    FN.EVB.H.GAAP.REVALUATION.PARAM = 'F.REDO.H.REVALUATION.PARAM'
    F.EVB.H.GAAP.REVALUATION.PARAM = ''
    CALL OPF(FN.EVB.H.GAAP.REVALUATION.PARAM,F.EVB.H.GAAP.REVALUATION.PARAM)

    FN.CATEG.ENTRY = 'F.CATEG.ENTRY'
    F.CATEG.ENTRY = ''
    CALL OPF(FN.CATEG.ENTRY,F.CATEG.ENTRY)

    FN.CATEG.ENT.TODAY = 'F.CATEG.ENT.TODAY'
    F.CATEG.ENT.TODAY = ''
    CALL OPF(FN.CATEG.ENT.TODAY,F.CATEG.ENT.TODAY)
RETURN

*--------------------------------------------------------------------------------------------
PARAMETER.READ:
*--------------------------------------------------------------------------------------------
    CALL CACHE.READ(FN.EVB.H.GAAP.REVALUATION.PARAM,SYSTEM.ID,R.EVB.H.GAAP.REVALUATION.PARAM,EVB.H.GAAP.REVALUATION.PARAM.ERR)
    IF R.EVB.H.GAAP.REVALUATION.PARAM NE '' THEN
        Y.SYS.ID = R.EVB.H.GAAP.REVALUATION.PARAM<REVAL.PARM.ENTRY.SYSTEM.ID>
    END
    VALUE = TODAY[1,8]
RETURN

*--------------------------------------------------------------------------------------------
PROCESS.ENTRIES:
*--------------------------------------------------------------------------------------------
    Y.REV.CATEG = ''
    Y.REV.ARR = ''
    Y.CONT.PLS = DCOUNT(R.EVB.H.GAAP.REVALUATION.PARAM<REVAL.PARM.REV.PL.CATEGORY>, @VM)

    CRT "Y.CONT.PLS"
    CRT Y.CONT.PLS

    FOR Y.CONT = 1 TO Y.CONT.PLS
        Y.REV.PL.CATEG = R.EVB.H.GAAP.REVALUATION.PARAM<REVAL.PARM.REV.PL.CATEGORY, Y.CONT>
        PRODUCT.CNT.START.LIST = R.EVB.H.GAAP.REVALUATION.PARAM<REVAL.PARM.START.PRD.RANGE,Y.CONT>

        CRT "PRODUCT.CNT.START.LIST"
        CRT PRODUCT.CNT.START.LIST

        CRT "Y.REV.PL.CATEG"
        CRT Y.REV.PL.CATEG

        GOSUB FIRST.SUB.PROCESS.ENTRY
    NEXT

    IF Y.REV.ARR THEN
* Mod2 JLOBOS
* CALL OF EB.ACCOUNTING IS REPLACED WITH CALL TO GOSUB IN ORDER TO EDIT ARRAY PER COMPANY
* CALL EB.ACCOUNTING("CATEG.ENTRY","SAO",Y.REV.ARR,"")
*        CRT "Y.REV.ARR"
*        CRT Y.REV.ARR
        GOSUB ACCOUNTING.PER.COMPANY
* End Mod2 JLOBOS
    END
RETURN

*--------------------------------------------------------------------------------------------
ACCOUNTING.PER.COMPANY:
*--------------------------------------------------------------------------------------------
    ORIG.COMPANY=ID.COMPANY ; *SAVES INITIAL VALUE OF ID.COMPANY
    JL.COMPANY.CODE=''
    JL.COUNTI=''
    JL.COUNT.COMP=''
    JL.COUNT.COMP=DCOUNT(Y.ARR.COMPANY, @FM); * NUMBER OF BRANCHES
    JL.COUNT.REC=''
    JL.COUNT.REC=DCOUNT(Y.REV.ARR, @FM); * NUMBER OF RECORDS IN ARRAY

    FOR JL.COUNTI=1 TO JL.COUNT.COMP; * FOR EACH COPANY WE REVIEW THE ARRAY
        JL.COMPANY.CODE=Y.ARR.COMPANY<JL.COUNTI>
        JL.MVMNT=''; * CLEAR ARRAY VARIABLE
        JL.COUNTJ=''
        FOR JL.COUNTJ=1 TO JL.COUNT.REC; * REVIEW EACH RECORD IN ARRAY
            IF Y.REV.ARR<JL.COUNTJ,2> EQ JL.COMPANY.CODE THEN; * THE RECORD BELONGS TO COMPANY I
                JL.MVMNT<-1>=Y.REV.ARR<JL.COUNTJ>
            END
        NEXT
        IF JL.MVMNT THEN ; *IF ARRAY IS NOT EMPTY
            CALL LOAD.COMPANY(JL.COMPANY.CODE); * MOVES TO COMAPNY I IN ORDER TO CALL EB.ACCOUNTING
            CALL EB.ACCOUNTING("CATEG.ENTRY","SAO",JL.MVMNT,"")
            CALL LOAD.COMPANY(ORIG.COMPANY); * MOVES TO ORIGINAL COMPANY
        END
    NEXT JL.COUNTI
    CALL LOAD.COMPANY(ORIG.COMPANY); * MOVES TO ORIGINAL COMPANY
RETURN

*--------------------------------------------------------------------------------------------
FIRST.SUB.PROCESS.ENTRY:
*--------------------------------------------------------------------------------------------
    SELECT.CMD = 'SELECT ' : FN.CATEG.ENT.TODAY : ' WITH @ID LIKE ' :Y.REV.PL.CATEG:'...'
    CALL EB.READLIST(SELECT.CMD,SELECT.LIST,'',NO.OF.RECORDS,CATEG.ERROR)
    LOOP
        REMOVE CATEG.ENTRY.ID.FULL FROM SELECT.LIST SETTING POS1
    WHILE POS1:CATEG.ENTRY.ID.FULL
        R.CATEG.ENTRY = ''   ;  CATEG.ERR = ''
        CATEG.AMT = ''
        CATEG.ENTRY.ID = FIELD(CATEG.ENTRY.ID.FULL,'-',4)
        IF CATEG.ENTRY.ID NE '' THEN
            CALL F.READ(FN.CATEG.ENTRY,CATEG.ENTRY.ID,R.CATEG.ENTRY,F.CATEG.ENTRY,CATEG.ERR)
            GOSUB SUB.PROCESS.ENTRY
        END
    REPEAT
RETURN

*--------------------------------------------------------------------------------------------
SUB.PROCESS.ENTRY:
*--------------------------------------------------------------------------------------------
    IF R.CATEG.ENTRY NE '' THEN
        Y.REV.CATEG = ''
        Y.TOTAL.PL.AMT = 0
        CATEG.AMT = R.CATEG.ENTRY<AC.CAT.AMOUNT.LCY>
        CATEG.TRANS = R.CATEG.ENTRY<AC.CAT.TRANSACTION.CODE>
        CATEG.NARR = R.CATEG.ENTRY<AC.CAT.NARRATIVE>
        CATEG.PL.CATEG = Y.REV.PL.CATEG       ;* R.CATEG.ENTRY<AC.CAT.PL.CATEGORY>
        CATEG.VALUE = R.CATEG.ENTRY<AC.CAT.VALUE.DATE>
        CATEG.CUR = R.CATEG.ENTRY<AC.CAT.CURRENCY>
        CATEG.FAMT = R.CATEG.ENTRY<AC.CAT.AMOUNT.FCY>
        CATEG.EXPOSURE = R.CATEG.ENTRY<AC.CAT.EXPOSURE.DATE>
        CATEG.MARKET = R.CATEG.ENTRY<AC.CAT.CURRENCY.MARKET>
        CATEG.DEPT = R.CATEG.ENTRY<AC.CAT.DEPARTMENT.CODE>
        CATEG.TRANS.REF = R.CATEG.ENTRY<AC.CAT.TRANS.REFERENCE>
        CATEG.SYS.ID = R.CATEG.ENTRY<AC.CAT.SYSTEM.ID>
        CATEG.BOOKING = R.CATEG.ENTRY<AC.CAT.BOOKING.DATE>
        CATEG.ID.COMPANY = R.CATEG.ENTRY<AC.CAT.COMPANY.CODE>

        Y.REV.CATEG<AC.CAT.COMPANY.CODE> = CATEG.ID.COMPANY
        CATEG.AMT = -1 * CATEG.AMT
        Y.REV.CATEG<AC.CAT.TRANSACTION.CODE> = CATEG.TRANS
        Y.REV.CATEG<AC.CAT.NARRATIVE> = 'EVRB Reversal of PL'
        Y.REV.CATEG<AC.CAT.PL.CATEGORY> = CATEG.PL.CATEG
        Y.REV.CATEG<AC.CAT.VALUE.DATE> = CATEG.VALUE
        Y.REV.CATEG<AC.CAT.CURRENCY> = LCCY
        Y.REV.CATEG<AC.CAT.EXPOSURE.DATE> = CATEG.EXPOSURE
        Y.REV.CATEG<AC.CAT.CURRENCY.MARKET> = CATEG.MARKET
        Y.REV.CATEG<AC.CAT.DEPARTMENT.CODE> = CATEG.DEPT
        Y.REV.CATEG<AC.CAT.TRANS.REFERENCE> = CATEG.TRANS.REF
        Y.REV.CATEG<AC.CAT.SYSTEM.ID> = CATEG.SYS.ID
        Y.REV.CATEG<AC.CAT.BOOKING.DATE> = CATEG.BOOKING
        Y.REV.CATEG<AC.CAT.AMOUNT.LCY> = CATEG.AMT
        GOSUB LIVE.TABLE.PROCESS

* Mod3 JLOBOS
* Includes the IF statement to control Y.TOTAL.PL.AMT NE 0
        IF Y.TOTAL.PL.AMT NE 0 THEN
            Y.REV.CATEG<AC.CAT.AMOUNT.LCY> = -1 * Y.TOTAL.PL.AMT
            Y.REV.ARR<-1> = LOWER(Y.REV.CATEG)
        END
* End Mod3 JLOBOS
    END
RETURN

*--------------------------------------------------------------------------------------------
LIVE.TABLE.PROCESS:
*--------------------------------------------------------------------------------------------
* should add a field in .POS ? with PL.CATEGORY ?
    LOCATE CATEG.ID.COMPANY IN Y.ARR.COMPANY<1> SETTING COMPANY.POS THEN
        RETURN;
    END
    ELSE
        Y.ARR.COMPANY<-1> = CATEG.ID.COMPANY
    END

    ID.REVAL.COM = CATEG.ID.COMPANY:'.':VALUE
    CALL F.READ(FN.EVB.L.GAAP.REVAL.FCY.PROD.POS,ID.REVAL.COM,R.EVB.L.GAAP.REVAL.FCY.PROD.POS,F.EVB.L.GAAP.REVAL.FCY.PROD.POS,EVB.L.GAAP.REVAL.FCY.PROD.POS.ERR)

    Y.PRODUCT.CODE.VALUE = R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.PRODUCT.CODE>
    CRT "Y.PRODUCT.CODE.VALUE"
    CRT Y.PRODUCT.CODE.VALUE

    PRODUCT.FLAG = 1
    LOOP
        REMOVE Y.PRODUCT.CODE FROM Y.PRODUCT.CODE.VALUE SETTING POS.ERR
    WHILE Y.PRODUCT.CODE:POS.ERR
        Y.PL.CCY = 0
        Y.PRODUCT.CCY = R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.CCY.POSITION,PRODUCT.FLAG>
        Y.REV.PL.CATEG.POS = R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.REV.PL.CATEG,PRODUCT.FLAG>

        CRT "Y.PRODUCT.CCY"
        CRT Y.PRODUCT.CCY

        Y.ACCOUNT.OFF = R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.ACCOUNT.OFFICER,PRODUCT.FLAG>
        CURRENCY.FLAG = 1
        Y.TOTAL.CATEG.AMT = ''

        GOSUB SUB.WHILE.1

        CRT "Y.PRODUCT.CODE-Y.PRODUCT.CCY.VALUE-Y.PL.CATEG}"
        CRT Y.PRODUCT.CODE : "." : Y.PRODUCT.CCY.VALUE: ".":Y.PL.CATEG

        IF Y.TOTAL.CATEG.AMT LT 0 THEN
            Y.TOTAL.CATEG.AMT = -1 * Y.TOTAL.CATEG.AMT
            TXN.GAAP.CODE = '302'
        END ELSE
            Y.TOTAL.CATEG.AMT = -1 * Y.TOTAL.CATEG.AMT
            TXN.GAAP.CODE = '303'
        END
        GOSUB CATEG.RAISE

        PRODUCT.FLAG += 1
    REPEAT
    V =11
RETURN

*--------------------------------------------------------------------------------------------
SUB.WHILE.1:
*--------------------------------------------------------------------------------------------
    LOOP
        REMOVE Y.PL.CATEG FROM Y.REV.PL.CATEG.POS SETTING POS.ERR.PL
        REMOVE Y.PRODUCT.CCY.VALUE FROM Y.PRODUCT.CCY SETTING POS.ERR.VAL
    WHILE Y.PRODUCT.CCY.VALUE:POS.ERR.VAL

        CRT "Y.PRODUCT.CODE-Y.PRODUCT.CCY.VALUE-Y.PL.CATEG{"
        CRT Y.PRODUCT.CODE : "." : Y.PRODUCT.CCY.VALUE: "." :Y.PL.CATEG
* CCY.POSITION, REV.PL.CATEG, PRODUCT.CODE
*IF Y.PRODUCT.CCY.VALUE EQ CATEG.CUR THEN ; *AND Y.PL.CATEG EQ CATEG.PL.CATEG THEN ;*AND Y.PRODUCT.CODE EQ "" THEN
        Y.AMOUNT = R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.USD.AMOUNT,PRODUCT.FLAG,CURRENCY.FLAG>
        Y.TOTAL.CATEG.AMT += Y.AMOUNT
        Y.PL.CCY  = 1
*END
        CURRENCY.FLAG += 1
    REPEAT
RETURN

*--------------------------------------------------------------------------------------------
CATEG.RAISE:
*--------------------------------------------------------------------------------------------
    TERMIN.FLAG = ''
    PRODUCT.START.LIST = ''

    GOSUB DO.PL.CAT

    PRODUCT.CNT.START.LIST = R.EVB.H.GAAP.REVALUATION.PARAM<REVAL.PARM.START.PRD.RANGE,PL.CAT.MV>
    PRODUCT.START.LIST = PRODUCT.CNT.START.LIST
    PRODUCT.START = 1
    PL.CAT = ''
    LOOP
        REMOVE PRODUCT.CNT.START FROM PRODUCT.START.LIST SETTING POS.START
    WHILE PRODUCT.CNT.START:POS.START
* Should add IF sentence by each CATEGORY -> Profit and LOSS
        PRODUCT.CNT.END = R.EVB.H.GAAP.REVALUATION.PARAM<REVAL.PARM.END.PRD.RANGE,PL.CAT.MV,PRODUCT.START>

        CRT "PRODUCT.CNT.END"
        CRT PRODUCT.CNT.END

* Mod3 JLOBOS
* Change of conditional in IF clause for Y.TOTAL.CATEG.AMT, previous was Y.TOTAL.CATEG.AMT GT 0
        IF Y.TOTAL.CATEG.AMT NE 0 AND Y.PRODUCT.CODE GE PRODUCT.CNT.START AND Y.PRODUCT.CODE LE PRODUCT.CNT.END THEN
* End Mod3 JLOBOS
            PL.CAT = R.EVB.H.GAAP.REVALUATION.PARAM<REVAL.PARM.PL.CATEGORY,PL.CAT.MV,PRODUCT.START>
            TERMIN.FLAG = 1

            CRT "PL.CAT, Y.TOTAL.CATEG.AMT: "
            CRT PL.CAT:" , ":Y.TOTAL.CATEG.AMT:" - PL.CAT.MV" : PL.CAT.MV

            Y.FORM.CATEG = ''
            Y.FORM.CATEG<AC.CAT.COMPANY.CODE> = CATEG.ID.COMPANY
            Y.FORM.CATEG<AC.CAT.TRANSACTION.CODE> = TXN.GAAP.CODE
            Y.FORM.CATEG<AC.CAT.PL.CATEGORY> = PL.CAT
            Y.FORM.CATEG<AC.CAT.PRODUCT.CATEGORY> = Y.PRODUCT.CODE
            Y.FORM.CATEG<AC.CAT.CURRENCY> = LCCY
            Y.FORM.CATEG<AC.CAT.CURRENCY.MARKET> = "1"
            Y.FORM.CATEG<AC.CAT.SYSTEM.ID> = Y.SYS.ID
            Y.FORM.CATEG<AC.CAT.AMOUNT.LCY> = Y.TOTAL.CATEG.AMT
            Y.FORM.CATEG<AC.CAT.TRANS.REFERENCE> = ''
            Y.FORM.CATEG<AC.CAT.VALUE.DATE> = TODAY
            Y.FORM.CATEG<AC.CAT.BOOKING.DATE> = TODAY
            Y.FORM.CATEG<AC.CAT.ACCOUNT.OFFICER> = Y.ACCOUNT.OFF
            Y.TOTAL.PL.AMT+=Y.TOTAL.CATEG.AMT
            Y.REV.ARR<-1> = LOWER(Y.FORM.CATEG)
            RETURN;
        END
        PRODUCT.START += 1
    REPEAT
RETURN

*------------------------------------------------------------------------------
DO.PL.CAT:
*------------------------------------------------------------------------------
    IF Y.TOTAL.CATEG.AMT GT 0 THEN
        PL.CAT.MV = 2
    END ELSE
        PL.CAT.MV = 1
    END
RETURN

*-----------------Final.End-------------------------------------------------------------
END
