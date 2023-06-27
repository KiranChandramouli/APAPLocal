* @ValidationCode : MjotMTk2MDQ3NzkwMzpDcDEyNTI6MTY4MTEyMjg3NDgwNzphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 16:04:34
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
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*10-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*10-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*-----------------------------------------------------------------------------
SUBROUTINE DR.REGREP.GET.CUSTOMER.CODE(CUSTOMER.CODE,CUS.LOC.POS)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
* Incomming customer record
* Outgoing - CUSTOMER.CODE


    R.CUSTOMER =  CUSTOMER.CODE
    CUSTOMER.CODE = ''
    CIDENT.POS =  CUS.LOC.POS<1>
    RNC.POS = CUS.LOC.POS<2>
    NOUNICO.POS = CUS.LOC.POS<3>
    ACTNAC.POS = CUS.LOC.POS<4>


    BEGIN CASE

        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS> NE ''
            CUSTOMER.CODE = R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS>
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS> NE ''
            CUSTOMER.CODE =  R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS>
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,NOUNICO.POS> NE ''
            CUSTOMER.CODE =  R.CUSTOMER<EB.CUS.LOCAL.REF,NOUNICO.POS>
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,ACTNAC.POS> NE ''
            CUSTOMER.CODE =  R.CUSTOMER<EB.CUS.LOCAL.REF,ACTNAC.POS>
        CASE R.CUSTOMER<EB.CUS.LEGAL.ID> NE ''
            CUSTOMER.CODE =  R.CUSTOMER<EB.CUS.NATIONALITY> : R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    END CASE


RETURN
