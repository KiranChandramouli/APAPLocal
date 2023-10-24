* @ValidationCode : MjoxMTQ0Njc2NzIzOkNwMTI1MjoxNjk3NTM4OTA4ODAxOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Oct 2023 16:05:08
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

SUBROUTINE REDO.ATH.STLMT.FILE.PROCESS(STML.FILE)
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.ATH.STLMT.FILE.PROCESS
*Date              : 06.12.2010
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
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 10-APR-2023      Harishvikram C     Manual R22 conversion      No changes
*17/10/2023	VIGNESHWARI       ADDED COMMENT FOR ATM CHANGES      LINES IS ADDED

*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ATH.STLMT.PARAM
    $INSERT I_REDO.ATH.STLMT.FILE.PROCESS.COMMON

	DEBUG	;* ATM changes by Mario
    GOSUB PROCESS

RETURN

*-------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------
DEBUG	;* ATM changes by Mario

    CALL F.READ(FN.REDO.ATH.STLMT.CNCT.FILE,STML.FILE,R.REDO.ATH.STLMT.CNCT.FILE,F.REDO.ATH.STLMT.CNCT.FILE,CNCT.ERR)

    IF R.REDO.ATH.STLMT.CNCT.FILE NE '' THEN
        TC.CODE=R.REDO.ATH.STLMT.CNCT.FILE<2>[1,4]
        LOCATE TC.CODE IN R.REDO.ATH.STLMT.PARAM<ATH.STM.PARAM.TXN.CODE,1> SETTING POS.TC THEN
            IN.RTN=R.REDO.ATH.STLMT.PARAM<ATH.STM.PARAM.IN.PROCESS.RTN,POS.TC>
            IN.USR.DEF.RTN= R.REDO.ATH.STLMT.PARAM<ATH.STM.PARAM.IN.USR.DEF.RTN,POS.TC>
            ACCT.IN.RTN= R.REDO.ATH.STLMT.PARAM<ATH.STM.PARAM.IN.ACCT.RTN,POS.TC>
        END

        IF IN.RTN NE '' THEN
            CALL @IN.RTN(R.REDO.ATH.STLMT.CNCT.FILE)

            IF CONT.FLAG EQ 'TRUE' THEN
                CALL F.DELETE(FN.REDO.ATH.STLMT.CNCT.FILE,STML.FILE)
                RETURN
            END
        END

        IF IN.USR.DEF.RTN NE '' THEN
            CALL @IN.USR.DEF.RTN
        END

        IF ACCT.IN.RTN NE '' THEN
            CALL @ACCT.IN.RTN
        END
    END
    CALL F.DELETE(FN.REDO.ATH.STLMT.CNCT.FILE,STML.FILE)
RETURN
END
