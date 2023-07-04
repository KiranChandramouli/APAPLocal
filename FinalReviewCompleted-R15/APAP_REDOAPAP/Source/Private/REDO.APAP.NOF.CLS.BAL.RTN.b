* @ValidationCode : MjotNjg5MjkzNTU2OkNwMTI1MjoxNjg0ODM2MDQ3ODc1OklUU1M6LTE6LTE6NDQ4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 448
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.CLS.BAL.RTN(Y.ARR)
****************************************************
*Company Name: Asociacion Popular de ahorros y pristamos
*Program Name: REDO.APAP.NOF.CLS.BAL.RTN
******************************************************
*Description: This report shows the balance by cash currency that the cashiers possess. It indicates the amount
*in bills and coins (totalized per currency) of each cashier and bank vault totalized by agency
*(branch). It summarizes the opening balance of the cashiers/vault, the total of debit and credit
*transactions processed during the day and the closing balance
*--------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER.ID
    $INSERT I_F.COMPANY
    $INSERT I_F.DATES
    $INSERT I_F.ACCT.ACTIVITY

*******************************************************************************
*Modification Details:
*=====================
* Date          Who                Reference          Description
* ------        -----              -------------      -------------
* 11-OCT-2010   MD Preethi         0DR-2010-03-0149   Initial Creation
* 02-APR-2013   Vignesh Kumaar R   PACS00256400       Report Header and Data Section cosmetic changes
* Date                   who                   Reference              
* 06-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION FM TO @FM AND ++ TO += 1 AND F.READ TO CACHE.READ AND REMOVED F.COMPANY AND ! TO *
* 06-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*********************************************************************************

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

    Y.ARR = SORT(Y.ARRAY)

RETURN
*------------------------------------------------------------------------------------------------------------------------------
INIT:
*****
    FN.TELLER.ID     = 'F.TELLER.ID'
    F.TELLER.ID      = ''
    FN.COMPANY       = 'F.COMPANY'
    F.COMPANY        = ''
    FN.ACCT.ACTIVITY = 'F.ACCT.ACTIVITY'
    F.ACCT.ACTIVITY  = ''
    Y.LOC.FIELDS = 'L.TT.MAX.TL.LIM'
    Y.POS = ''
    CALL MULTI.GET.LOC.REF("TELLER.ID",Y.LOC.FIELDS,Y.POS)

    Y.TL.LIM.POS = Y.POS<1,1>

    Y.ARRAY                = ''
    Y.AGENCY               = ''
    Y.BDY.CLS.BAL          = ''
    Y.BDY.TOT.DEBIT        = ''
    Y.BDY.BROKER.LIM       = ''
    Y.CCY = '' ; Y.TT.ID = '' ; Y.TT.NAME= '' ; Y.BDY.CAHSIER.LIMIT = '' ; Y.BDY.OPN.BALANCE = '' ; Y.BDY.TOT.DEBIT = '' ; Y.BDY.TOT.CREDIT = '' ; Y.BDY.CLS.BAL = '' ; Y.CLASSIFICATION = ''

RETURN
*------------------------------------------------------------------------------------------------------------------------------
OPEN.FILES:
***************
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)
    CALL OPF(FN.COMPANY,F.COMPANY)
    CALL OPF(FN.ACCT.ACTIVITY,F.ACCT.ACTIVITY)
RETURN
*------------------------------------------------------------------------------------------------------------------------------
PROCESS:
*********
    SEL.TT.CMD = 'SELECT ':FN.TELLER.ID
    GOSUB CHECK.SEL.CMD
    SEL.TT.CMD := ' BY CO.CODE'
*
    CALL EB.READLIST(SEL.TT.CMD,SEL.TT.LIST,'',NO.OF.TT.REC,Y.ERR)
    LOOP
        REMOVE Y.TT.ID FROM SEL.TT.LIST SETTING Y.TT.POS
    WHILE Y.TT.ID : Y.TT.POS

        CALL F.READ(FN.TELLER.ID,Y.TT.ID,R.TT,F.TELLER.ID,Y.ERR)
        Y.COMP.CODE = R.TT<TT.TID.CO.CODE>
        Y.TT.NAME   = R.TT<TT.TID.USER>

        IF Y.TT.NAME EQ '' THEN
            Y.TT.NAME = 'VAULT'
        END

        CALL CACHE.READ(FN.COMPANY, Y.COMP.CODE, R.COM.CODE, Y.ERR) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.COMPANY
        Y.SUBDIVCO = R.COM.CODE<EB.COM.SUB.DIVISION.CODE>
*
        IF Y.AGENCY NE '' THEN
            IF Y.COMP.CODE NE Y.AGENCY THEN
                CONTINUE
            END
        END
*
        Y.CATEG.ARR                 = R.TT<TT.TID.CATEGORY>
        Y.CNT.CATEG                 = DCOUNT(Y.CATEG.ARR,@VM)
        Y.CNTR                      = 1
        LOOP
        WHILE Y.CNTR LE Y.CNT.CATEG
            Y.CATEG = R.TT<TT.TID.CATEGORY,Y.CNTR>
            IF Y.CATEG EQ '10001' THEN
                Y.CCY               = R.TT<TT.TID.CURRENCY,Y.CNTR>
                Y.CATEGORY          = R.TT<TT.TID.CATEGORY,Y.CNTR>
                Y.BDY.OPN.BALANCE   = R.TT<TT.TID.OPENING.BALANCE,Y.CNTR>
                Y.BDY.CLS.BAL       = R.TT<TT.TID.TILL.CLOS.BAL,Y.CNTR>
                Y.BDY.CAHSIER.LIMIT = R.TT<TT.TID.LOCAL.REF><1,Y.TL.LIM.POS,Y.CNTR>

                Y.WORKING.DAY       = TODAY
                Y.YEAR              = Y.WORKING.DAY[1,4]
                Y.MNTH              = Y.WORKING.DAY[5,2]
                Y.DAY               = Y.WORKING.DAY[7,2]
                Y.ACCT.ACT.ID       = Y.CCY:Y.CATEGORY:Y.TT.ID:Y.SUBDIVCO:"-":Y.YEAR:Y.MNTH
                GOSUB CHECK.ACCT.ACT
            END
            Y.CNTR += 1
        REPEAT
        Y.TT.ID += 1
    REPEAT
RETURN
*------------------------------------------------------------------------------------------------------------------------------
CHECK.SEL.CMD:
**************
    LOCATE 'AGENCY' IN D.FIELDS<1> SETTING Y.AGN.POS THEN
        Y.AGENCY                    = D.RANGE.AND.VALUE<Y.AGN.POS>
    END
RETURN
*-------------
CHECK.ACCT.ACT:
*--------------

    R.ACCT.ACTIVITY                 = ''

    CALL F.READ(FN.ACCT.ACTIVITY,Y.ACCT.ACT.ID,R.ACCT.ACTIVITY,F.ACCT.ACTIVITY,Y.ERR)
    Y.DAY.NO = R.ACCT.ACTIVITY<IC.ACT.DAY.NO>
    LOCATE Y.DAY IN Y.DAY.NO<1,1> SETTING Y.DAY.POS THEN
        Y.BDY.TOT.CREDIT            = R.ACCT.ACTIVITY<IC.ACT.TURNOVER.CREDIT,Y.DAY.POS>
        Y.BDY.TOT.DEBIT             = R.ACCT.ACTIVITY<IC.ACT.TURNOVER.DEBIT,Y.DAY.POS>
    END

    GOSUB FORM.TEMP.ARR

    TEMP.RANGE.AND.VALUE = D.RANGE.AND.VALUE
    CHANGE @FM TO ',' IN TEMP.RANGE.AND.VALUE

    Y.CLASSIFICATION = TEMP.RANGE.AND.VALUE

RETURN
*---------------------------------------------------------------------------------------------------------------------------------
*-----------------------*
FORM.TEMP.ARR:
*-----------------------*
*
    Y.SORT.DATA = Y.CCY:Y.COMP.CODE     ;* Fix for PACS00256400

    IF Y.ARRAY EQ '' THEN
        Y.ARRAY = Y.SORT.DATA:'*':Y.CCY:'*':Y.TT.ID:'*':Y.TT.NAME:'*':Y.BDY.CAHSIER.LIMIT:'*':Y.BDY.OPN.BALANCE:'*':Y.BDY.TOT.DEBIT:'*':Y.BDY.TOT.CREDIT:'*':Y.BDY.CLS.BAL:'*':Y.CLASSIFICATION:'*':Y.COMP.CODE   ;* Fix for PACS00256400
    END ELSE
        Y.ARRAY<-1> = Y.SORT.DATA:'*':Y.CCY:'*':Y.TT.ID:'*':Y.TT.NAME:'*':Y.BDY.CAHSIER.LIMIT:'*':Y.BDY.OPN.BALANCE:'*':Y.BDY.TOT.DEBIT:'*':Y.BDY.TOT.CREDIT:'*':Y.BDY.CLS.BAL:'*':Y.CLASSIFICATION:'*':Y.COMP.CODE         ;* Fix for PACS00256400
    END

    Y.BDY.CAHSIER.LIMIT = '' ; Y.BDY.OPN.BALANCE = '' ; Y.BDY.TOT.DEBIT = '' ; Y.BDY.TOT.CREDIT = '' ; Y.BDY.CLS.BAL = ''

RETURN
*---------------------------------------------------------------------------------------------------------------------------------
END
