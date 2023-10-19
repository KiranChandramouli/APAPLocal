* @ValidationCode : MjotMzgzNzgyODIzOkNwMTI1MjoxNjgxODA0OTgxOTk5OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 13:33:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.RATE.CHANGE.INT
*----------------------------------------------------------------
* DESCRIPTION: This routine is a validation routine to make margin Field as no-inputtable

*----------------------------------------------------------------
* Modification History :
*
*  DATE             WHO          REFERENCE           DESCRIPTION
* 12-Jul-2011     H GANESH     PACS00055012 - B.16  INITIAL CREATION
*----------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*18-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*18-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*--------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.RATE.CHANGE.CRIT

    GOSUB PROCESS
RETURN

*----------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------
    IF COMI EQ '' THEN
        RETURN
    END ELSE
        GOSUB CHECK.COND
    END

RETURN
*----------------------------------------------------------------
CHECK.COND:
*----------------------------------------------------------------

    IF R.NEW(RATE.CHG.PROP.SPRD.CHG)<1,AV> NE '' THEN
        ETEXT = 'EB-REDO.MARGIN.NOT.ALLW'
        CALL STORE.END.ERROR
        RETURN
    END
RETURN
END
