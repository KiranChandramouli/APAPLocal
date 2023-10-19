$PACKAGE APAP.LAPAP
* @ValidationCode : MjoxMTM3NjUyMjE4OkNwMTI1MjoxNjkxNTYzODkyNzA2OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Aug 2023 12:21:32
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

*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
*Fecha Modif: 3/07/2023
*Autor: Laura Novas
*Descripcion: Se obtiene el ID del cliente a partir de una una cuenta o certificado cancelado.
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*09/08/2023      Suresh                     R22 Manual Conversion          T24.BP is removed
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.CLOS.CLOSCUS

    $INSERT  I_COMMON ;*R22 Manual Conversion - Start
    $INSERT  I_EQUATE
    $INSERT  I_ENQUIRY.COMMON
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.ACCOUNT.CLOSURE ;*R22 Manual Conversion - End

    FN.ACC = "F.ACCOUNT$HIS"
    FV.ACC = ""
    CALL OPF(FN.ACC,FV.ACC)

    ACC = O.DATA

    CALL EB.READ.HISTORY.REC(FV.ACC,ACC,R.ACC,ACC.ERROR)
    OPEND = R.ACC<AC.CUSTOMER>
    O.DATA = OPEND

RETURN

END
