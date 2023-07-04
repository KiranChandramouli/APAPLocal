* @ValidationCode : MjotMTUzMjM1NDcwMjpDcDEyNTI6MTY4MDY4MDIyNjIxNjphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:07:06
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
$PACKAGE APAP.DRREG
SUBROUTINE DR.REG.RCL.CUS.CODE.INT.TAX
**************************************************************************
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
* 01-Aug-2014     V.P.Ashokkumar      PACS00305231 - Added RELATION file
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

    FLD4 = ''; YLID.CUSTOMER = ''
    BEGIN CASE
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS> NE ''
            YLID.CUSTOMER = R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS>
            FLD4 = YLID.CUSTOMER[1,3]:'-':YLID.CUSTOMER[4,7]:'-':YLID.CUSTOMER[11,1]
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS> NE ''
            YLID.CUSTOMER = R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS>
            FLD4 = YLID.CUSTOMER[1,1]:'-':YLID.CUSTOMER[2,2]:'-':YLID.CUSTOMER[4,5]:'-':YLID.CUSTOMER[9,1]
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS> NE ''
            FLD4 = R.CUSTOMER<EB.CUS.NATIONALITY>:R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS>
        CASE R.CUSTOMER<EB.CUS.LEGAL.ID> NE ''
            FLD4 = R.CUSTOMER<EB.CUS.NATIONALITY>:R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    END CASE
    COMI = FLD4
RETURN

END
