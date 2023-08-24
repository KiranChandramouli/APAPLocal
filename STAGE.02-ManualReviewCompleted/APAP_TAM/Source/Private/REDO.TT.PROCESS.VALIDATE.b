* @ValidationCode : MjotMTQ4NTA4MDIzMDpDcDEyNTI6MTY4MTEwOTg0MzM1NjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 12:27:23
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
SUBROUTINE REDO.TT.PROCESS.VALIDATE
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.PART.TT.PROCESS table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.TT.PROCESS.VALIDATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*29.06.2010      JEEVA T         ODR-2010-08-0017    INITIAL CREATION
*10.04.2023      Conversion Tool       R22            Auto Conversion     - No changes
*10.04.2023      Shanmugapriya M       R22            Manual Conversion   - No changes
*
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.TT.PROCESS
    $INSERT I_GTS.COMMON
    $INSERT I_F.AA.ARRANGEMENT

    GOSUB INIT
    GOSUB PROCESS
RETURN

*---
INIT:
*---
    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT= ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    ACC.CURR =''
    VAR.CURRENCY = ''
    R.AA.ARRANGE =''
RETURN
*-------
PROCESS:
*-------
*Checking valid curreny for arrangement account
    VAR.AA.ID=R.NEW(TT.PRO.ARRANGEMENT.ID)
    CALL F.READ(FN.AA.ARRANGEMENT,VAR.AA.ID,R.AA.ARRANGE,F.AA.ARRANGEMENT,AA.ARR.ERR)
    ACC.CURR=R.AA.ARRANGE<AA.ARR.CURRENCY>
    VAR.CURRENCY=R.NEW(TT.PRO.CURRENCY)
    IF ACC.CURR NE VAR.CURRENCY THEN
        AF=TT.PRO.CURRENCY
        ETEXT='EB-MIS.MATCH.CURR'
        CALL STORE.END.ERROR
    END
RETURN
*------------------------------------------------------------------------------------
END
