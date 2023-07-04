* @ValidationCode : MjoxNzIyNDUwMzY6Q3AxMjUyOjE2ODE5OTU5ODYzNjk6SVRTUzotMTotMToxODg6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Apr 2023 18:36:26
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
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.REJECT.DESC
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------
* Modification History
* DATE            ODR           BY              DESCRIPTION
* 25-08-2011      PACS00190859  KAVITHA     For enquiry
*
* 13-APR-2023      Conversion tool    R22 Auto conversion       No changes
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_F.USER
    $INSERT I_F.REDO.REJECT.REASON

    GOSUB OPEN.PARA
    GOSUB PROCESS

RETURN
*-----------------------
OPEN.PARA:

    FN.REDO.REJECT.REASON = 'F.REDO.REJECT.REASON'
    F.REDO.REJECT.REASON = ''
    CALL OPF(FN.REDO.REJECT.REASON,F.REDO.REJECT.REASON)


RETURN

PROCESS:
**********

    REDO.REJECT.REASON.ID = O.DATA
    LANGUAGE.CODE = LNGG

    CALL F.READ(FN.REDO.REJECT.REASON,REDO.REJECT.REASON.ID,R.REDO.REJECT.REASON,F.REDO.REJECT.REASON,REDO.REJECT.REASON.ERR)

    IF R.REDO.REJECT.REASON THEN
        O.DATA = R.REDO.REJECT.REASON<REDO.REJ.DESC,LANGUAGE.CODE>
    END

    IF NOT(O.DATA) THEN
        O.DATA = R.REDO.REJECT.REASON<REDO.REJ.DESC,1>
    END


RETURN
END
