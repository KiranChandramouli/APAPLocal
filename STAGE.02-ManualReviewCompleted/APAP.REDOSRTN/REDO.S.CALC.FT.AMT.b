* @ValidationCode : MjotNDY2OTg1MjQwOkNwMTI1MjoxNjgwNzc1ODUzOTk3OjkxNjM4Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:40:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 91638
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.CALC.FT.AMT
    $INSERT I_COMMON
    $INSERT I_EQUATE

*DESCRIPTIONS:
*-------------
* This is Hook routine attached to TOTAL.CREDIT field in RAD.CONDUIT.MAPPING table
* This routine calculates the total credit amount

*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*

* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*

*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                    Reference             Description
* 12-OCT-2010    KAVITHA(TEMENOS)        ODR-2009-12-0290      INITIAL VERSION
*Modification history
*Date                Who               Reference                  Description
*06-04-2023      conversion tool     R22 Auto code conversion     No changes
*06-04-2023      Mohanraj R          R22 Manual code conversion   No changes



    ASSIGN.AMT = COMI
    TOT.LENGTH = LEN(ASSIGN.AMT)
    CREDIT.AMOUNT = COMI[4,TOT.LENGTH]
*    CREDIT.AMOUNT = CREDIT.AMOUNT * 100
    COMI = CREDIT.AMOUNT

RETURN
END
