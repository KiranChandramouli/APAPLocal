* @ValidationCode : MjotODkxNDg3NDAwOkNwMTI1MjoxNjgyMzE1NTIzNDk4OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 11:22:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Item ID        : GDC-274
*-------------------------------------------------------------------------------------
* Description :
* ------------
* This program raise an error message whether the processed check belong to APAP.
* Este programa lanza error si el cheque procesado pertenece a APAP.
*-------------------------------------------------------------------------------------
* Modification History :
* ----------------------
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2019/03/19     Raquel P.S.         Initial development
*-------------------------------------------------------------------------------------
* Content summary :
* -----------------
* Versions : TELLER,L.APAP.COMPRA.CHQOBCO.ML ATTACHED AS VALIDATION ROUTINE
* EB.API record      : LAPAP.VERIFY.CK.APAP
* Routines       : LAPAP.VERIFY.CK.APAP
*-------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*24-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------------------


SUBROUTINE LAPAP.VERIFY.CK.APAP

    $INSERT I_COMMON    ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_GTS.COMMON    ;*R22 AUTO CODE CONVERSION.END

    FN.TT = "F.TELLER"
    F.TT = ""

    CALL OPF(FN.TT,F.TT)
    Y.L.TT.CONCEPT=COMI

    IF Y.L.TT.CONCEPT EQ '661'
    THEN
        ETEXT='CHEQUE DE APAP, PROCESAR POR LA OPCION CORRECTA'
        CALL STORE.END.ERROR

    END

END
