* @ValidationCode : MjoxMTE3NjQ1MjQ1OkNwMTI1MjoxNjg1OTUzMDIxMTE0OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jun 2023 13:47:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE S.REDO.CHECK.EMPTY.FIELD(F.NO, M.NO, S.NO, CALL.SEE)   ;*R22 Manual Conversion - Changes FUNCTION to SUBROUTINE
*-----------------------------------------------------------------------------
* Allows to check if the R.NEW content is blank or empty
*
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package infra.eb
*
* Input
* ------------
*                 F.NO          Field Number
*                 M.NO          Multivalue position
*                 S.NO          Subvalue position
*                 CALL.SEE      @TRUE if the routine has to call STORE.END.ERROR
*
* Output
* --------------
*                returns @TRUE if the current value is empty or blank
*
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
*23-05-2023      HARSHA         AUTO R22 CODE CONVERSION          No changes
*23-05-2023      HARSHA         MANUAL R22 CODE CONVERSION        Changes FUNCTION to SUBROUTINE
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN Y.RETURN

* ----------------------------------------------------------------------------------
INITIALISE:
* ----------------------------------------------------------------------------------
    IF M.NO EQ '' THEN
        M.NO = 1
    END
    IF S.NO EQ '' THEN
        S.NO = 1
    END
    IF CALL.SEE EQ '' THEN
        CALL.SEE = @FALSE
    END

RETURN
* ----------------------------------------------------------------------------------
PROCESS:
* ----------------------------------------------------------------------------------

    Y.RETURN = R.NEW(F.NO)<1,M.NO,S.NO> EQ ''
    IF Y.RETURN AND CALL.SEE THEN
        AF = F.NO
        AV = M.NO
        AS = S.NO
        ETEXT = "EB-INPUT.MISSING"
        CALL STORE.END.ERROR
    END

RETURN
*-----------------------------------------------------------------------------
END
