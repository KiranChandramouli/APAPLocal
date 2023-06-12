* @ValidationCode : MjotMTg0NjkwMTgzMDpDcDEyNTI6MTY4MjA3ODg3MDU4MTpJVFNTOi0xOi0xOjE4NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:37:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 186
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE E.REDO.BUILD.PART.DISB.PROC(ENQ.DATA)
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type : BUILD.ROUTINE
* Attached to     : REDO.E.PART.DESEMBOLSO
* Attached as     : BUILD.ROUTINE
* Primary Purpose :
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : Sivakumar K
* Date            : 2013-03-19
*
* 18-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 18-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.AA.ARRANGEMENT
*************************************************************************

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

*==========
INITIALISE:
*==========

    FN.AA.ARR = 'F.AA.ARRANGEMENT'
    F.AA.ARR = ''
    CALL OPF(FN.AA.ARR,F.AA.ARR)

RETURN

*=======
PROCESS:
*=======

    LOCATE 'ID.ARRANGEMENT' IN ENQ.DATA<2,1> SETTING AA.POS THEN
        CALL F.READ(FN.AA.ARR,ENQ.DATA<4,1>,R.ARRANGEMENT,F.AA.ARR,AA.ARR.ERR)
        IF R.ARRANGEMENT THEN
            ENQ.DATA<2,1> = 'LOAN.AC'
            ENQ.DATA<4,1> = R.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
        END
    END

RETURN

END
