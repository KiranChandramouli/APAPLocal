* @ValidationCode : MjoxMjUxMTg2OTQxOkNwMTI1MjoxNjgwNjA1MjUwOTI1OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:17:30
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
