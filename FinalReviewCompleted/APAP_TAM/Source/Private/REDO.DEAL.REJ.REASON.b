* @ValidationCode : MjotMjcyNzk4NTk0OkNwMTI1MjoxNjg0ODQyMDk1MjQ3OklUU1M6LTE6LTE6MTkzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:35
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
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.DEAL.REJ.REASON(Y.REJ.CODE)
*--------------------------------------------------------
*Description: This routine is to return the description of return code
*--------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.REJECT.REASON

    GOSUB PROCESS
RETURN
*--------------------------------------------------------
PROCESS:
*--------------------------------------------------------

    Y.REDO.REJ.CODE = Y.REJ.CODE
    Y.REJ.CODE      = ''


    FN.REDO.REJECT.REASON = 'F.REDO.REJECT.REASON'
    F.REDO.REJECT.REASON  = ''
    CALL OPF(FN.REDO.REJECT.REASON,F.REDO.REJECT.REASON)

    CALL F.READ(FN.REDO.REJECT.REASON,Y.REDO.REJ.CODE,R.REDO.REJECT.REASON,F.REDO.REJECT.REASON,REJ.ERR)

    IF R.REDO.REJECT.REASON<REDO.REJ.DESC,LNGG> THEN
        Y.REJ.CODE = R.REDO.REJECT.REASON<REDO.REJ.DESC,LNGG>
    END ELSE
        Y.REJ.CODE = R.REDO.REJECT.REASON<REDO.REJ.DESC,1>
    END


RETURN
END
