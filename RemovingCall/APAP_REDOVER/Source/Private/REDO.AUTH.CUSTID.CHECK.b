* @ValidationCode : MjotMTc4MDQ2MzgyMjpDcDEyNTI6MTY4MjQxMjMyNzgyMTpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.CUSTID.CHECK
*--------------------------------------------------------------------------------------------------------------------------------
*   DESCRIPTION :
*
*   LAUNCHES NEXT VERSION
*
*--------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JOAQUIN COSTA
*
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------------------------------
* Date             Author          Reference         Description
* MAR-30-2012      J COSTA         GRUPO 7           Initial creation
* FEB-11-2013      Pradeep S       PACS00249000      New task changed to Next Task
* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 NO CHANGE
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE
*------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_REDO.ID.CARD.CHECK.COMMON
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
*CALL EB.SET.NEW.TASK(WNEXT.VERSION)
    CALL EB.SET.NEXT.TASK(WNEXT.VERSION)  ;* PACS00249000 - S/E
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1
*
    WNEXT.VERSION = R.NEW(REDO.CUS.PRF.T24.VERSION) : " I F3"
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 1
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1

        END CASE
*       Increase
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*
END
