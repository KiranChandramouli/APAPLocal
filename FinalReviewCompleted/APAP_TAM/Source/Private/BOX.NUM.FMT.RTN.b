* @ValidationCode : MjoxMjUxMTg2OTQxOkNwMTI1MjoxNjg0ODQxODU0NDE5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:07:34
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
*-----------------------------------------------------------------------------------
* Modification History:
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*04/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*04/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE BOX.NUM.FMT.RTN(Y.DATA)

    $INSERT I_COMMON
    $INSERT I_EQUATE

    BOX.NUM = ''

    BOX.NUM = Y.DATA

    Y.DATA = FIELD(BOX.NUM, "-", 1, 1)

RETURN

END
