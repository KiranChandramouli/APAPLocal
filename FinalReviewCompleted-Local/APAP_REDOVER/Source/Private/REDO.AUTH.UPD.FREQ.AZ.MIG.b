* @ValidationCode : MjotNzQxNDk0NDk6Q3AxMjUyOjE2ODI0MTIzMjg5NTg6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:28
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
SUBROUTINE REDO.AUTH.UPD.FREQ.AZ.MIG
*--------------------------------------------------------------------------------------
*Description: This routine is used to update the month end freq. for migrated deposits.
* Also it is attached in the version of AZ.ACCOUNT,MB.DM.LOAD
*Reference: PACS00269507
****---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:

*-------------------------------------------------------------------------------

* DATE			WHO			 REFERENCE		DESCRIPTION

* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 NO CHANGE
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE

*-------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT

    GOSUB PROCESS
    GOSUB PGM.END
RETURN
*-----------
PROCESS:
*----------
    Y.DATE = R.NEW(AZ.VALUE.DATE)
*    Y.YEAR.MONTH = Y.DATE[1,6]
*    Y.MONTH = Y.DATE[5,2]
*
*    BEGIN CASE
*
*    CASE (Y.MONTH EQ 01) OR (Y.MONTH EQ 03) OR (Y.MONTH EQ 05) OR (Y.MONTH EQ 07) OR (Y.MONTH EQ 08) OR (Y.MONTH EQ 10) OR (Y.MONTH EQ 12)
*        YLAST.DAY = "31"
*
*    CASE (Y.MONTH EQ 02)
*        IF MOD(Y.DATE[1,4],4) EQ 0 THEN
*            YLAST.DAY = "29"
*        END ELSE
*            YLAST.DAY = "28"
*        END
*
*    CASE (Y.MONTH EQ 04) OR (Y.MONTH EQ 06) OR (Y.MONTH EQ 09) OR (Y.MONTH EQ 11)
*        YLAST.DAY = "30"
*
*    CASE OTHERWISE
*        YLAST.DAY = "31"
*
*    END CASE
*
*    Y.FREQ = Y.YEAR.MONTH:YLAST.DAY:"M0131"

    Y.MONTH.FREQ = "M0130"
    TEMP.COMI = COMI
    COMI = Y.DATE:Y.MONTH.FREQ
    CALL CFQ
    Y.FREQ = COMI
    COMI = TEMP.COMI

    VAR.TYPE.OF.SCHDLE   = R.NEW(AZ.TYPE.OF.SCHDLE)<1,1>

    IF VAR.TYPE.OF.SCHDLE EQ "I" THEN
        R.NEW(AZ.FREQUENCY) = Y.FREQ
    END

RETURN
*----------
PGM.END:
*---------
END
