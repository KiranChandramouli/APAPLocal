* @ValidationCode : MjoxMTIxNTI2MzAwOkNwMTI1MjoxNjg0MjIyNzgwNjI4OklUU1M6LTE6LTE6MTk3OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:09:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 197
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE DR.REGN16.GET.CUST.TYPE
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
* 21/08/2014          Ashokkumar            PACS00366332- Corrected the Industry value
*Modification
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INSER TAM.BP TO $INSERT
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -CALL RTN FORMAT MODIFIED
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.INDUSTRY
    $INSERT I_F.REDO.CATEGORY.CIUU

    CUST.ID = COMI
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    R.CUSTOMER = ''; CUSTOMER.ERR = ''
    CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
*CALL DR.REG.GET.CUST.TYPE(R.CUSTOMER,OUT.ARR)  ;*R22 MANUAL CODE CONVERSION
    CALL APAP.LAPAP.drRegGetCustType(R.CUSTOMER,OUT.ARR) ;*R22 MANUAL CODE CONVERSION
    COMI = OUT.ARR<1>
RETURN
END
