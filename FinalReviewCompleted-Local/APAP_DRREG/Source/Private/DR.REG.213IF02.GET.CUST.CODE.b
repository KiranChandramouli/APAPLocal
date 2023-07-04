* @ValidationCode : MjoxMjYwNTAyNTYxOkNwMTI1MjoxNjgwNjA5NTI2ODYwOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Apr 2023 17:28:46
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
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*04-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*04-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION       NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE DR.REG.213IF02.GET.CUST.CODE(CUSTOMER.CODE,CIDENT.POS,RNC.POS)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
* Incomming customer record
* Outgoing - CUSTOMER.CODE


    R.CUSTOMER =  CUSTOMER.CODE
    CUSTOMER.CODE = ''

    BEGIN CASE

        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS> NE ''
            CUSTOMER.ID = R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS>
            CUSTOMER.CODE = CUSTOMER.ID[1,3]:'-':CUSTOMER.ID[4,7]:'-':CUSTOMER.ID[11,1]
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS> NE ''
            CUSTOMER.ID =  R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS>
            CUSTOMER.CODE = CUSTOMER.ID[1,1]:'-':CUSTOMER.ID[2,2]:'-':CUSTOMER.ID[4,5]:'-':CUSTOMER.ID[9,1]
        CASE R.CUSTOMER<EB.CUS.LEGAL.ID> NE ''
            CUSTOMER.CODE =  R.CUSTOMER<EB.CUS.NATIONALITY> : R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    END CASE


RETURN
