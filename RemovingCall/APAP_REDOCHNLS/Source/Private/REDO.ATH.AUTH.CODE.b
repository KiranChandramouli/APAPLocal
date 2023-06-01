* @ValidationCode : MjotNjg3NzM1NzE0OkNwMTI1MjoxNjg0ODU0MDUxNTU5OklUU1M6LTE6LTE6LTEwOjE6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:30:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -10
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS
SUBROUTINE  REDO.ATH.AUTH.CODE
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.ATH.AUTH.CODE
*Date              : 23.11.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*23/11/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version

* 10-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 10-APR-2023      Harishvikram C   Manual R22 conversion      CALL routine format modified
*------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.ATH.STLMT.FILE.PROCESS.COMMON
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.REDO.CARD.BIN

    GOSUB INIT
RETURN

*------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------


*CALL APAP.REDOCHNLS.REDO.ATH.VAL.DELAY ;*Manual R22 conversion
    CALL APAP.REDOCHNLS.redoAthValDelay();*Manual R22 conversion


    IF NOT(Y.FIELD.VALUE) THEN
        ERROR.MESSAGE="NO.AUTH.CODE"
    END ELSE
        AUTH.CODE=Y.FIELD.VALUE
    END
RETURN
END
