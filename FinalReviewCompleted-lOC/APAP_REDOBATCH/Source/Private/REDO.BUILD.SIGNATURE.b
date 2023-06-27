* @ValidationCode : MjotMzU3NjA5NTkzOkNwMTI1MjoxNjgwNzkwMTEwNjc3OklUU1M6LTE6LTE6MTkzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 193
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BUILD.SIGNATURE(ENQ.DATA)
*---------------------------------------------------
*Description: This routine is to  Build routine to pass the acc no. & cus id as incoming arg.
*---------------------------------------------------
* Input  Arg: ENQ.DATA
* oUTPUT Arg: ENQ.DATA
* Deals with: REDO.IM.CONSULTA.FIRMAS
*---------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON

    GOSUB PROCESS
RETURN
*---------------------------------------------------
PROCESS:
*---------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


    LOCATE 'IMAGE.REFERENCE' IN ENQ.DATA<2,1> SETTING POS1 THEN
        Y.AC.ID = ENQ.DATA<4,POS1>
    END

    IF Y.AC.ID THEN
        CALL F.READ(FN.ACCOUNT,Y.AC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        IF R.ACCOUNT THEN
            ENQ.DATA<4,POS1> = ENQ.DATA<4,POS1>:' ':R.ACCOUNT<AC.CUSTOMER>
        END
    END


RETURN
END
