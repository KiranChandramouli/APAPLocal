* @ValidationCode : MjotMjAyMjI3NjEyODpDcDEyNTI6MTY5NzY5MTYwNjc0NTp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Oct 2023 10:30:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
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

* 10-APR-2023     Conversion tool    R22 Auto conversion                 No changes
* 10-APR-2023      Harishvikram C   Manual R22 conversion            CALL routine format modified

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
   APAP.REDOCHNLS.redoAthValDelay();*Manual R22 conversion	
  *  CALL REDO.ATH.VAL.DELAY  
    IF NOT(Y.FIELD.VALUE) THEN
        ERROR.MESSAGE="NO.AUTH.CODE"
    END ELSE
        AUTH.CODE=Y.FIELD.VALUE
    END
RETURN
END
