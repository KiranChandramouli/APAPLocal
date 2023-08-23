<<<<<<< Updated upstream
<<<<<<< Updated upstream
* @ValidationCode : MjotMTc5NDczNTg2OkNwMTI1MjoxNjkwMjY2NjQ2NzI5OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
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
* @ValidationCode : MjotMTQ1ODA5ODY2NjpDcDEyNTI6MTY4NDkxNjQ5MTI1MzpJVFNTOi0xOi0xOi02NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 May 2023 13:51:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -65
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
SUBROUTINE REDO.S.COL.GET.PAY.FREQ(P.IN.AA.ID,  P.IN.R.STATIC.MAPPING, P.IN.PROCESS.DATE, P.OUT.PAY.FREQ)
******************************************************************************
*
*    COLLECTOR - Interface
*    Allows to get the current Payment Frequency
* =============================================================================
*
*    First Release :  TAM
*    Developed for :  TAM
*    Developed by  :  APAP
*    Date          :  2010-11-15 C.1
*
*-----------------------------------------------------------------------------
*  HISTORY CHANGES:
*    2011-09-20 :  PACS00110378
*                  hpasquel@temenos.com
*    2011-11-30 :  PACS00169639
*                  hpasquel@temenos.com        To improve SELECT statements
* 05-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION  RETURN statement added
* 05-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------
*
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
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
    idPropertyClass = "PAYMENT.SCHEDULE"
    GOSUB ARR.CONDITIONS
    IF returnError THEN
        E = returnError
        RETURN ;* R22 Manual conversion - RETURN statement added
    END
    R.AA.SCHEDULE = RAISE(returnConditions)
    IF R.AA.SCHEDULE EQ "" THEN
        E = yRecordNotFound
        E<2> = "PAYMENT.SCHEDULE" : @VM : P.IN.AA.ID
        RETURN ;* R22 Manual conversion - RETURN statement added
    END

    P.OUT.PAY.FREQ =  R.AA.SCHEDULE<AA.PS.PAYMENT.FREQ,1>     ;* JCB just take the first because all the property's frequencies are the same
    Y.MAP.VALUE = P.OUT.PAY.FREQ
* << PP
    GOSUB EXTRACT.FREQUENCY
* >>
    Y.MAP.TYPE  = "PAYMENT.FREQ"
    E = ""
    R.STATIC.MAPPING = ""
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*    CALL REDO.R.COL.GET.MAPPING(C.ID.STATIC.MAPPING, R.STATIC.MAPPING, 1, P.IN.R.STATIC.MAPPING, Y.MAP.TYPE, Y.MAP.VALUE)
    APAP.TAM.redoRColGetMapping(C.ID.STATIC.MAPPING, R.STATIC.MAPPING, 1, P.IN.R.STATIC.MAPPING, Y.MAP.TYPE, Y.MAP.VALUE) ;*R22 Manual Code Conversion
=======
    CALL REDO.R.COL.GET.MAPPING(C.ID.STATIC.MAPPING, R.STATIC.MAPPING, 1, P.IN.R.STATIC.MAPPING, Y.MAP.TYPE, Y.MAP.VALUE)
>>>>>>> Stashed changes
=======
    CALL REDO.R.COL.GET.MAPPING(C.ID.STATIC.MAPPING, R.STATIC.MAPPING, 1, P.IN.R.STATIC.MAPPING, Y.MAP.TYPE, Y.MAP.VALUE)
>>>>>>> Stashed changes
    IF E THEN
        P.OUT.PAY.FREQ = ""
        RETURN ;* R22 Manual conversion - RETURN statement added
    END

    P.OUT.PAY.FREQ = Y.MAP.VALUE[1,20]

RETURN
*
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD = 1
*
*
RETURN
*
*
* ---------
EXTRACT.FREQUENCY:
* ---------
*  e0Y e1M e0W e9D e0F
*
    YEARS = Y.MAP.VALUE[" ",1,1]
    MONTHS = Y.MAP.VALUE[" ",2,1]
    WEEKS = Y.MAP.VALUE[" ",3,1]
    DAYS = Y.MAP.VALUE[" ",4,1]
    EB.FQU = Y.MAP.VALUE[" ",5,1]
    NO.FQU.VALUE = "e0"         ;* Indicates there is no value
    FREQUENCY = ''

    BEGIN CASE
        CASE YEARS[1,2] NE NO.FQU.VALUE
            FREQUENCY = YEARS         ;* e##Y
        CASE MONTHS[1,2] NE NO.FQU.VALUE
            FREQUENCY = MONTHS        ;* e##M
        CASE WEEKS[1,2] NE NO.FQU.VALUE
            FREQUENCY = WEEKS         ;* e##W
        CASE DAYS[1,2] NE NO.FQU.VALUE
            FREQUENCY = DAYS          ;* e##D
        CASE EB.FQU[1,2] NE NO.FQU.VALUE
            FREQUENCY = EB.FQU        ;* e##F
        CASE 1
            E = "Frequency " : Y.MAP.VALUE : " not in expected format"
            RETURN ;* R22 Manual conversion - RETURN statement added
    END CASE

    Y.MAP.VALUE = FREQUENCY[2,99]

RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
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
