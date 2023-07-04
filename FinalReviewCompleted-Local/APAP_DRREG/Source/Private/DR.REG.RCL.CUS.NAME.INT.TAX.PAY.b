$PACKAGE APAP.DRREG
* @ValidationCode : Mjo2OTkyMjkzMDE6Q3AxMjUyOjE2ODA2ODA2MDExNTY6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:13:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

SUBROUTINE DR.REG.RCL.CUS.NAME.INT.TAX.PAY
*-----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
* 01-Aug-2014     V.P.Ashokkumar      PACS00305231 - Added customer relation check
*DATE               WHO                       REFERENCE                 DESCRIPTION
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_DR.REG.INT.TAX.PAYMENT.COMMON
    $INSERT I_DR.REG.INT.TAX.COMMON

    R.CUSTOMER = RCL$INT.TAX(3)
    L.CU.TIPO.CL.VAL = ''; YCUS.NME = ''
    L.CU.TIPO.CL.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS>
    BEGIN CASE
        CASE L.CU.TIPO.CL.VAL EQ 'PERSONA FISICA'
            YCUS.NME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
        CASE L.CU.TIPO.CL.VAL EQ 'CLIENTE MENOR'
            YCUS.NME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
        CASE L.CU.TIPO.CL.VAL EQ 'PERSONA JURIDICA'
            YCUS.NME = R.CUSTOMER<EB.CUS.NAME.1,1>:' ':R.CUSTOMER<EB.CUS.NAME.2,1>
    END CASE
    COMI = YCUS.NME
RETURN
END
