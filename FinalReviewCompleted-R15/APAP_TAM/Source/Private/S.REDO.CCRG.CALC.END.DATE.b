* @ValidationCode : MjotOTMyMzc5Njg4OkNwMTI1MjoxNjg0ODQyMTU0MTA3OklUU1M6LTE6LTE6LTMyOjE6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -32
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE S.REDO.CCRG.CALC.END.DATE(P.RESULT, P.START.DATE)
*
*--------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description:
*              This routines is used on I-Desc. It allows to calculate an end.date, based in the
*     start.date and the time parameter REDO.CCRG.PARAMETERS>EFFECTIVE.TIME
*
* Linked With:
*              REDO.CCRG.RL.EFFECTIVE            (live-file)
*              REDO.CCRG.RL.EFFECTIVE.CUSTOMER   (live-file
*
* In Parameter:
* ---------------
*           P.START.DATE         (in)  Start Date in DATE.TIME format
*
* Out Parameter:
* ---------------
*           P.RESULT             (out) The end date in DATE.TIME format (YYMMDDHHMI ie 1104172035)
*                                      In case of Error, the user's message
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 06/04/2011 - ODR-2011-03-0154
*              First version. Risk Limit for Customer and Group Risk
*              hpasquel@temenos.com
** 19-04-2023 R22 Auto Conversion no changes
** 19-04-2023 Skanda R22 Manual Conversion - No changes, CALL routine format modified
*--------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.CCRG.PARAMETERS
*
*--------------------------------------------------------------------------------------------
*

    P.RESULT = ''
    GOSUB INITIALISE
    IF P.RESULT EQ '' THEN
        GOSUB PROCESS
    END
*
RETURN
*
*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------

*
* Do the calculation
*
    E = ''


    APAP.TAM.sRedoAddTime(P.START.DATE, P.RESULT, Y.EFF.TIME) ;*MANUAL R22 CODE CONVERSION

*
* Was there an error ?
*
    IF E THEN
        P.RESULT = E
    END

RETURN


*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------

    LOOP.CNT         = 1
    MAX.LOOPS        = 1
    PROCESS.GOAHEAD  = 1

*
* Read SYSTEM record from REDO.CCRG.PARAMTERES
*
    REDO.CCRG.PARAMETERS.ID = 'SYSTEM'
    CALL CACHE.READ('F.REDO.CCRG.PARAMETERS',REDO.CCRG.PARAMETERS.ID,R.REDO.CCRG.PARAMETERS,YERR)
    IF REDO.CCRG.PARAMETERS.ID EQ '' THEN
        P.RESULT = "Record SYSTEM not found in REDO.CCRG.PARAMETERS"
        RETURN
    END

*
* Get and check if EFFECTIVE.TIME is not blank
*
    Y.EFF.TIME = R.REDO.CCRG.PARAMETERS<REDO.CCRG.P.EFFECTIVE.TIME>

    IF Y.EFF.TIME EQ '' THEN
        P.RESULT = "Field REDO.CCRG.PARAMETERS>EFFECTIVE.TIME is blank"
        RETURN
    END

* Must have a length of 4 digits
    Y.EFF.TIME = FMT(Y.EFF.TIME,"R%4")

* The EFFECTIVE.TIME must be send in HH:MM format
    Y.EFF.TIME = Y.EFF.TIME[1,2] : ':' : Y.EFF.TIME[3,2]

RETURN

*--------------------------------------------------------------------------------------------

END
