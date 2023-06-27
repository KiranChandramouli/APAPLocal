* @ValidationCode : MjoxMjYwNTAyNTYxOkNwMTI1MjoxNjg0ODU2ODcwMzgwOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:50
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
