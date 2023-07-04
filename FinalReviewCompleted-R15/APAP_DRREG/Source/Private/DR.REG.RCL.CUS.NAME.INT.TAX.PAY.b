* @ValidationCode : Mjo2OTkyMjkzMDE6Q3AxMjUyOjE2ODQ4NTY4NzIzNDc6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:52
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
$PACKAGE APAP.DRREG

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
