<<<<<<< Updated upstream
<<<<<<< Updated upstream
* @ValidationCode : MjotOTM0Mjk2MjEyOkNwMTI1MjoxNjkwMjY2NjQ2NzQ0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 12:00:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
=======
=======
>>>>>>> Stashed changes
* @ValidationCode : MjoxOTMyOTM0NjMzOkNwMTI1MjoxNjg0OTE2NDkxMzMzOklUU1M6LTE6LTE6LTYxOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 May 2023 13:51:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -61
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.COL.GET.PAY.TYPE(P.IN.AA.ID,  P.IN.R.STATIC.MAPPING, P.IN.PROCESS.DATE, P.OUT.PAY.TYPE)
******************************************************************************
*
*    COLLECTOR - Interface
*    Allows to get the Payment Type
* =============================================================================
*
*    First Release :  TAM
*    Developed for :  TAM
*    Developed by  :  APAP
*    Date          :  2010-11-15 C.1
*
*=======================================================================
*    2011-11-30 :  PACS00169639
*                  hpasquel@temenos.com        To improve SELECT statements
* 05-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION  RETURN statement added
* 05-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_REDO.COL.CUSTOMER.COMMON
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    $USING APAP.TAM
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
*
*************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
*

* << PACS00169639
    idPropertyClass = "PAYMENT.SCHEDULE"
    GOSUB ARR.CONDITIONS
    IF returnError THEN
        E = returnError
        RETURN ;* R22 Manual conversion - RETURN statement added
    END
    R.AA.SCHEDULE = RAISE(returnConditions)

    Y.AA.ACT.CLASS =  R.AA.SCHEDULE<1>    ;* ? I_F.AA.PAYMENT.SCHEDULE has a DESCRIPTION field as first positions (bug to check)

    Y.IS.APPLYPAYMENT    = Y.AA.ACT.CLASS["-",1,2] EQ 'LENDING-APPLYPAYMENT'
    Y.IS.CR.ARRANGEMENT  = Y.AA.ACT.CLASS["-",1,3] EQ 'LENDING-CREDIT-ARRANGEMENT'
    Y.IS.PAYOFF          = Y.AA.ACT.CLASS["-",1,3] EQ 'LENDING-SETTLE-PAYOFF'

    IF NOT(Y.IS.APPLYPAYMENT) AND NOT(Y.IS.CR.ARRANGEMENT) AND NOT(Y.IS.PAYOFF)  THEN
        RETURN ;* R22 Manual conversion - RETURN statement added
    END
* >> PACS00169639

    Y.MAP.VALUE = ""
    P.OUT.PAY.TYPE =  R.AA.SCHEDULE<AA.PS.LOCAL.REF,Y.AA.PS.L.AA.PAY.METHD>
    IF P.OUT.PAY.TYPE EQ "" THEN
        RETURN ;* R22 Manual conversion - RETURN statement added
    END

    Y.MAP.VALUE = P.OUT.PAY.TYPE
    Y.MAP.TYPE  = "PAYMENT.TYPE"
    E = ""
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*   CALL REDO.R.COL.GET.MAPPING(C.ID.STATIC.MAPPING, P.IN.R.STATIC.MAPPING, 1, P.IN.R.STATIC.MAPPING, Y.MAP.TYPE, Y.MAP.VALUE)
    APAP.TAM.redoRColGetMapping(C.ID.STATIC.MAPPING, P.IN.R.STATIC.MAPPING, 1, P.IN.R.STATIC.MAPPING, Y.MAP.TYPE, Y.MAP.VALUE) ;*R22 Manual Code Conversion
=======
    CALL REDO.R.COL.GET.MAPPING(C.ID.STATIC.MAPPING, P.IN.R.STATIC.MAPPING, 1, P.IN.R.STATIC.MAPPING, Y.MAP.TYPE, Y.MAP.VALUE)
>>>>>>> Stashed changes
=======
    CALL REDO.R.COL.GET.MAPPING(C.ID.STATIC.MAPPING, P.IN.R.STATIC.MAPPING, 1, P.IN.R.STATIC.MAPPING, Y.MAP.TYPE, Y.MAP.VALUE)
>>>>>>> Stashed changes
    IF E THEN
        P.OUT.PAY.TYPE = ""
        RETURN ;* R22 Manual conversion - RETURN statement added
    END

    P.OUT.PAY.TYPE = Y.MAP.VALUE[1,1]

RETURN
*
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD = 1

* Local Fields for AA.ARR.PAYMENT.SCHEDULE
    Y.LOC.REF.AA.PAY.SCH   = "AA.PRD.DES.PAYMENT.SCHEDULE"
    Y.LOC.REF.AA.PAY.SCH.FIELDS = "L.AA.PAY.METHD"
    CALL MULTI.GET.LOC.REF(Y.LOC.REF.AA.PAY.SCH, Y.LOC.REF.AA.PAY.SCH.FIELDS, LOC.REF.POS)
    Y.AA.PS.L.AA.PAY.METHD = LOC.REF.POS<1,1>
    IF NOT(Y.AA.PS.L.AA.PAY.METHD) THEN
        E = yLocalRefFieldNotDef
        E<2> = "L.AA.PAY.METHD" : @VM : Y.LOC.REF.AA.PAY.SCH
        PROCESS.GOAHEAD = 0
        RETURN ;* R22 Manual conversion - RETURN statement added
    END

*
*
RETURN
*
*
* ---------
OPEN.FILES:
* ---------
*
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 1
RETURN
*
*-----------------------------------------------------------------------------
ARR.CONDITIONS:
*-----------------------------------------------------------------------------
    ArrangementID = P.IN.AA.ID ; idProperty = ''; effectiveDate = P.IN.PROCESS.DATE; returnIds = ''; R.CONDITION =''; returnConditions = ''; returnError = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
RETURN
*-----------------------------------------------------------------------------
END
