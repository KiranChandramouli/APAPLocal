* @ValidationCode : MjotMTYxMjU3MTM3NDpDcDEyNTI6MTY4MjMzMTMyMTQ4NDpJVFNTOi0xOi0xOjE4ODoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 188
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.E.BLD.ALT.ACCOUNT(ENQ.DATA)
*
* Description: The routine to get the actual Account number for the Alternative ID.
* Dev By: Ashokkumar
*
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ALTERNATE.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'; F.ALTERNATE.ACCOUNT = ''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)
RETURN

PROCESS:
********
    LOCATE "ARRANGEMENT.ID" IN ENQ.DATA<2,1> SETTING SYSD.POS THEN
        YALTER.ID = ENQ.DATA<4,SYSD.POS>
        IF YALTER.ID NE '' THEN
            R.ALT.AC = ''; ALT.AC.ERR = ''
            CALL F.READ(FN.ALTERNATE.ACCOUNT,YALTER.ID,R.ALT.AC,F.ALTERNATE.ACCOUNT,ALT.AC.ERR)
            IF R.ALT.AC THEN
                YALTER.ID = R.ALT.AC<AAC.GLOBUS.ACCT.NUMBER>
            END
        END
        ENQ.DATA<3,SYSD.POS> = "EQ"
        ENQ.DATA<4,SYSD.POS> = YALTER.ID
    END
RETURN

END
