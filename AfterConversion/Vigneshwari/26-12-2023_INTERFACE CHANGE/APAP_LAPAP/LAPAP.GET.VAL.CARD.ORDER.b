* @ValidationCode : MjotNjAxNzY3NTQ4OkNwMTI1MjoxNzAzNTIwNTQyNzczOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Dec 2023 21:39:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.GET.VAL.CARD.ORDER
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*DATE			               AUTHOR					Modification                            DESCRIPTION
*22-12-2023	                  VIGNESHWARI      			 ADDED COMMENT FOR INTERFACE CHANGES          SQA-12193 - By Santiago-NO CHANGES
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    Y.RETURN.VAL = COMI
    COMI = FIELD(Y.RETURN.VAL,@VM,1)
    
RETURN
END
