* @ValidationCode : MjotMzc4Nzc2NjM0OkNwMTI1MjoxNjk4MjM0NzQ4MzUzOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Oct 2023 17:22:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>79</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE APAP.GET.CERITOS.OPTFMT(MOB.REQUEST, MOB.RESPONSE)
*---------------------------------------------------------------------------------------------------
* Description :
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh          R22 Manual Conversion                   Nochange
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_EB.MOB.FRMWRK.COMMON
*---------------------------------------------------------------------------------------------------

    GOSUB INITIALISE

    GOSUB PROCESS

RETURN

*---------------------------------------------------------------------------------------------------
INITIALISE:

    MOB.RESPONSE.SAVE = MOB.RESPONSE

    NO.OF.FLDS = DCOUNT(MOB.RESPONSE<1, 1>, @SM)

    NO.OF.SEP = DCOUNT(MOB.RESPONSE<1, 2, 1>, ':')

    LOCATE 'QUANTITY' IN MOB.RESPONSE<1, 1, 1> SETTING SUB.POS ELSE NULL

    F.REDO.LY.POINTS.TOT  =""
    FN.REDO.LY.POINTS.TOT = "F.REDO.LY.POINTS.TOT"
    CALL OPF(FN.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT)

RETURN

*---------------------------------------------------------------------------------------------------
PROCESS:
    Y.YEAR = TODAY[1,4]
    LOCATE 'CUSTOMER.ID' IN MOB.RESPONSE<1, 1, 1> SETTING ARR.POS ELSE NULL

    R.REDO.LY.POINTS.TOT = ''
    E.REDO.LY.POINTS.TOT = ''
    Y.ID.LY="ALL"
    CALL F.READ(FN.REDO.LY.POINTS.TOT, Y.ID.LY, R.REDO.LY.POINTS.TOT, F.REDO.LY.POINTS.TOT, E.REDO.LY.POINTS.TOT)




    MOB.RESPONSE<1> = MOB.RESPONSE.SAVE<1>
    TOT.QUANTITY = 0
    FOR SEP.CNT = 1 TO NO.OF.SEP
        FOR FLD.CNT = 1 TO NO.OF.FLDS
            MOB.RESPONSE<1, SEP.CNT+1, FLD.CNT> = MOB.RESPONSE.SAVE<1, 2, FLD.CNT>[':', SEP.CNT , 1]
            IF FLD.CNT EQ SUB.POS THEN
                TOT.QUANTITY += MOB.RESPONSE.SAVE<1, 2, FLD.CNT>[':', SEP.CNT , 1]
            END
        NEXT FLD.CNT
    NEXT SEP.CNT

*    MOB.RESPONSE<1, SEP.CNT+2, SUB.POS> = TOT.QUANTITY

RETURN

*---------------------------------------------------------------------------------------------------

END
