* @ValidationCode : MjotMjY1NTExMTk3OkNwMTI1MjoxNjgxODg4MjQ1ODMyOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 12:40:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE S.REDO.ADD.TIME(Y.START.DATE, Y.END.DATE, Y.TIME)
*--------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description:
*              This routine allows to add a time to a start date
*
* It works with date's format YYMMDDHHMI
* Y.TIME  could be, the number of minutes to add or time (in format HH:MI)
*
* Example
*
*    Y.SD = "1012310344"
*
*    CALL R.REDO.ADD.MINUTES(Y.SD, Y.ED, 77)      ;* returns 1101070223 (2011-01-07 02:23)
*
*    CALL R.REDO.ADD.MINUTES(Y.SD, Y.ED, "01:17") ;* returns 1101070223 (2011-01-07 02:23)
*
* Parameters:
*            Y.START.DATE   (in)       Start Date with format YYMMDDHHMI
*            Y.END.DATE     (out)      Result Date.
*            Y.TIME         (in)       Time to add, could be the number of minutes or a value in format "HH:MI"
* Output
*            E (common)      (out)     message in case of error
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 06/04/2011 - ODR-2011-03-0154
*              First version. Risk Limit for Customer and Group Risk
*              hpasquel@temenos.com
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*19/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION              > TO GT
*19/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*--------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*

*   This routines does not allow to "less" minutes to the date
    E = ''
    GOSUB INIT
    IF E EQ '' THEN
        GOSUB PROCESS
    END

RETURN

*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------

    Y.YR = Y.START.DATE[1,2]
    Y.MH = Y.START.DATE[3,2]
    Y.DY = Y.START.DATE[5,2]
    Y.HR = Y.START.DATE[7,2]
    Y.ME = Y.START.DATE[9,2]

*  Minutes
    Y.ME += Y.MIN
    IF Y.ME GT 59 THEN ;*AUTO R22 CODE CONVERSION
        Y.MEM = MOD(Y.ME,60)
        Y.HRT = (Y.ME - Y.MEM)/60
        Y.ME  = FMT(Y.MEM,"R%2")
        Y.HR  += Y.HRT
    END

* Hours
    IF Y.HR GT 23 THEN ;*AUTO R22 CODE CONVERSION
        Y.DYM = MOD(Y.HR,24)
        Y.DYT = (Y.HR - Y.DYM)/24
        Y.HR  = Y.DYM
    END
    Y.HR = FMT(Y.HR,"R%2")

* Days
    Y.CY = OCONV(DATE(),"D-")   ;* who knows, may be this remains until the next century ?
    Y.CY = Y.CY[7,2]

    Y.END.DATE = Y.CY : Y.YR : Y.MH : Y.DY
    CALL CDT ("",Y.END.DATE, Y.DYT : "C")

    Y.END.DATE = Y.END.DATE : Y.HR : Y.ME
    Y.END.DATE = Y.END.DATE[3,99]

RETURN
*--------------------------------------------------------------
INIT:
*--------------------------------------------------------------

    IF Y.TIME EQ '' OR Y.TIME LE 0 THEN
        Y.END.DATE = ''
        E = 'PARAMETER Y.MIN MUST BE GREATER THAN ZERO. Y.MIN : ' : Y.MIN
        RETURN
    END

    Y.MIN = Y.TIME
    IF INDEX(Y.TIME,":",1) THEN
        Y.T.HR = Y.TIME[":",1,1]
        Y.T.MI = Y.TIME[":",2,1]
        Y.MIN = (Y.T.HR*60) + Y.T.MI

    END

RETURN
*--------------------------------------------------------------
END
