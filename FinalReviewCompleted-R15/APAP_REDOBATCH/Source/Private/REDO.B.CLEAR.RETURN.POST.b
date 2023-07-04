* @ValidationCode : MjotOTY0MTM2ODkzOkNwMTI1MjoxNjgwNzkwMTA3MDkwOklUU1M6LTE6LTE6OTA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 90
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CLEAR.RETURN.POST
*-----------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : ganesh r
* PROGRAM NAME : REDO.B.CLEAR.RETURN.POST
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO             REFERENCE             DESCRIPTION
* 21.09.2010  ganesh r            ODR-2010-09-0251   INITIAL CREATION
* 04-APR-2023  Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023  Harishvikram C   Manual R22 conversion      No changes
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CLEAR.RETURN.COMMON
*------------------------------------------------------------------------------------------
    GOSUB PROCESS
RETURN

PROCESS:
*------------------------------------------------------------------------------------------
*below 3 lines commented to improve performance
*    IF INT.CODE THEN
*        CALL REDO.INTERFACE.ACT.POST(INT.CODE)
*    END
    SEL.CMD = "SELECT ":VAR.FILE.PATH
    CALL EB.READLIST(SEL.CMD,FILE.LIST,'',NO.OF.REC,RET.ERR)

    LOOP
        REMOVE VAR.APERTA.ID FROM FILE.LIST SETTING FILE.POS
    WHILE VAR.APERTA.ID:FILE.POS

        DAEMON.CMD = "DELETE ":VAR.FILE.PATH:" ":VAR.APERTA.ID
        EXECUTE DAEMON.CMD

    REPEAT
RETURN

END
