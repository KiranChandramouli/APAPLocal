* @ValidationCode : Mjo3MTkyODcwNjA6Q3AxMjUyOjE2ODM4OTI2MjM3MDI6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.DEAL.NAME(Y.FINAL.NAME)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.GET.INVENTORY.DETAIL
* ODR NUMBER    : PACS00099482
*--------------------------------------------------------------------------------------
* Description   : This routine attached deal slip to print details
* In parameter  : none
* out parameter : none
*--------------------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE                      DESCRIPTION
* 05-08-2011      JEEVA T            B.42                             INTITAL DEV
*-----------------------------------------------------------------------------------
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*10/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*10/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.H.ORDER.DETAILS
MAIN:

    GOSUB PROCESS
    GOSUB PGM.END
RETURN

PROCESS:

    Y.FINAL.NAME =FIELD(Y.FINAL.NAME,'_',2)
RETURN

PGM.END:

END
