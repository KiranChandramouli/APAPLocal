* @ValidationCode : MjotMjkxODE0MjI1OkNwMTI1MjoxNjg0ODU0Mzk2MzgyOklUU1M6LTE6LTE6Njg2OToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 6869
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.REVAL.REVERSE(FINAL.ARRAY)
*---------------------------------------------------------------------------------------------
*DESCRIPTION
*------------
*This batch routine will select all the CATEG.IDS whose PL.CATGEORY is equal to REVERSE.PL.CATEG
*This batch routine for each Categ.Entry record calls EB.ACCOUNTING to raise reverse Categ.Entry
*with the amount passed in negative.
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
* 01-12-2011   Victor Panchi                         Multibooking
* 01-12-2011   Marcelo Gudino                        Multibooking
* 23-08-2013   Marcelo Gudino                        APAP- functionallity
*---------------------------------------------------------------------------------------------
* 30/08/2016 - Mod1 - Saran. U
*            - Changes made to select the details from RE.SPEC.ENT.LWORK.DAY instead of RE.CONSOL.SPEC.ENTRY
*              So that the indexes that exists in RE.CONSOL.SPEC.ENTRY can be avoided & improves the performance in R09 To R15 upgrade time around 12 hours of avoiding index time.
*              Also improves overall performance in Online & CoB while raising the spec entries
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - VM TO @VM AND SM TO @SM AND ++ TO += 1 AND CONVERT TO CHANGE AND = TO EQ AND ADD END
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.COMPANY
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.RE.CONSOL.SPEC.ENTRY
    $INSERT I_REDO.B.REVAL.REVERSE.COMMON
    $INSERT I_F.REDO.H.REVALUATION.PARAM
    $INSERT I_F.REDO.L.REVAL.FCY.PROD.POS
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON

    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ 'PROCESS'
            GOSUB PRE.INIT
        CASE CONTROL.LIST<1,1> EQ 'MERGE'
            GOSUB SELECT.AND.MERGE
        CASE 1

    END CASE

RETURN
*--------------------------------------------------------------------------------------------
PRE.INIT:
*--------------------------------------------------------------------------------------------
* Mod1 S
    Y.SPEC.ID = FIELD(FINAL.ARRAY,'*',2,1)
    R.SPEC.ENTRY = ''; SPEC.RD.ERR = ''
    CALL F.READ(FN.SPEC.ENTRY,Y.SPEC.ID,R.SPEC.ENTRY,F.SPEC.ENTRY,SPEC.RD.ERR)

    IF R.SPEC.ENTRY<RE.CSE.TRANSACTION.CODE> EQ 'RVL' AND R.SPEC.ENTRY<RE.CSE.BOOKING.DATE> EQ TODAY ELSE
        RETURN
    END  ;*R22 AUTO CONVERSTION ADD END
* Mod1 E

    GOSUB INITIALISE
    GOSUB PROCESS.SPEC

RETURN
*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------
*Initialising the needed varaibles for this routine.

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
    SET.FLAG = ''
    PROD.LIVE.ARRAY = ''
    DEPT.ACCT.LIST = ''
    DAO.POS = ''

    SPEC.ID.COMPNAY = ''

RETURN

*--------------------------------------------------------------------------------------------
PROCESS.SPEC:
*---------------------------------------------------------------------------------------------

    FIRST.PRODUCT.FOUND = ''
    SPEC.CCY = ''
    PROD.CATEGORY = ''
    SPEC.ACCT.OFFICER = ''
    ARRAY1 = ''
    ARRAY2 = ''
    ARRAY3 = ''
    Y.REV.PL = ''
    Y.ADD.PL.AMOUNT = ''
    Y.COND = ''

    Y.REV.P.CATEG = Y.REV.PL.CATEG<1,1>
    Y.REV.L.CATEG = Y.REV.PL.CATEG<1,2>


    CRT "Y.REV.P.CATEG"
    CRT Y.REV.P.CATEG
    CRT "Y.REV.L.CATEG"
    CRT Y.REV.L.CATEG

* Mod1 S
*    Y.SPEC.ID = FINAL.ARRAY
* Mod1 E
    IF Y.SPEC.ID NE '' THEN
        GOSUB SPEC.ID.SUB

        LOOP
            REMOVE ST.RANGE FROM ARRAY1 SETTING START.POS
            REMOVE ED.RANGE FROM ARRAY2 SETTING END.POS
            REMOVE PL.VALUE FROM ARRAY3 SETTING PL.POS
        WHILE ST.RANGE:START.POS

            CRT "ST.RANGE"
            CRT ST.RANGE
            CRT "ED.RANGE"
            CRT ED.RANGE


            IF SET.FLAG EQ 'Y' THEN
                BREAK
            END ELSE
                IF PROD.CATEGORY GE ST.RANGE AND PROD.CATEGORY LE ED.RANGE THEN
                    SET.FLAG = 'Y'
                    FIRST.PRODUCT.FOUND = PROD.CATEGORY
                END
            END
        REPEAT
    END

    GOSUB LOCATE.CATEG

RETURN

SPEC.ID.SUB:

* Mod1 S
*    CALL F.READ(FN.SPEC.ENTRY,Y.SPEC.ID,R.SPEC.ENTRY,F.SPEC.ENTRY,SPEC.ERROR)
* Mod1 E

* SOLO SI NO ESTA EN LA LISTA DE CONSOLIDATE.COND ID ASSET&LIAB
    Y.COND = FIELD(R.SPEC.ENTRY<RE.CSE.CONSOL.KEY.TYPE>,'.',18)

    CRT "Y.COND"
    CRT Y.COND

    CRT "Y.LIST.CONSOLIDATE.COND<1>"
    CRT Y.LIST.CONSOLIDATE.COND<1>

    IF SUBSTRINGS(Y.COND, LEN(Y.COND) - 1 , 2) EQ 'BL' THEN
        RETURN
    END

    LOCATE Y.COND IN Y.LIST.CONSOLIDATE.COND<1> SETTING PRD.POS THEN
        RETURN;
    END

    CRT "PASO"

    PROD.CATEGORY = FIELD(R.SPEC.ENTRY<RE.CSE.CONSOL.KEY.TYPE>,'.',5)
    SPEC.CCY = R.SPEC.ENTRY<RE.CSE.CURRENCY>
    SPEC.AMOUNT = R.SPEC.ENTRY<RE.CSE.AMOUNT.LCY>
*SPEC.ACCT.OFFICER = FIELD(R.SPEC.ENTRY<RE.CSE.CONSOL.KEY.TYPE>,'.',8)
    SPEC.ACCT.OFFICER = R.SPEC.ENTRY<RE.CSE.ACCOUNT.OFFICER>
    SPEC.ID.COMPNAY = R.SPEC.ENTRY<RE.CSE.COMPANY.CODE>
    ARRAY1 = Y.START.RANGE.ARR
    ARRAY2 = Y.END.RANGE.ARR
    ARRAY3 = Y.PL.CATEG

    CRT "ARRAY1"
    CRT ARRAY1
    CRT "ARRAY2"
    CRT ARRAY2
    CRT "ARRAY3"
    CRT ARRAY3


RETURN
*---------------------------------------------------------------------------------------------
LOCATE.CATEG:
*---------------------------------------------------------------------------------------------

    IF FIRST.PRODUCT.FOUND THEN
        GOSUB UPDATE.LIVEFILE
    END

RETURN
*------------------------------------------------------------------------------------------------
UPDATE.LIVEFILE:
*------------------------------------------------------------------------------------------------
    PRD.CNT = ''
    EVB.L.GAAP.REVAL.FCY.PROD.POS.ID = SPEC.ID.COMPNAY : '.' : TODAY : '.' : AGENT.NUMBER
    R.EVB.L.GAAP.REVAL.FCY.PROD.POS = ''
    GAAP.ERR = ''
    CCY.LIVE.ARRAY = ''
    TEMP.CCY.LIVE.ARRAY = ''
    CALL F.READU(FN.EVB.L.GAAP.REVAL.FCY.PROD.POS,EVB.L.GAAP.REVAL.FCY.PROD.POS.ID,R.EVB.L.GAAP.REVAL.FCY.PROD.POS,F.EVB.L.GAAP.REVAL.FCY.PROD.POS,GAAP.ERR," ")

    IF R.EVB.L.GAAP.REVAL.FCY.PROD.POS EQ '' THEN
        R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.PRODUCT.CODE> = FIRST.PRODUCT.FOUND
        R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.ACCOUNT.OFFICER> = SPEC.ACCT.OFFICER

        Y.ADD.PL.AMOUNT = 0
        PROD.CNT = 1
* TODO LLA,AR AL GOSUB
        R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.CCY.POSITION> = SPEC.CCY
        R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.USD.AMOUNT> = SPEC.AMOUNT
        R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.ACCOUNT.OFFICER> = SPEC.ACCT.OFFICER

        CRT "SPEC.AMOUNT - IF"
        CRT SPEC.AMOUNT

*R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.REVERSE.PL.CATEGORY> = Y.REV.PL
    END ELSE
        PROD.LIVE.ARRAY = R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.PRODUCT.CODE>
        DEPT.ACCT.LIST = R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.ACCOUNT.OFFICER>
        CCY.LIVE.ARRAY = R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.CCY.POSITION>
        BREAK.FLAG = ''  ; EXIST.PROD = ''  ; PROD.CNT = ''
        EXIST.DAO = '' ; PROD.POS = ''  ; DAO.POS = ''

        CRT "PROD.LIVE.ARRAY"
        CRT PROD.LIVE.ARRAY
        GOSUB FIRST.PRD.SUB

    END

    IF R.EVB.L.GAAP.REVAL.FCY.PROD.POS NE '' THEN

        CRT "R.EVB.L.GAAP.REVAL.FCY.PROD.POS"
        CRT R.EVB.L.GAAP.REVAL.FCY.PROD.POS

        GOSUB UPDATE.SPEC.AMOUNT

        CRT "Y.REV.PL"
        CRT Y.REV.PL
        CALL F.WRITE(FN.EVB.L.GAAP.REVAL.FCY.PROD.POS,EVB.L.GAAP.REVAL.FCY.PROD.POS.ID,R.EVB.L.GAAP.REVAL.FCY.PROD.POS)
    END
RETURN

FIRST.PRD.SUB:

    LOCATE FIRST.PRODUCT.FOUND IN PROD.LIVE.ARRAY<1,1> SETTING PRD.POS THEN
        LOOP
            PROD.CNT +=1
            REMOVE EXIST.PROD FROM PROD.LIVE.ARRAY SETTING PROD.POS
            REMOVE EXIST.DAO FROM DEPT.ACCT.LIST SETTING DAO.POS
        WHILE EXIST.PROD:PROD.POS
            IF FIRST.PRODUCT.FOUND EQ EXIST.PROD THEN
                IF EXIST.DAO EQ SPEC.ACCT.OFFICER THEN

                    GOSUB BRK.CRT
                    GOSUB BRK.LCOS
                    BREAK.FLAG = 'Y'
                    BREAK
                END
            END
        REPEAT
        IF BREAK.FLAG EQ 'Y' ELSE
            GOSUB BRK.SDD
        END
    END ELSE
        GOSUB BRK.ESLE
    END

RETURN

BRK.LCOS:

    LOCATE SPEC.CCY IN TEMP.CCY.LIVE.ARRAY<1,1> SETTING CCY.POS THEN
        CRT "SPEC.CCY"
        CRT SPEC.CCY

        CRT "R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.USD.AMOUNT,PROD.CNT,CCY.POS>"
        CRT R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.USD.AMOUNT,PROD.CNT,CCY.POS>

        CRT "SPEC.AMOUNT"
        CRT SPEC.AMOUNT

        CRT "SPEC.CCY"
        CRT SPEC.CCY

*IF (R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.USD.AMOUNT,PROD.CNT,CCY.POS> GE 0 AND SPEC.AMOUNT GE 0) OR (R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.USD.AMOUNT,PROD.CNT,CCY.POS> LE 0 AND SPEC.AMOUNT LE 0) THEN
        R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.USD.AMOUNT,PROD.CNT,CCY.POS> += SPEC.AMOUNT
*END

    END ELSE
        CRT "SPEC.AMOUNT - ELSE"
        CRT SPEC.AMOUNT

        CRT "SPEC.CCY"
        CRT SPEC.CCY

        R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.CCY.POSITION,PROD.CNT,-1> = SPEC.CCY
        R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.USD.AMOUNT,PROD.CNT,-1> = SPEC.AMOUNT
    END

RETURN

BRK.CRT:

    CRT "FIRST.PRODUCT.FOUND"
    CRT FIRST.PRODUCT.FOUND

    TEMP.CCY.LIVE.ARRAY = ''
    TEMP.CCY.LIVE.ARRAY = CCY.LIVE.ARRAY<1,PROD.CNT>

    CRT "TEMP.CCY.LIVE.ARRAY "
    CRT TEMP.CCY.LIVE.ARRAY


    CHANGE @SM TO @VM IN TEMP.CCY.LIVE.ARRAY   ;*R22 AUTO CONVERSTION CONVERT TO CHANGE

    CRT "TEMP.CCY.LIVE.ARRAY - SM"
    CRT TEMP.CCY.LIVE.ARRAY

RETURN

BRK.SDD:

    PRD.CNT = DCOUNT(R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.PRODUCT.CODE>,@VM)
    PRD.CNT += 1

    CRT  "FIRST.PRODUCT.FOUND -1"
    CRT FIRST.PRODUCT.FOUND
    CRT "SPEC.CCY"
    CRT SPEC.CCY
    CRT "SPEC.AMOUNT"
    CRT SPEC.AMOUNT
    CRT "SPEC.ACCT.OFFICER"
    CRT SPEC.ACCT.OFFICER

    R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.PRODUCT.CODE,PRD.CNT> = FIRST.PRODUCT.FOUND
    R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.CCY.POSITION,PRD.CNT,-1> = SPEC.CCY
    R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.USD.AMOUNT,PRD.CNT,-1> = SPEC.AMOUNT
    R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.ACCOUNT.OFFICER,PRD.CNT> = SPEC.ACCT.OFFICER

RETURN

BRK.ESLE:

    CRT  "FIRST.PRODUCT.FOUND - ELSE"
    CRT FIRST.PRODUCT.FOUND
    CRT "SPEC.CCY"
    CRT SPEC.CCY
    CRT "SPEC.AMOUNT"
    CRT SPEC.AMOUNT
    CRT "SPEC.ACCT.OFFICER"
    CRT SPEC.ACCT.OFFICER

    PRD.CNT = DCOUNT(R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.PRODUCT.CODE>,@VM)
    PRD.CNT += 1
    R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.PRODUCT.CODE,PRD.CNT> = FIRST.PRODUCT.FOUND
    R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.CCY.POSITION,PRD.CNT,-1> = SPEC.CCY
    R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.USD.AMOUNT,PRD.CNT,-1> = SPEC.AMOUNT
    R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.ACCOUNT.OFFICER,PRD.CNT> = SPEC.ACCT.OFFICER

RETURN

*-----------------------------------------------------------------------------------------------
UPDATE.SPEC.AMOUNT:
*------------------------------------------------------------------------------------------------
    IF R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.USD.AMOUNT,PROD.CNT,CCY.POS> GT 0 THEN
        Y.REV.PL = Y.REV.P.CATEG
*IF Y.ADD.PL.AMOUNT EQ 0 THEN
*R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.CCY.POSITION,PROD.CNT> = SPEC.CCY
*R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.USD.AMOUNT,PROD.CNT> = SPEC.AMOUNT
*R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.REV.PL.CATEG,1,1> = Y.REV.PL
*END
*ELSE
        R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.REV.PL.CATEG,PRD.CNT,-1> = Y.REV.PL
*END
    END
    ELSE
        Y.REV.PL = Y.REV.L.CATEG
*IF Y.ADD.PL.AMOUNT EQ 0 THEN
* R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.CCY.POSITION,PROD.CNT,-1> = SPEC.CCY
*R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.USD.AMOUNT,PROD.CNT,-1> = SPEC.AMOUNT
        R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.REV.PL.CATEG,PRD.CNT,-1> = Y.REV.PL
*END
*ELSE
* R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.USD.AMOUNT,PROD.CNT,CCY.POS> += SPEC.AMOUNT
*END
    END


RETURN
*-----------------------------------------------------------------------------------------------
SELECT.AND.MERGE:
*-----------------------------------------------------------------------------------------------

    SEL.STMT = '' ; SEL.LIST = '' ; SEL.NO = '' ; ERR = ''
    SEL.STMT = 'SELECT ':FN.EVB.L.GAAP.REVAL.FCY.PROD.POS:' WITH @ID LIKE ':DQUOTE('...':SQUOTE(TODAY):'...')
    CALL EB.READLIST(SEL.STMT,SEL.LIST,'','',ERR)
    LOOP
        REMOVE ID FROM SEL.LIST SETTING POS
    WHILE ID:POS
        CALL F.READU(FN.EVB.L.GAAP.REVAL.FCY.PROD.POS,ID,R.EVB.L.GAAP.REVAL.FCY.PROD.POS,F.EVB.L.GAAP.REVAL.FCY.PROD.POS,ERR,'')
        MERGE.ID = FIELDS(ID,'.',1,2)
        CALL F.READU(FN.EVB.L.GAAP.REVAL.FCY.PROD.POS,MERGE.ID,R.MERGED.RECORD,F.EVB.L.GAAP.REVAL.FCY.PROD.POS,ERR,'')
        GOSUB MERGE.RECORDS

        CALL F.WRITE(FN.EVB.L.GAAP.REVAL.FCY.PROD.POS,MERGE.ID,R.MERGED.RECORD)
        CALL F.DELETE(FN.EVB.L.GAAP.REVAL.FCY.PROD.POS,ID)
    REPEAT
RETURN
*-----------------------------------------------------------------------------------------------
MERGE.RECORDS:
*-----------------------------------------------------------------------------------------------

    PROD.CNT = 0
    LOOP
        PROD.CNT += 1
        PROD.CODE = R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.PRODUCT.CODE,PROD.CNT>
        ACCT.OFF = R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.ACCOUNT.OFFICER,PROD.CNT>
    WHILE PROD.CODE
        LOCATE PROD.CODE IN R.MERGED.RECORD<REV.PROD.POS.PRODUCT.CODE,1> SETTING MERGE.PROD.POS THEN
            GOSUB MERGE.EXIST.PROD
        END ELSE
            GOSUB MERGE.NEW.PROD
        END
    REPEAT
RETURN
*-----------------------------------------------------------------------------------------------
MERGE.EXIST.PROD:
*-----------------------------------------------------------------------------------------------
    CCY.CNT=0
    LOOP
        CCY.CNT += 1
        CCY.CODE = R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.CCY.POSITION,PROD.CNT,CCY.CNT>
        CCY.AMT = R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.USD.AMOUNT,PROD.CNT,CCY.CNT>
        REV.PL.CATEG = R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.REV.PL.CATEG,PROD.CNT,CCY.CNT>
    WHILE CCY.CODE
        LOCATE CCY.CODE IN R.MERGED.RECORD<REV.PROD.POS.CCY.POSITION,MERGE.PROD.POS,1> SETTING MERGE.CCY.POS THEN
            R.MERGED.RECORD<REV.PROD.POS.USD.AMOUNT,MERGE.PROD.POS,MERGE.CCY.POS> += CCY.AMT
            IF REV.PL.CATEG THEN
                R.MERGED.RECORD<REV.PROD.POS.REV.PL.CATEG,MERGE.PROD.POS,MERGE.CCY.POS> = REV.PL.CATEG
            END
        END ELSE
            IF R.MERGED.RECORD<REV.PROD.POS.CCY.POSITION,MERGE.PROD.POS> EQ '' THEN
                CCY.CODE.CNT = 1
            END ELSE
                CCY.CODE.CNT = DCOUNT(R.MERGED.RECORD<REV.PROD.POS.CCY.POSITION,MERGE.PROD.POS>,@SM)+1
            END
            R.MERGED.RECORD<REV.PROD.POS.CCY.POSITION,MERGE.PROD.POS,CCY.CODE.CNT> = CCY.CODE
            R.MERGED.RECORD<REV.PROD.POS.USD.AMOUNT,MERGE.PROD.POS,CCY.CODE.CNT> = CCY.AMT
            IF REV.PL.CATEG THEN
                R.MERGED.RECORD<REV.PROD.POS.REV.PL.CATEG,MERGE.PROD.POS,CCY.CODE.CNT> = REV.PL.CATEG
            END
        END
    REPEAT
RETURN
*-----------------------------------------------------------------------------------------------
MERGE.NEW.PROD:
*-----------------------------------------------------------------------------------------------
    IF R.MERGED.RECORD<REV.PROD.POS.PRODUCT.CODE> EQ '' THEN
        PROD.CODE.CNT = 1
    END ELSE
        PROD.CODE.CNT = DCOUNT(R.MERGED.RECORD<REV.PROD.POS.PRODUCT.CODE>,@VM)+1
    END
    R.MERGED.RECORD<REV.PROD.POS.PRODUCT.CODE,PROD.CODE.CNT> = PROD.CODE
    R.MERGED.RECORD<REV.PROD.POS.ACCOUNT.OFFICER,PROD.CODE.CNT> = ACCT.OFF
    CCY.CNT = 0 ; INS.CNT = 0
    LOOP
        CCY.CNT += 1
        CCY.CODE = R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.CCY.POSITION,PROD.CNT,CCY.CNT>
        CCY.AMT = R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.USD.AMOUNT,PROD.CNT,CCY.CNT>
        REV.PL.CATEG = R.EVB.L.GAAP.REVAL.FCY.PROD.POS<REV.PROD.POS.REV.PL.CATEG,PROD.CNT,CCY.CNT>
    WHILE CCY.CODE
        INS.CNT += 1
        R.MERGED.RECORD<REV.PROD.POS.CCY.POSITION,PROD.CODE.CNT,INS.CNT> = CCY.CODE
        R.MERGED.RECORD<REV.PROD.POS.USD.AMOUNT,PROD.CODE.CNT,INS.CNT> = CCY.AMT
        R.MERGED.RECORD<REV.PROD.POS.REV.PL.CATEG,PROD.CODE.CNT,INS.CNT> = REV.PL.CATEG
    REPEAT
RETURN
END
