* @ValidationCode : Mjo2MzIxNjA1NDY6Q3AxMjUyOjE2ODg1MzcxNTUxNzk6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jul 2023 11:35:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE redoIsLastDay(yDate)
******************************************************************************
*
*    Check if the date is the last day in its current month
*
* =============================================================================
*
*    First Release : Paul Pasquel
*    Developed for : TAM
*    Developed by  : TAM
*    Date          : 2011-11-12
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.VERSION
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
RETURN yResult
*
* ======
PROCESS:
* ======
*
*
    COMI = yDate : "M0131"
    Y.DAY = COMI[7,2]
    Y.DAY.TO.CHECK = Y.DAY + 0
    IF Y.DAY.TO.CHECK GT 1 THEN
        Y.DAY -= 1
    END
    COMI = yDate[1,6] : Y.DAY
    CALL CFQ
    yResult = COMI[1,8] EQ yDate
RETURN
*
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD = 1
    yResult = 0
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
*
RETURN
*
END
