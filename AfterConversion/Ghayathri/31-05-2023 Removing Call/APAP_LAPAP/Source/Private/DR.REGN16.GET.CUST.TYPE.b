* @ValidationCode : MjoxOTQwMDEzOTkyOkNwMTI1MjoxNjg1NTI3NjU1MDYxOmhhaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 15:37:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
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
    APAP.LAPAP.drRegGetCustType(R.CUSTOMER,OUT.ARR) ;*R22 MANUAL CODE CONVERSION
    COMI = OUT.ARR<1>
RETURN
END
