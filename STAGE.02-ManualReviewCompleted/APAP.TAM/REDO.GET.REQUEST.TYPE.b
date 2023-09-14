* @ValidationCode : MjoxNDQzNTU0MTAyOkNwMTI1MjoxNjgxMTEzNjM5OTQ2OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:30:39
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
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*10/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             FM TO @FM
*10/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.GET.REQUEST.TYPE(Y.FINAL.ARRAY)
*--------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : S.Dhamu
* Program Name  : NOFILE.REDO.APAP.CARD.REQ
* ODR NUMBER    : ODR-2010-03-0092
*----------------------------------------------------------------------------------
* Description   : This is a Nofile routine for the Enquiry %REDO.ENQ.REQUEST.TYPE
*                 to display the value AUTOMATIC & MANUAL
* In parameter  : None
* out parameter : None
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*   DATE             WHO            REFERENCE         DESCRIPTION
* 29-06-2011        Dhamu.S     ODR-2010-03-0092   Initial Creation
* ----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    Y.FINAL.ARRAY = 'AUTOMATIC':@FM:'MANUAL'

RETURN
*****************
END
*---------------------------End of Program------------------------------------------
