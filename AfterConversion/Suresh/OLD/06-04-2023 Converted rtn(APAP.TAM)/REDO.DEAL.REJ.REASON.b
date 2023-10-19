* @ValidationCode : MjotMjcyNzk4NTk0OkNwMTI1MjoxNjgwNzc1MzQyMjk0OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:32:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
